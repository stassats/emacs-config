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
      gnus-use-dribble-file nil
      gnus-save-newsrc-file nil
      gnus-read-newsrc-file nil
      gnus-save-killed-list nil
      gnus-auto-select-next nil
      gnus-summary-line-format "%U%R%z%I%(%[%-23,23f%]%) %s\n"
      gnus-auto-center-summary nil
      gnus-treat-display-smileys nil
      gnus-save-score t
      nnimap-split-crosspost nil
      message-directory "~/.config/emacs/gnus/Mail"
      gnus-directory "~/.config/emacs/gnus/News"
      smtpmail-auth-credentials "~/.config/emacs/gnus/.authinfo"
      auth-sources `((:source ,smtpmail-auth-credentials))
      gnus-startup-file "~/.config/emacs/gnus/newsrc")

;; splitting
(setq nnimap-inbox "INBOX"
      nnimap-split-methods
      '(("slime-devel"
         "^\\(To\\|CC\\|Cc\\):.+slime-devel@common-lisp.net")
        ("lists"
         "^List-Id:\\|^X-list:")
        ("launchpad-bugs"
         "^X-Launchpad-Bug:")
        ("slackware-security" "^Subject: \\[slackware-security\\]")
        ("private"
         ""))
      gnus-auto-expirable-newsgroups "launchpad-bugs\\|lists")

;;

(add-hook 'gnus-startup-hook
          (lambda ()
            (gnus-demon-add-handler 'gnus-group-get-new-news 2 t)))

(defvar gnus-ion3-alist
  '(("private" . 0)))

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

(add-hook 'message-mode-hook (lambda () (flyspell-mode 1)))
