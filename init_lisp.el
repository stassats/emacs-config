(setq lisp-simple-loop-indentation 1
      lisp-loop-keyword-indentation 6
      lisp-loop-forms-indentation 6
      blink-matching-paren nil)

(show-paren-mode 1)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(require 'paredit nil t)
(require 'redshank nil t)

(defmacro parens (mode)
  `(add-hook ',mode (lambda ()
                      ,(if (featurep 'paredit)
                           '(paredit-mode))
                      ,(if (featurep 'redshank)
                           '(turn-on-redshank-mode)))))

(parens lisp-mode-hook)
(parens emacs-lisp-mode-hook)
(parens scheme-mode-hook)

(require-and-eval (slime slime)
  (defun load-slime ()
    (slime-setup '(slime-fancy slime-asdf slime-sbcl-exts))

    (setq
     lisp-indent-function 'common-lisp-indent-function
     slime-complete-symbol-function 'slime-fuzzy-complete-symbol
     slime-net-coding-system 'utf-8-unix
     slime-startup-animation nil
     slime-auto-connect 'always
     slime-auto-select-connection 'always
     common-lisp-hyperspec-root "/home/stas/doc/comp/lang/lisp/HyperSpec/"
     inferior-lisp-program "ccl"
     slime-complete-symbol*-fancy t
     slime-kill-without-query-p t
     slime-when-complete-filename-expand t))

  (load-slime)

  (defun reload-slime ()
    (interactive)
    (mapc (lambda (x)
            (let ((name (symbol-name x)))
              (if (string-match "^slime.+" name)
                  (load-library name))))
          features)
    (load-slime)
    (setq slime-protocol-version (slime-changelog-date)))

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
      ccl clisp scl acl)))

;;; Scheme
(setq scheme-program-name "gosh"
      quack-default-program "gosh"
      scheme-mit-dialect nil
      quack-fontify-style 'emacs
      quack-global-menu-p nil
      quack-pretty-lambda-p t)

(require 'quack nil t)

(require-and-eval (lisppaste)
  (push '("http://paste\\.lisp\\.org/display" . lisppaste-browse-url)
        browse-url-browser-function))

;;; Clojure
(require-and-eval (clojure-mode clojure)
  (require 'clojure-mode)
  (parens clojure-mode-hook)
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

;;; 
(defvar *jump-locations* nil)

(defun jump-to-fdefinition (fn)
  (interactive
   (list (or (function-called-at-point)
             (completing-read "Describe function: "
                              obarray 'fboundp t nil nil))))
  (let ((location
         (find-function-search-for-symbol fn nil
                                          (find-lisp-object-file-name
                                           fn 'symbol-function))))
    (push (cons (current-buffer) (point))
          *jump-locations*)
    (pop-to-buffer (car location))
    (if (cdr location)
        (goto-char (cdr location))
        (message "Unable to find location in file"))))

(defun jump-back ()
  (interactive)
  (let ((location (pop *jump-locations*)))
    (when location
      (pop-to-buffer (car location))
      (goto-char (cdr location)))))

(define-key emacs-lisp-mode-map "\M-." 'jump-to-fdefinition)
(define-key emacs-lisp-mode-map "\M-," 'jump-back)
