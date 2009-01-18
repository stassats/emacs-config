(setq gnus-select-method
      '(nnimap "gmail"
        (nnimap-address "imap.gmail.com")
        (nnimap-server-port 993)
        (nnimap-stream ssl))
      gnus-agent nil)

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 25 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 25 "stassats@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 25
      smtpmail-local-domain "stassats.dyndns.org")
