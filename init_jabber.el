(add-to-path 'jabber)
(require 'jabber)

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
 jabber-muc-autojoin '("talks@conference.linux.spb.org"
		       "emacs@conference.jabber.ru"
		       "plan9@conference.jabber.ru"
		       "plan9-talks@conference.jabber.ru"
		       "programming@conference.jabber.ru"
		       "lisp@conference.jabber.ru")
 jabber-account-list `(("stassats@jabber.ru/laptop" (:password . ,jabber-password)))
 jabber-history-enabled t
 jabber-vcard-avatars-retrieve nil
 jabber-message-alert-same-buffer nil
 fsm-debug nil
 jabber-log-lines-to-keep 100)

;;; Ion3
(defun jabber-ion3-inform-statusbar (status hint)
  (start-process "ionflux" nil "ionflux" "-e"
		 (concat (format "mod_statusbar.inform('jabber', '%s'); " status)
			 (format "mod_statusbar.inform('jabber_hint', '%s'); " hint)
			 "mod_statusbar.update()")))

(defun interesting-jid-p (jid)
  (not (string-match "conference" jid)))

(defun jabber-ion3-select-hint ()
  (if (find-if #'interesting-jid-p jabber-activity-jids)
      'important
      'normal))

(defun jabber-ion3-update-statusbar ()
  (jabber-ion3-inform-statusbar jabber-activity-count-string (jabber-ion3-select-hint)))

(defun jabber-reset-activity ()
  (interactive)
  (setq jabber-activity-jids nil)
  (jabber-activity-mode-line-update))

(add-hook 'jabber-activity-update-hook #'jabber-ion3-update-statusbar)

(define-key jabber-chat-mode-map "\C-c\C-n" 'jabber-muc-names)
(define-key jabber-global-keymap (kbd "C-e") 'jabber-reset-activity)
(add-hook 'jabber-chat 'flyspell-mode)
