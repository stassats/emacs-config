(load-init '(lisp))

(setq
 case-fold-search t
 column-number-mode t
 cperl-indent-level 4
 ecb-auto-expand-tag-tree 'expand-spec
 ecb-tip-of-the-day nil)

;;; Perl
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;;; PHP
;; (require 'php-mode nil t)

;;; Lua
(require-and-eval (lua-mode)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode)))

;;; Erlang
;; (require-and-eval (erlang)
;;   (add-to-list 'auto-mode-alist '("\\.\\([eE][rR][lL]\\)\\'" . erlang-mode)))

;;; TeX
(when (and window-system (add-to-path 'auctex))
  (load "auctex.el")
  (require-and-eval (preview preview)))

;;; Haskell
(require-and-eval (haskell-mode haskell)

  (require 'inf-haskell)
  (add-to-list 'auto-mode-alist '("\\.\\([hH][sS]\\)$" . haskell-mode))

  (setq haskell-program-name "ghci"))

;;; Prolog
(require-and-eval (prolog)
  (setq prolog-system 'swi)
  (define-key prolog-mode-map "\C-c\C-z" 'run-prolog))

;;; Standard ML

;; (if (add-to-path 'sml)
;;     (load "sml-mode-startup"))

;;; XML

(require-and-eval (nxml-mode nxml))

;;; Caml
;; (require-and-eval (caml caml)
;;   (require 'caml-font nil nil)
;;   (add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . caml-mode)))

;;; Darcs mode for VC
(require-and-eval (vc-darcs vc-darcs)
  (add-to-list 'vc-handled-backends 'DARCS)
  (add-hook 'find-file-hooks 'vc-darcs-find-file-hook))

;;; Maxima
(require-and-eval (imaxima imaxima)
  (setq imaxima-fnt-size "Large"))

(require-and-eval (csharp-mode))

;;; Smalltalk
(require-and-eval (smalltalk-mode gst)
  (setq gst-program-name "gst -V"))

;;; Mozart
(require-and-eval (oz "~/c/mozart/share/elisp")
  (setq oz-prefix "/home/stas/c/mozart"
        *oz-change-title* nil)
  (define-key oz-mode-map "\C-c\C-k" 'oz-feed-buffer)
  (define-key oz-mode-map "\C-c\C-c" 'oz-feed-paragraph)
  (define-key oz-mode-map "\C-c\C-s" 'oz-show-paragraph)
  (define-key oz-mode-map "\C-c\C-b" 'oz-browse-paragraph))
