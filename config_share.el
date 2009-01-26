(require 'cl)

(defun add-to-path (dir)
  "Add directory `dir' in ~/.emacs.d/ to `load-path'."
  (let ((name (format "~/.emacs.d/%s" dir)))
    (if (file-exists-p name)
	(add-to-list 'load-path name))))

(defmacro* require-and-eval ((feature &optional add-to-path) &body body)
  "Execute code if feature was loaded successfully.
Optinally add directory `add-to-path' to `load-path'."
  `(progn
     ,(if add-to-path `(add-to-path ',add-to-path))
     (when (require ',feature nil t)
       ,@body)))

(defun load-init (modules)
  "Load initialization files."
  (mapc (lambda (x)
	  (load (format "init_%s" x)))
	modules))

(setq custom-file "~/.emacs.d/init/init_custom.el")

(add-to-path 'init)
