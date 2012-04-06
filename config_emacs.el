(load "~/.emacs.d/init/config_share.el")

(setq emacs-instance "general")

(load-init
 '(iface share misc pass ion3 jabber erc
   web lang custom))

(server-start)

(put 'erase-buffer 'disabled nil)

(when (featurep 'xemacs)
  (setq load-home-init-file t)) ; don't load init file from ~/.xemacs/init.el
