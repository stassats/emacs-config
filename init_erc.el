(require 'erc)

(add-hook 'erc-after-connect '(lambda (SERVER NICK)
               (erc-message "PRIVMSG" 
		(concat "NickServ identify " irc-password))))
(setq
 erc-modules 
 '(autojoin button completion fill
   irccontrols match netsplit
   noncommands readonly ring stamp
   track truncate)
 erc-track-exclude-server-buffer t
 erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE")
 erc-track-showcount t
 erc-track-visibility 'visible
 erc-truncate-mode t
 erc-mode-line-format "%t %a"
 erc-user-full-name "Stas Boukarev"
 erc-email-userid "stassats@gmail.com"
 erc-autojoin-channels-alist '(("freenode.net"
				"#wikipedia-ru"
				"#lisp")))

(defun irc ()
  "Connect to IRC."
  (interactive)
  (erc-select :server "irc.freenode.net" 
	      :port 6667 :nick "stassats" 
	      :full-name "Stas Boukarev"))

