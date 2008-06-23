(defun translate-lingvo (word)
  "Translate a word with Yandex's Lingvo"
  (interactive "sWord: ")
  (w3m-browse-url
   (concatenate 'string
		"http://slovari.yandex.ru/search.xml?st_translate=1&text=" word)))

(add-to-path 'chess)
(require 'chess)

(add-to-list 'auto-mode-alist '("^/home/stas/doc/lib/" . view-mode))

(defun mpd ()
  (let ((stat (shell-command-to-string
	       "mpc --format '[%artist% - %title%]|[%file%]'")))
    (substring stat 0 (string-match "\n" stat))))

(global-set-key "\C-cp"
 		'(lambda ()
		  (interactive)
		  (insert (concat "/me слухает "
			   (mpd)))))
