
(require-and-eval (emms-setup "emms/lisp")
  (require 'emms-lastfm nil t)
  (require 'emms-info-libtag nil t)

  (emms-standard)
  (emms-default-players)

  (emms-playing-time 1)
  (emms-playing-time-disable-display)
  (emms-lastfm-enable)

  (setq
   emms-lastfm-username "stassats"
   emms-source-file-default-directory "~/music/"
   emms-show-format "/me слухает %s"
   emms-player-list '(emms-player-lastfm-radio
		      emms-player-mplayer-playlist emms-player-mplayer)
   emms-info-functions '(emms-info-libtag))

  ;; (nconc emms-player-mplayer-parameters '("-ao" "esd"))

  (global-set-key "\C-ce"
		  '(lambda ()
		    (interactive)
		    (emms-show t))))
