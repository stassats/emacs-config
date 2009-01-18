(add-to-path "")

(set-language-environment "UTF-8")
(setq
 default-input-method "russian-computer"
 x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)
 fringe-mode '(1 . 1)
 global-font-lock-mode t
 ispell-program-name "aspell"
 ispell-dictionary "en"
 size-indication-mode t
 tab-width 8
 transient-mark-mode t
 flyspell-mouse-map
 '(keymap (down-mouse-3 . flyspell-correct-word))
 iswitchb-default-method 'samewindow
 next-screen-context-lines 1
 bookmark-save-flag 1
 user-mail-address "stassats@gmail.com"
 user-full-name "Stas Boukarev")

(setq-default indent-tabs-mode nil)
(setq-default fill-column 90)
(put 'upcase-region 'disabled nil)

(blink-cursor-mode 0)
(iswitchb-mode 1)

(put 'downcase-region 'disabled nil)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;;; Write backup in ~/.saves
(setq
 backup-by-copying t                    ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/saves"))          ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t                      ; use versioned backups
 tramp-backup-directory-alist backup-directory-alist)

;;; Sessions mode
(require-and-eval (session)
  (add-hook 'after-init-hook 'session-initialize)
  (autoload 'session "~/.emacs.d/session.el" "This saves
certain variables like input histories." t))


;;; Buffers
(global-set-key "\C-x\C-b" 'ibuffer)

;;; Doc-view

(require 'doc-view nil t)

;;; Dictionary
(require-and-eval (dictionary dict)
  (setq
   dictionary-server "slack")

  (global-set-key "\C-cs" 'dictionary-search)
  (global-set-key "\C-cd" 'dictionary-lookup-region)
  (global-set-key [mouse-3] 'dictionary-mouse-popup-matching-words)

  (defun dictionary-lookup-region (start end)
    (interactive "r")
    (dictionary-search (buffer-substring-no-properties start end))))

;;; Display unambiguous filenames in mode-line
(require-and-eval (uniquify)

  (setq
   uniquify-buffer-name-style 'reverse
   uniquify-separator "/"
   uniquify-after-kill-buffer-p t
   uniquify-ignore-buffers-re "^\\*"))

(when window-system
  (global-set-key "\C-z" nil))

;;; Remove unneeded and often accidently pressed bindings
(global-set-key [f10] nil)
(global-set-key "\M-`" nil)
