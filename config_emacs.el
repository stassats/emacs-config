(load "~/.emacs.d/init/config_share.el")

(load-init
 '(iface share misc pass jabber erc
   web lang emms custom))

(server-start)
