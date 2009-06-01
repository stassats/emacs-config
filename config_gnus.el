(load "~/.emacs.d/init/config_share.el")

(setq emacs-instance "gnus")

(load-init
 '(share iface custom web ion3 gnus))

(run-hooks 'after-init-hook)
(gnus)
(gnus-demon-init)
