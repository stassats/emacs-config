(load-init '(lisp))

(setq
 case-fold-search t
 column-number-mode t
 cperl-indent-level 4
 ecb-auto-expand-tag-tree 'expand-spec
 ecb-tip-of-the-day nil)

;;; Wikipedia
(require 'wikipedia-mode)

(add-to-list 'auto-mode-alist '("\\.\\([wW][Pp]\\)\\'" . wikipedia-mode))

;;; Perl
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;;; PHP
(require 'php-mode)

;;; Lua
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;;; Erlang
(require 'erlang)
(add-to-list 'auto-mode-alist '("\\.\\([eE][rR][lL]\\)\\'" . erlang-mode))

;;; TeX
(add-to-path 'auctex)
(add-to-path 'preview)

(load "auctex.el")
(load "preview-latex.el")

;;; Haskell
(add-to-path 'haskell-mode)

(load "~/.emacs.d/haskell-mode/haskell-site-file")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
(setq haskell-program-name "ghci")

;;; Prolog
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)  ; optional, the system you are using;
                           ; see `prolog-system' below for possible values
(setq auto-mode-alist (append '(("\\.m$" . mercury-mode))
                                auto-mode-alist))

;;; Maxima
(autoload 'imaxima "imaxima" "Frontend for maxima with Image support" t)
(autoload 'maxima "maxima" "Frontend for maxima" t)
;;; add autoload of imath.
(autoload 'imath-mode "imath" "Imath mode for math formula input" t)

;;; APL
(require 'apl)

;;; Standard ML

(add-to-path 'sml)
(load "sml-mode-startup")

;;; Ruby
(add-to-path 'ruby)
(require 'ruby-mode)

(add-to-list 'auto-mode-alist '("\\.\\([rR][bB]\\)\\'" . ruby-mode))

;;; XML

;; (add-to-path 'nxml)
;; (require 'nxml-mode)