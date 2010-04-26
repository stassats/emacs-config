(load "~/.emacs.d/init/config_share.el")

(setq emacs-instance "general")

(load-init
 '(iface share misc pass ion3 jabber erc
   web lang custom)) ;; emms

(server-start)

(put 'erase-buffer 'disabled nil)
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el
