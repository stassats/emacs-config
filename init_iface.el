
(setq inhibit-startup-message t)

(require-and-eval (color-theme color-theme)
  (color-theme-initialize)
  (color-theme-charcoal-black))

(if window-system
    (let ((font "-misc-fixed-medium-r-normal--18-120-100-100-c-90-iso10646-1"))
      (set-fontset-font "fontset-default" 'cyrillic '("arial" . "unicode-bmp"))
      (add-to-list 'default-frame-alist `(font . ,font))
      (global-set-key "\C-x\C-y" 'x-clipboard-yank))
    (global-set-key "\C-h" 'backward-delete-char))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-face-background 'mode-line "Black")
(set-face-foreground 'mode-line "Grey")
