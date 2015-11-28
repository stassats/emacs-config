(load "~/.emacs.d/init/config_share.el")

(setq emacs-instance "gnus")

(load-init
 '(share iface custom ion3 gnus))

(run-hooks 'after-init-hook)
(gnus)
(gnus-demon-init)

(when (mac-p)
  (load-init '(colors))
  (init-fixup-colors))
