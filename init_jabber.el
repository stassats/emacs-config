
(require-and-eval (jabber jabber)

  (setq
   jabber-chat-buffer-format "*-jc-%n-*"
   jabber-groupchat-buffer-format "*-gc-%n-*"
   jabber-muc-private-buffer-format "*-priv-%g-%n-*"
   jabber-chat-delayed-time-format "%Y-%m-%d %H:%M:%S"
   jabber-chat-foreign-prompt-format "[%t] %n: "
   jabber-chat-local-prompt-format "[%t] %n: "
   jabber-chat-time-format "%H:%M:%S"
   jabber-groupchat-prompt-format "[%t] %n: "
   jabber-muc-private-foreign-prompt-format "[%t] %g/%n: "
   jabber-mode-line-compact t
   jabber-account-list `((,(concat "stassats@jabber.ru/" system-name)
                           (:password . ,jabber-password)
                           (:connection-type . network)))
   jabber-vcard-avatars-retrieve nil
   jabber-message-alert-same-buffer nil
   jabber-log-lines-to-keep 600
   jabber-ion3-stat ""
   jabber-alert-presence-hooks nil
   jabber-auto-reconnect t
   jabber-autoaway-method nil
   jabber-chat-fill-long-lines nil
   jabber-chatstates-confirm nil
   jabber-events-confirm-composing nil
   jabber-events-confirm-delivered nil
   jabber-events-confirm-displayed nil
   fsm-debug nil
   goto-address-fontify-maximum-size t
   rest nil)

  (add-hook 'jabber-alert-muc-hooks 'jabber-truncate-muc)

;;; Ion3
  (defun jabber-ion3 (status hint)
    (ion3-inform 'jabber status hint))

  (defun interesting-jid-p (jid)
    (not (string-match "conference" jid)))

  (defun jabber-ion3-hint ()
    (if (find-if 'interesting-jid-p jabber-activity-jids)
        'important 'normal))

  (defun jabber-ion3-update ()
    (unless (string-equal jabber-ion3-stat jabber-activity-count-string)
      (setq jabber-ion3-stat jabber-activity-count-string)
      (jabber-ion3 jabber-ion3-stat (jabber-ion3-hint))))

  (add-hook 'jabber-activity-update-hook 'jabber-ion3-update)

  (defun jabber-reset-activity ()
    (interactive)
    (setq jabber-activity-jids nil)
    (jabber-activity-mode-line-update))

  (defun toggle-rest ()
    "Turn off annoying jabber/irc notifications"
    (interactive)
    (if rest
        (progn
          (setq jabber-alert-message-hooks 
                '(jabber-message-echo jabber-message-scroll)
                jabber-alert-muc-hooks 
                '(jabber-muc-echo jabber-muc-scroll jabber-truncate-muc)
                jabber-alert-info-message-hooks 
                '(jabber-info-display jabber-info-echo)
                jabber-activity-update-hook '(jabber-ion3-update)
                rest nil)
          (erc-track-mode 1)
          (jabber-activity-mode 1)
          nil)
        (progn
          (setq jabber-alert-message-hooks nil
                jabber-activity-update-hook nil
                jabber-alert-info-message-hooks nil
                jabber-alert-muc-hooks nil
                rest t)
          (jabber-activity-mode -1)
          (erc-track-mode -1)
          t))
    (prin1 rest))

  (add-hook 'jabber-chat-mode-hook 'flyspell-mode)

  (define-key jabber-chat-mode-map "\C-c\C-n" 'jabber-muc-names)
  (define-key jabber-global-keymap "\C-e" 'jabber-reset-activity)
  (global-set-key "\C-cr" 'toggle-rest)
  (define-key goto-address-highlight-keymap (kbd "RET")
    'goto-address-at-point)

;;; ignore
  (defvar jabber-muc-ignore-nicks
    '("^__^"
      "Гейтс"
      "Калигулa"
      "C.C."
      "ояб"
      "WatchHorse."
      "Быдло с Металлурга"))

  (defvar jabber-muc-ignore-body-regexes
    '("^\\^__\\^"
      "^Гейтс"
      "^Калигулa"
      "^C\.C\."
      "^ояб"
      "^WatchHorse\."
      "^Быдло с Металлурга"
      "^version"
      "^ping"
      "^нг"))

  (defadvice jabber-muc-process-message
      (around jabber-muc-process-message-ingore (jc xml-data))
    (when (jabber-muc-message-p xml-data)
      (let ((nick (jabber-jid-resource
                   (jabber-xml-get-attribute xml-data 'from)))
            (body (car (jabber-xml-node-children
                        (car (jabber-xml-get-children
                              xml-data 'body))))))
        (unless (or (member nick jabber-muc-ignore-nicks)
                    (member-if (lambda (regex)
                                 (string-match regex body))
                               jabber-muc-ignore-body-regexes))
          ad-do-it))))

  (ad-activate 'jabber-muc-process-message))
