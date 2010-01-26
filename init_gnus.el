(require 'gnus)

(setq gnus-select-method
      '(nnimap "gmail"
               (nnimap-address "imap.gmail.com")
               (nnimap-server-port 993)
               (nnimap-stream ssl))
      gnus-agent nil
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-local-domain "stassats.dyndns.org"
      gnus-ignored-newsgroups ""
      gnus-check-new-newsgroups nil
      gnus-inhibit-startup-message t
      gnus-interactive-catchup nil
      gnus-use-dribble-file nil)

(add-hook 'gnus-startup-hook
          (lambda ()
            (gnus-demon-add-handler 'gnus-group-get-new-news 3 t)))

(defvar gnus-ion3-alist
  '(("INBOX" . 0)))

(defun gnus-format-for-ion3 ()
  (loop for pair in gnus-ion3-alist
        for (group . count) = pair
        for unread = (gnus-group-unread group)
        unless (eql count unread) do (setf (cdr pair) unread)
        and collect unread))

(defun gnus-notify-ion3 ()
  (interactive)
  (let ((format (gnus-format-for-ion3)))
    (when (car format)
      (ion3-inform 'mail (car format)
                   (when (plusp (car format))
                     'important)))))

(add-hook 'gnus-after-getting-new-news-hook
          'gnus-notify-ion3 t)

(add-hook 'gnus-summary-exit-hook 
          'gnus-notify-ion3 t)
