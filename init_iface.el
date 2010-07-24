
(setq inhibit-startup-message t
      font-lock-maximum-decoration nil)

(when window-system
  (global-set-key "\C-x\C-y" 'x-clipboard-yank)
  (setq default-frame-alist
        (acons 'font
               "DejaVu Sans Mono 13"
               default-frame-alist))
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(unless window-system
  (global-set-key  "\C-h" 'backward-delete-char))

(menu-bar-mode -1)
(xterm-mouse-mode 0)
