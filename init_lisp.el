(setq lisp-simple-loop-indentation 1
      lisp-loop-keyword-indentation 6
      lisp-loop-forms-indentation 6
      blink-matching-paren nil)

(show-paren-mode 1)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(put :default-initargs
     'common-lisp-indent-function '(&rest))

(define-auto-insert 'lisp-mode '(insert ";;; -*- Mode: Lisp -*-\n"))

(require-and-eval (paredit paredit)

  (defvar paredit-space-for-delimiter-predicates nil)

  (defun paredit-space-for-delimiter-p (endp delimiter)
    ;; If at the buffer limit, don't insert a space.  If there is a word,
    ;; symbol, other quote, or non-matching parenthesis delimiter (i.e. a
    ;; close when want an open the string or an open when we want to
    ;; close the string), do insert a space.
    (and (not (if endp (eobp) (bobp)))
         (memq (char-syntax (if endp (char-after) (char-before)))
               (list ?w ?_ ?\"
                     (let ((matching (matching-paren delimiter)))
                       (and matching (char-syntax matching)))
                     (and (not endp)
                          (eq ?\" (char-syntax delimiter))
                          ?\) )))
         (catch 'exit
           (dolist (predicate paredit-space-for-delimiter-predicates)
             (if (not (funcall predicate endp delimiter))
                 (throw 'exit nil)))
           t)))

  (defvar common-lisp-octothorpe-quotation-characters '(?P))
  (defvar common-lisp-octothorpe-parameter-parenthesis-characters '(?A))
  (defvar common-lisp-octothorpe-parenthesis-characters '(?+ ?- ?C))

  (defun paredit-space-for-delimiter-predicate-common-lisp (endp delimiter)
    (or endp
        (let ((case-fold-search t)
              (look
               (lambda (prefix characters n)
                 (looking-back
                  (concat prefix (regexp-opt (mapcar 'string characters)))
                  (- (point) n)))))
          (let ((oq common-lisp-octothorpe-quotation-characters)
                (op common-lisp-octothorpe-parenthesis-characters)
                (opp common-lisp-octothorpe-parameter-parenthesis-characters))
            (cond ((eq (char-syntax delimiter) ?\()
                   (and (not (funcall look "#" op 2))
                        (not (funcall look "#[0-9]*" opp 20))))
                  ((eq (char-syntax delimiter) ?\")
                   (not (funcall look "#" oq 2)))
                  (t t))))))

  (add-hook 'lisp-mode-hook
            (defun common-lisp-mode-hook-paredit ()
              (make-local-variable 'paredit-space-for-delimiter-predicates)
              (add-to-list 'paredit-space-for-delimiter-predicates
                           'paredit-space-for-delimiter-predicate-common-lisp))))

(require-and-eval (redshank redshank))

(flet ((parens (mode)
         (when (featurep 'paredit)
           (add-hook mode 'paredit-mode))
         (when (featurep 'redshank)
           (add-hook mode 'redshank-mode))))
  (mapc 'parens '(emacs-lisp-mode-hook scheme-mode-hook
                  lisp-mode-hook)))

(setq slime-additional-font-lock-keywords nil)

(when (windows-p)
  (load (expand-file-name "~/quicklisp/slime-helper.el")))

(require-and-eval (slime slime)
  (defun load-slime ()
    (slime-setup '(slime-fancy
                   slime-sbcl-exts slime-scheme
                   slime-sprof slime-asdf
		   slime-indentation
                   ;; slime-cover
                   )) ;; slime-gauche
    (let ((slime-fasls-directory (if (desktop-p)
                                     "/tmp/slime-fasls/"
                                     (expand-file-name
                                      "~/lisp/fasls/from-slime/"))))
      (make-directory slime-fasls-directory t)
      (setq slime-compile-file-options
            `(:fasl-directory ,slime-fasls-directory)))

    (setq
     lisp-indent-function 'common-lisp-indent-function
     slime-complete-symbol-function 'slime-fuzzy-complete-symbol
     slime-net-coding-system 'utf-8-unix
     slime-startup-animation nil
     slime-auto-select-connection 'always
     common-lisp-hyperspec-root "file://home/stas/doc/comp/lang/lisp/HyperSpec/"
     inferior-lisp-program "ccl"
     slime-kill-without-query-p t
     slime-when-complete-filename-expand t
     slime-description-autofocus t 
     slime-repl-history-remove-duplicates t
     slime-repl-history-trim-whitespaces t
     slime-fuzzy-explanation ""
     slime-repl-history-file "~/.config/emacs/slime-history.eld"
     slime-asdf-collect-notes t
     slime-inhibit-pipelining nil
     ;; slime-compilation-finished-hook 'slime-list-compiler-notes
     slime-load-failed-fasl 'always
     lisp-loop-indent-subclauses nil
     lisp-loop-indent-forms-like-keywords t
     lisp-lambda-list-keyword-parameter-alignment t
     slime-export-symbol-representation-auto t
     slime-export-save-file t)
    
    (define-key slime-repl-mode-map "\C-c\C-u" 'slime-repl-delete-current-input)
    (define-key slime-mode-map "\C-c\M-i" 'slime-inspect-definition)
    (define-key slime-editing-map "\C-c\M-d" 'slime-disassemble-definition)
    
    (substitute-key-definition 'slime-xref-next-line 'next-line
                               slime-xref-mode-map)
    (substitute-key-definition 'slime-xref-prev-line 'previous-line
                               slime-xref-mode-map)
    (substitute-key-definition 'slime-goto-xref 'slime-show-xref
                               slime-xref-mode-map)
    
    (defun slime-selector (&optional other-window)
      (interactive)
      (message "Select [%s]: " 
               (apply #'string (mapcar #'car slime-selector-methods)))
      (let* ((slime-selector-other-window other-window)
             (sequence (save-window-excursion
                         (select-window (minibuffer-window))
                         (key-description (read-key-sequence nil))))
             (ch (cond ((= (length sequence) 1)
                        (elt sequence 0))
                       ((= (length sequence) 3)
                        (elt sequence 2))))
             (method (find ch slime-selector-methods :key #'car)))
        (cond (method 
               (funcall (third method)))
              (t
               (message "No method for character: ?\\%c" ch))))))
  
  (load-slime)

  (defun slime-reload ()
    (interactive)
    (mapc 'load-library
          (reverse (remove-if-not
                    (lambda (feature) (string-prefix-p "slime" feature))
                    (mapcar 'symbol-name features))))
    (setq slime-protocol-version (slime-changelog-date))

    (load-slime))
  
  (defun sbcl ()
    (interactive)
    (slime-start :program (if (windows-p)
                              "C:/Users/stas/sbcl/src/runtime/sbcl.exe"
                              "~/lisp/impl/sbcl/src/runtime/sbcl")
                 :program-args (list*
                                "--core"
                                (cond ((windows-p)
                                       "C:/Users/stas/sbcl/output/sbcl.core")
                                      ((desktop-p)
                                       "/tmp/fasls/sbcl-core")
                                      (t
                                       (expand-file-name "~/lisp/fasls/sbcl-core")))
                                (unless (windows-p)
                                  (list "--dynamic-space-size"
                                        (if (desktop-p)
                                            "8Gb"
                                            "4Gb"))))
                 :env (if (windows-p)
                          '("SBCL_HOME=C:/Users/stas/sbcl/contrib")
                          '("SBCL_HOME=/home/stas/lisp/impl/sbcl/contrib"))))

  (defun old-sbcl ()
    (interactive)
    (slime-start :program "/usr/local/bin/sbcl"))

  (defun sbcl-32 ()
    (interactive)
    (slime-start :program "~/lisp/impl/sbcl-x86/src/runtime/sbcl"
                 :program-args (list
                                "--dynamic-space-size" "1024"
                                "--core"
                                "/home/stas/lisp/impl/sbcl-x86/output/sbcl.core"
                                "--load" "/home/stas/lisp/configs/sbcl.lisp")
                 :env '("SBCL_HOME=/home/stas/lisp/impl/sbcl-x86/contrib")))
                  
  
  (macrolet ((define-lisps (&rest lisps)
               `(progn
                  ,@(loop for lisp in lisps
                          for consp = (consp lisp)
                          for name = (if consp (car lisp) lisp)
                          for path = (or (and consp (second lisp))
                                         (symbol-name name))
                          for coding = (when consp (third lisp))
                          collect `(defun ,name () (interactive)
                                          (slime ,path ',coding))))))

    (define-lisps
        (abcl nil iso-8859-1-unix)
        cmucl
      ccl clisp scl acl ecl
      (lw nil iso-8859-1-unix)
      (xcl nil iso-8859-1-unix)))

  (global-set-key "\C-z" 'slime-selector)

  (define-key slime-repl-mode-map "\C-cd"
    (lambda ()
      (interactive)
      (slime-select-connection (slime-current-connection)))))

;;; Scheme
(setq scheme-program-name "gosh"
      quack-default-program "gosh"
      scheme-mit-dialect nil
      quack-fontify-style 'emacs
      quack-global-menu-p nil
      quack-pretty-lambda-p t)

(require 'quack nil t)

;; (require-and-eval (lisppaste)
;;   (push '("http://paste\\.lisp\\.org/\\(\\+\\)\\|\\(display\\)"
;;           . lisppaste-browse-url)
;;         browse-url-browser-function))

(add-hook 'scheme-mode-hook
          (lambda ()
            (make-variable-buffer-local 'slime-complete-symbol-function)
            (setq slime-complete-symbol-function 'slime-complete-symbol*)))

;;; Clojure
(require-and-eval (clojure-mode clojure)
  (require 'clojure-mode)
  (add-to-list 'auto-mode-alist '("\\.\\([cC][lL][jJ]\\)\\'" . clojure-mode))

  (setf clojure-inferior-lisp-program
        "java -server -cp /home/stas/c/clojure/clojure.jar clojure.lang.Repl"))

;; (require-and-eval (swank-clojure swank-clojure)
;;   (setq swank-clojure-jar-path "/home/stas/c/clojure/clojure.jar")
;;   (add-hook 'slime-indentation-update-hooks 'swank-clojure-update-indentation)
;;   (add-hook 'slime-repl-mode-hook 'swank-clojure-slime-repl-modify-syntax t)
;;   (add-hook 'clojure-mode-hook 'swank-clojure-slime-mode-hook t)
;;   (add-to-list 'slime-lisp-implementations `(clojure ,(swank-clojure-cmd) :init 'swank-clojure-init) t)

;;   (defun clojure ()
;;     (interactive)
;;     (slime 'clojure)))

;;; Elisp

(setq comint-input-ignoredups t)

(defvar *jump-locations* nil)

(defun find-fun-location (name)
  (save-excursion
    (let* ((function (symbol-function name))
           (file-name (find-lisp-object-file-name name function)))
      (when (eq file-name 'C-source)
        (setq file-name (help-C-file-name function 'subr)))
      (find-function-search-for-symbol name nil file-name))))

(defun jump-to-fdefinition (fn)
  (interactive
   (list (or (function-called-at-point)
             (intern (completing-read "Find function: "
                                      obarray 'fboundp t nil nil)))))
  (let ((location (find-fun-location fn)))
    (if (cdr location)
        (progn
          (push (point-marker) *jump-locations*)
          (pop-to-buffer (car location))
          (goto-char (cdr location)))
        (message "Unable to find location"))))

(defun jump-back ()
  (interactive)
  (let ((location (pop *jump-locations*)))
    (when location
      (pop-to-buffer (marker-buffer location))
      (goto-char (marker-position location))
      (set-marker location nil))))

(require 'ielm)

(defun jump-to-ielm-buffer ()
  (interactive)
  (let ((start-new (get-buffer "*ielm*")))
    (switch-to-buffer-other-window "*ielm*")
    (unless start-new
      (ielm))))

(dolist (mode (list emacs-lisp-mode-map ielm-map))
  (define-key mode "\M-." 'jump-to-fdefinition)
  (define-key mode "\M-," 'jump-back))

(define-key emacs-lisp-mode-map "\C-c\C-z" 'jump-to-ielm-buffer)
(define-key ielm-map "\C-j" 'newline-and-indent)

(defun set-neighbour-buffer ()
  (set-buffer (window-buffer (next-window))))

(defun :dbg (message &optional tag)
  (with-current-buffer (get-buffer-create "*DBG*")
    (goto-char (point-max))
    (princ (format "%s %s" message (or tag "")) (current-buffer)))
  message)

(defun insert-slot (slot-name)
  (insert "(")
  (insert slot-name)
  (insert " :initarg :")
  (insert slot-name)
  (newline-and-indent)
  (insert ":initform nil")
  (newline-and-indent)
  (insert ":accessor ")
  (insert slot-name)
  (insert ")"))

(defun clos-slots ()
  (interactive)
  (loop for slot-name = (read-from-minibuffer "Slot name: ")
        until (equal slot-name "")
        do (insert-slot slot-name)
        (newline-and-indent)
        finally (delete-indentation)))
