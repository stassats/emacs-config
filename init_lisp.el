(setq lisp-simple-loop-indentation 1
      lisp-loop-keyword-indentation 6
      lisp-loop-forms-indentation 6
      blink-matching-paren nil)

(show-paren-mode 1)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(require-and-eval (paredit paredit)
  ;; Load patches
  ;;(mapc 'load (directory-files "~/.emacs.d/paredit/" t "paredit-.+\\.el"))
  )

;; (require 'redshank nil t)

(flet ((parens (mode)
         (when (featurep 'paredit)
           (add-hook mode 'paredit-mode))
         (when (featurep 'redshank)
           add-hook)))
  (mapc 'parens '(emacs-lisp-mode-hook scheme-mode-hook
                  lisp-mode-hook)))

(setq slime-additional-font-lock-keywords nil)

(require-and-eval (slime slime)
  (defun load-slime ()
    (slime-setup '(slime-fancy slime-sbcl-exts slime-scheme
                   slime-sprof))

    (setq
     lisp-indent-function 'common-lisp-indent-function
     slime-complete-symbol-function 'slime-fuzzy-complete-symbol
     slime-net-coding-system 'utf-8-unix
     slime-startup-animation nil
;     slime-auto-connect 'always
     slime-auto-select-connection 'always
     common-lisp-hyperspec-root "/home/stas/doc/comp/lang/lisp/HyperSpec/"
     inferior-lisp-program "ccl"
     slime-kill-without-query-p t
     slime-when-complete-filename-expand t
     slime-description-autofocus t
     slime-compile-file-options '(:fasl-directory
                                  "/home/stas/lisp/fasls/from-slime/")
     slime-repl-history-remove-duplicates t
     slime-repl-history-trim-whitespaces t)
    
    (define-key slime-repl-mode-map "\C-c\C-u" 'slime-repl-delete-current-input))
  
  (load-slime)

  (defun slime-reload ()
    (interactive)
    (mapc 'load-library
          (reverse (remove-if-not
                    (lambda (feature) (string-match "^slime.*" feature))
                    (mapcar 'symbol-name features))))
    (setq slime-protocol-version (slime-changelog-date))

    (load-slime))

  (macrolet ((define-lisps (&rest lisps)
               `(progn
                  ,@(loop for lisp in lisps
                          for consp = (consp lisp)
                          for name = (if consp (car lisp) lisp)
                          for path = (or (and consp (second lisp)) (symbol-name name))
                          for coding = (when consp (third lisp))
                          collect `(defun ,name () (interactive)
                                          (slime ,path ',coding))))))

    (define-lisps
        (sbcl "~/lisp/bin/sbcl")
        (ecl nil iso-8859-1-unix)
      (abcl nil iso-8859-1-unix)
      (cmucl nil iso-8859-1-unix)
      ccl clisp scl acl lw))

  (define-key global-map "\C-z" 'slime-selector)
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

(require-and-eval (lisppaste)
  (push '("http://paste\\.lisp\\.org/\\(\\+\\)\\|\\(display\\)" . lisppaste-browse-url)
        browse-url-browser-function))

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

(defun set-neighbour-buffer ()
  (set-buffer (window-buffer (next-window))))

(defun dbgmsg (message)
  (with-current-buffer (get-buffer-create "*DBG*")
    (goto-char (point-max))
    (print message (current-buffer)))
  message)
