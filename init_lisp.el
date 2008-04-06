(require 'highlight-parentheses)
(require 'mic-paren)
(require 'paredit)
(require 'redshank)

(paren-activate)
(setq paren-priority 'close)

(defmacro parens (mode)
  `(add-hook ',mode (lambda ()
		      (highlight-parentheses-mode)
		      (paredit-mode)
		      (turn-on-redshank-mode))))

(parens lisp-mode-hook)
(parens emacs-lisp-mode-hook)
(parens scheme-mode-hook)

(add-to-path 'slime)
(add-to-path "slime/contrib")

(require 'slime)
(require 'slime-fancy)

(slime-setup)

(setq
 lisp-indent-function 'common-lisp-indent-function
 slime-complete-symbol-function 'slime-fuzzy-complete-symbol
 slime-net-coding-system 'utf-8-unix
 slime-startup-animation nil
 common-lisp-hyperspec-root "/home/stas/doc/comp/lang/lisp/HyperSpec/"
 inferior-lisp-program
 "sbcl --noinform --core /home/stas/.sbcl/swank.core --no-userinit")

(setenv "SBCL_HOME" "/usr/local/lib/sbcl")

;;; Scheme
(setq scheme-program-name "scheme48"
      quack-default-program "scheme48"
      scheme-mit-dialect nil
      quack-fontify-style 'emacs
      quack-global-menu-p nil
      quack-pretty-lambda-p t)

(require 'quack)