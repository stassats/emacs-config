(require-and-eval (mic-paren)
  (paren-activate)
  (setq paren-priority 'close))

(require 'highlight-parentheses nil t)
(require 'paredit nil t)
(require 'redshank nil t)

(defmacro parens (mode)
  `(add-hook ',mode (lambda ()
		      ,(if (featurep 'highlight-parentheses)
			   '(highlight-parentheses-mode))
		      ,(if (featurep 'paredit)
			   '(paredit-mode))
		      ,(if (featurep 'redshank)
			   '(turn-on-redshank-mode)))))

(parens lisp-mode-hook)
(parens emacs-lisp-mode-hook)
(parens scheme-mode-hook)

(require-and-eval (slime slime)
  (add-to-path "slime/contrib")
  (require 'slime-fancy)

  (slime-setup)

  (setq
   lisp-indent-function 'common-lisp-indent-function
   slime-complete-symbol-function 'slime-fuzzy-complete-symbol
   slime-net-coding-system 'utf-8-unix
   slime-startup-animation nil
   common-lisp-hyperspec-root "/home/stas/doc/comp/lang/lisp/HyperSpec/"
   inferior-lisp-program "sbcl")

  (defun sbcl ()
    (interactive)
    (slime "sbcl"))

  (defun ccl ()
    (interactive)
    (slime "ccl"))

  (defun clisp ()
    (interactive)
    (slime "clisp"))

  (defun ecl ()
    (interactive)
    (slime "ecl" 'iso-8859-1-unix)))

;;; Scheme
(setq scheme-program-name "mzscheme"
      quack-default-program "mzscheme"
      scheme-mit-dialect nil
      quack-fontify-style 'emacs
      quack-global-menu-p nil
      quack-pretty-lambda-p t)

(require 'quack nil t)
