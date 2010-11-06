(require-and-eval (erc)
  (setq
   erc-modules
   '(autojoin button completion fill irccontrols match netsplit
     noncommands readonly ring stamp track truncate spelling)
   erc-track-exclude-server-buffer t
   erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE")
   erc-hide-list '("MODE")
   erc-track-showcount t
   erc-track-visibility 'visible
   erc-truncate-mode t
   erc-mode-line-format "%t %a"
   erc-user-full-name "Stas Boukarev"
   erc-email-userid "stassats@gmail.com"
   erc-status nil
   erc-prompt ">"
   erc-autojoin-channels-alist '(("freenode.net" "#lisp" "#sbcl"))
   erc-timestamp-format "%H:%M"
   erc-timestamp-format-right "%H:%M"
   erc-fill-column 75)

  (defun irc ()
    "Connect to IRC."
    (interactive)
    (erc-select :server "irc.freenode.net"
                :port 6667 :nick "stassats"
                :full-name "Stas Boukarev"
                :password erc-password))

  (defun format-erc-status (status)
    (mapcar (lambda (x) (format "%s - %s" (car x) (cadr x)))
            status))

  (defun erc-important-messages-p ()
    (some (lambda (x)
            (if (cdr (last x))
                (eq (last x) 'erc-current-nick-face)
                (memq 'erc-current-nick-face x)))
          erc-modified-channels-alist))
  
  (defun erc-ion3 ()
    (let ((fmt (format-erc-status erc-modified-channels-alist)))
      (unless (equal erc-status fmt)
        (setq erc-status fmt)
        (ion3-inform 'irc (or fmt "")
                     (when (erc-important-messages-p)
                       'important)))))

  (add-hook 'erc-track-list-changed-hook 'erc-ion3))

(defun lisp-log ()
  (interactive)
  (set-time-zone-rule "America/Phoenix")
  (unwind-protect
       (w3m-browse-url-other-window
        (format-time-string "http://tunes.org/~nef/logs/lisp/%y.%m.%d"))
    (set-time-zone-rule "Europe/Moscow")))
