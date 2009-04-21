
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
               "mpc --format '[%artist% - %title%]|[%file%]'")))
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

(setq warning-suppress-types '((undo discard-info)))
