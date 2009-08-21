(load-init '(lisp))

(setq
 case-fold-search t
 column-number-mode t
 cperl-indent-level 4
 ecb-auto-expand-tag-tree 'expand-spec
 ecb-tip-of-the-day nil)

;;; Wikipedia
(require-and-eval (wikipedia-mode)
  (add-to-list 'auto-mode-alist '("\\.\\([wW][Pp]\\)\\'" . wikipedia-mode)))

;;; Perl
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;;; PHP
(require 'php-mode nil t)

;;; Lua
(require-and-eval (lua-mode)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode)))

;;; Erlang
(require-and-eval (erlang)
  (add-to-list 'auto-mode-alist '("\\.\\([eE][rR][lL]\\)\\'" . erlang-mode)))

;;; TeX
(if (add-to-path 'auctex)
    (load "auctex.el"))

(require-and-eval (preview preview))

;;; Haskell
(require-and-eval (haskell-mode haskell)

  (require 'haskell-ghci)
  (add-to-list 'auto-mode-alist '("\\.\\([hH][sS]\\)$" . haskell-mode))
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
  (setq haskell-program-name "ghci"))

;;; Prolog
(require-and-eval (prolog)
  (setq prolog-system 'swi))

;;; APL
(require 'apl nil t)

;;; Standard ML

(if (add-to-path 'sml)
    (load "sml-mode-startup"))

;;; Ruby
(require-and-eval (ruby-mode ruby)
  (add-to-list 'auto-mode-alist '("\\.\\([rR][bB]\\)$" . ruby-mode)))

;;; XML

(require-and-eval (nxml-mode nxml))

;;; Caml
(require-and-eval (caml caml)
  (require 'caml-font nil nil)
  (add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . caml-mode)))
