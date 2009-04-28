(setq gnus-select-method
      '(nnimap "gmail"
        (nnimap-address "imap.gmail.com")
        (nnimap-server-port 993)
        (nnimap-stream ssl))
      gnus-agent nil)

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;      smtpmail-auth-credentials '(("smtp.gmail.com" 587 "stassats@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-local-domain "stassats.dyndns.org")

;; (setq
;;  nnimap-split-inbox '("INBOX" "lists")
;;  nnimap-split-rule
;;        '(("lists" "^List.*"
;;           "INBOX" "")))
