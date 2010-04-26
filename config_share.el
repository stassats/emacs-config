(require 'cl)

(defun add-to-path (dir)
  "Add directory `dir' in ~/.emacs.d/ to `load-path'."
  (let ((name
         (typecase dir
           (symbol (format "~/.emacs.d/%s" dir))
           (string dir))))
    (if (file-exists-p name)
        (add-to-list 'load-path name))))

(defmacro* require-and-eval ((feature &optional add-to-path) &body body)
  "Execute code if feature was loaded successfully.
Optinally add directory `add-to-path' to `load-path'."
  `(progn
     ,(if add-to-path `(add-to-path ',add-to-path))
     (when (require ',feature nil t)
       ,@body)))

(put 'require-and-eval 'lisp-indent-function 1)

(defun load-init (modules)
  "Load initialization files."
  (dolist (x modules)
    (load (format "init_%s" x))))

(setq custom-file "~/.emacs.d/init/init_custom.el")

(add-to-path 'init)
