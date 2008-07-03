(defun add-to-path (dir)
  (add-to-list 'load-path
	       (format "~/.emacs.d/%s" dir)))

(defun load-init (modules)
  "Load initialization files"
  (mapc (lambda (x)
	  (load (format "init_%s" x)))
	modules))

(setq custom-file "~/.emacs.d/init/init_custom.el")

(add-to-path 'init)

(load-init
 '(iface share misc pass jabber erc
   lang web emms custom))

(server-start)
