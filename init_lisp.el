(setq lisp-simple-loop-indentation 1
      lisp-loop-keyword-indentation 6
      lisp-loop-forms-indentation 6
      blink-matching-paren nil)

(show-paren-mode 1)

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
  (slime-setup '(slime-fancy))
  
  (setq
   lisp-indent-function 'common-lisp-indent-function
   slime-complete-symbol-function 'slime-fuzzy-complete-symbol
   slime-net-coding-system 'utf-8-unix
   slime-startup-animation nil
   slime-auto-connect 'always
   slime-auto-select-connection 'always
   common-lisp-hyperspec-root "/home/stas/doc/comp/lang/lisp/HyperSpec/"
   inferior-lisp-program "~/lisp/bin/sbcl")

  (defun sbcl ()
    (interactive)
    (slime "~/lisp/bin/sbcl"))

  (defun ccl ()
    (interactive)
    (slime "ccl"))

  (defun ccl-1.2 ()
    (interactive)
    (slime "ccl-1.2"))

  (defun clisp ()
    (interactive)
    (slime "clisp"))

  (defun ecl ()
    (interactive)
    (slime "ecl" 'iso-8859-1-unix))
  
  (defun scl ()
    (interactive)
    (slime "scl")))

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
(require-and-eval (clojur-mode clojure-mode)
  (require 'clojure-paredit))

(require-and-eval (swank-clojure swank-clojure)
  (setq swank-clojure-jar-path "/home/stas/clojure/clojure.jar"))

