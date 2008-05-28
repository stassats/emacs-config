(defun translate-lingvo (word)
  "Translate word with Yandex's Lingvo"
  (interactive "sWord: ")
  (w3m-browse-url
   (concatenate 'string 
		"http://slovari.yandex.ru/search.xml?st_translate=1&text=" word)))

(add-to-path 'chess)
(require 'chess)

(add-to-list 'auto-mode-alist '("^/home/stas/doc/lib/" . view-mode))
