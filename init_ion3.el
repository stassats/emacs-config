(defvar *ionflux-socket-name*)

(defun* ionflux-socket-name ()
  (with-output-to-string
      (with-current-buffer standard-output
        (unless (zerop (condition-case nil
                           (call-process "ionflux-socket-name" nil t nil)
                         (file-error 1)))
          (return-from ionflux-socket-name)))))

(defun ionflux-connect-socket ()
  (make-network-process :family 'local :service *ionflux-socket-name*
                        :name "ionflux"))

(defun ionflux-connect ()
  (or (ignore-errors (ionflux-connect-socket))
      (when (setf *ionflux-socket-name* (ionflux-socket-name))
        (ignore-errors (ionflux-connect-socket)))))

(defun ionflux-send (socket string)
  (process-send-string socket string)
  (process-send-string socket "\0"))

(defun ion3-inform (slot message &optional hint)
  "Send a message to the ion3-statusbar's slot.
hint can be: normal, important, or critical."
  (cond ((and (not (boundp '*ionflux-socket-name*))
              (not (setf *ionflux-socket-name* (ionflux-socket-name)))))
        ((not *ionflux-socket-name*) nil)
        (t
         (let ((connection (ionflux-connect)))
           (when connection
             (unwind-protect
                  (ionflux-send connection
                                (format "mod_statusbar.inform('%s', '%s');
mod_statusbar.inform('%s_hint', '%s');
mod_statusbar.update()" slot message slot hint))
               (delete-process connection)))))))
