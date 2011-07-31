
(defun translate-lingvo (word)
  "Translate a word with Yandex's Lingvo"
  (interactive "sWord: ")
  (w3m-browse-url
   (concatenate 'string
                "http://slovari.yandex.ru/search.xml?st_translate=1&text=" word)))

(require-and-eval (chess chess))

(add-to-list 'auto-mode-alist '("^/home/stas/doc/lib/" . view-mode))

(defun mpd ()
  (let ((stat (shell-command-to-string
               "mpc --format '[[%artist% - ]%title%]|[%name%]|[%file%]'")))
    (substring stat 0 (string-match "\n" stat))))

(global-set-key "\C-cp"
                (lambda ()
                  (interactive)
                  (insert (concat "/me слухает "
                                  (mpd)))))

;;; Org-mode

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(add-hook 'change-log-mode-hook 'flyspell-mode)
(add-hook 'log-edit-mode-hook 'flyspell-mode)
(add-hook 'change-log-mode-hook 'auto-fill-mode)

(setq warning-suppress-types '((undo discard-info)))

;;;
(require 'dframe nil t)

(define-key special-event-map [make-frame-visible]
  (lambda (e)
    (interactive "e")
    (visible-frame-notifications (caadr e))))

(defun visible-major-modes (frame)
  (mapcar (lambda (x)
            (buffer-local-value 'major-mode (window-buffer x)))
          (window-list frame)))

(defun visible-frame-notifications (frame)
  (let ((major-modes (visible-major-modes frame)))
    (when (member 'erc-mode major-modes)
      (erc-modified-channels-update))
    (when (member 'jabber-chat-mode major-modes)
      (jabber-activity-clean))))

;;; Magit
(require-and-eval (magit magit))

;;;
(require-and-eval (image-mode)
  (define-key image-mode-map "g"
    (lambda () (interactive) (revert-buffer t t))))

(defun sudo ()
  (interactive)
  (let ((position (point)))
    (find-alternate-file (concat "/sudo::" (buffer-file-name (current-buffer))))
    (goto-char (dbgmsg position))))
