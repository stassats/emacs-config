
(setq inhibit-startup-message t
      font-lock-maximum-decoration nil)

(if window-system
    (let ((font "-misc-fixed-medium-r-normal--18-120-100-100-c-90-iso10646-1"))
      (set-fontset-font "fontset-default" 'cyrillic '("arial" . "unicode-bmp"))
      ;(add-to-list 'default-frame-alist `(font . ,font))
      (nconc default-frame-alist
             '((background-color . "gray94")))
      (global-set-key "\C-x\C-y" 'x-clipboard-yank))
    (global-set-key "\C-h" 'backward-delete-char))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(xterm-mouse-mode 1)
