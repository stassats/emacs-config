
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

(defun ion3-inform (slot message &optional hint)
  "Send a message to the ion3-statusbar's slot.
hint can be: normal, important, or critical."
  (call-process "ionflux" nil 0 nil "-e"
		(format "mod_statusbar.inform('%s', '%s');
mod_statusbar.inform('%s_hint', '%s');
mod_statusbar.update()" slot message slot hint)))

;;; Org-mode

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq warning-suppress-types '((undo discard-info)))
