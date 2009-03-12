(load "~/.emacs.d/init/config_share.el")

(setq emacs-instance "gnus")

(load-init
 '(share iface custom web gnus))

(run-hooks 'after-init-hook)
(gnus)
