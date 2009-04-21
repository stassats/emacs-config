(defvar *ionflux-socket-name*)

(defun* ionflux-socket-name ()
  (with-output-to-string
      (with-current-buffer standard-output
        (unless (zerop (call-process "ionflux-socket-name"  nil t nil))
          (return-from ionflux-socket-name)))))

(defun ionflux-connect-socket ()
  (make-network-process :family 'local :service *ionflux-socket-name*
                        :name "ionflux"))

(defun ionflux-connect ()
  (or (ignore-errors (ionflux-connect-socket))
      (if (setf *ionflux-socket-name* (ionflux-socket-name))
          (ionflux-connect-socket)
          (error "Couldn't get ionflux socket name."))))

(defun ionflux-send (socket string)
  (process-send-string socket string)
  (process-send-string socket "\0"))

(defun ion3-inform (slot message &optional hint)
  "Send a message to the ion3-statusbar's slot.
hint can be: normal, important, or critical."
  (ionflux-send (ionflux-connect)
                (format "mod_statusbar.inform('%s', '%s');
mod_statusbar.inform('%s_hint', '%s');
mod_statusbar.update()" slot message slot hint)))
