;;; w3m

(require-and-eval (w3m w3m)
  (require 'w3m-load)
  (make-directory "/tmp/w3m/" t)

  (setq
   w3m-use-cookies t
   w3m-default-display-inline-images t
   w3m-use-favicon t
   w3m-message-silent t
   w3m-default-save-directory "/tmp/w3m/"
   w3m-profile-directory "/tmp/w3m/"
   w3m-keep-arrived-urls 0
   w3m-resize-images nil) ; because it's slow

  (push '("HyperSpec" . w3m-browse-url-other-window)
        browse-url-browser-function)
  (push '("http://paste\\.lisp\\.org" . w3m-browse-url-other-window)
        browse-url-browser-function)

  (defun w3m-browse-url-other-window (url &optional newwin)
    (interactive
     (browse-url-interactive-arg "w3m URL: "))
    (unless (get-buffer "*w3m*")
      (w3m-buffer-setup))
    (switch-to-buffer-other-window "*w3m*")
    (w3m-browse-url (replace-in-string
                     url
                     "http://www.lispworks.com/.+/HyperSpec/"
                     common-lisp-hyperspec-root))))
