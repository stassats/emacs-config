(require-and-eval (erc)
 (setq
  erc-modules
  '(autojoin button completion fill irccontrols match netsplit
    noncommands readonly ring stamp track truncate spelling)
  erc-track-exclude-server-buffer t
  erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE"
                            "333" "353" "324" "329")
  erc-hide-list '("MODE" "JOIN" "NICK" "QUIT" "PART"
                  "324" "329")
  erc-track-showcount t
  erc-track-visibility 'visible
  erc-truncate-mode t
  erc-mode-line-format "%t %a"
  erc-user-full-name "Stas Boukarev"
  erc-email-userid "stassats@gmail.com"
  erc-status nil
  erc-prompt ">"
  erc-autojoin-channels-alist '(("desktop" "#sbcl" "#clasp"))
  erc-timestamp-format "%H:%M"
  erc-timestamp-format-right "%H:%M"
  erc-fill-column 75
  erc-button-alist '((erc-button-url-regexp 0 t browse-url 0)
                     ('nicknames 0 erc-button-buttonize-nicks erc-nick-popup 0)))

 (defun irc ()
   "Connect to IRC."
   (interactive)
   (erc-select :server "desktop"
               :port 5000 :nick "stassats"
               :full-name "Stas Boukarev"
               :password "stassats:abc" ;; erc-password
               ))

 (defun format-erc-status (status)
   (mapcar (lambda (x) (format "%s - %s" (car x) (cadr x)))
           status))
     
 (defun erc-important-messages-p ()
   (some (lambda (x)
           (if (cdr (last x))
               (eq (cdr (last x)) 'erc-current-nick-face)
               (memq 'erc-current-nick-face x)))
         erc-modified-channels-alist))
     
 (defun erc-ion3 ()
   (let ((fmt (format-erc-status erc-modified-channels-alist)))
     (unless (equal erc-status fmt)
       (setq erc-status fmt)
       (ion3-inform 'irc (or fmt "")
                    (when (erc-important-messages-p)
                      'important))
       (switch-led fmt))))
 (unless (mac-p)
   (add-hook 'erc-track-list-changed-hook 'erc-ion3)))

(defun log-lisp ()
  (interactive)
  (set-time-zone-rule "America/Phoenix")
  (unwind-protect
       (w3m-browse-url-other-window
        (format-time-string "http://tunes.org/~nef/logs/lisp/%y.%m.%d"))
    (set-time-zone-rule "Europe/Moscow")))

(defun log-sbcl ()
  (interactive)
  (w3m-browse-url-other-window
   ;; (format-time-string "http://ccl.clozure.com/irc-logs/sbcl/sbcl-%Y-%m.txt" nil t)
   (format-time-string "http://ccl.clozure.com/irc-logs/sbcl/%Y-%m/sbcl-%Y.%m.%d.txt" nil t)))
