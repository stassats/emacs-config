;;; w3m

(add-to-path 'w3m)

(require 'w3m)
(require 'w3m-load)

(setq
 w3m-use-cookies t
 w3m-default-display-inline-images t
 w3m-use-favicon t)

(defun w3m-browse-url-other-window (url &optional newwin) 
  (interactive
   (browse-url-interactive-arg "w3m URL: "))
  (unless (get-buffer "*w3m*")
    (w3m-buffer-setup))
  (switch-to-buffer-other-window "*w3m*")
  (w3m-browse-url url))

;;; defualt browser
(defun browse-url-opera (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (shell-command-to-string
   (concat "opera -remote 'openURL(" url ",new-tab)'")))

(setq browse-url-browser-function
      '(("HyperSpec" . w3m-browse-url-other-window)
	("." . browse-url-opera)))
