
(require-and-eval (emms-setup "emms/lisp")
  (require 'url-http)
  (require 'emms-lastfm nil t)
  (require 'emms-info-libtag nil t)
  (require 'emms-info-ogg nil t)

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
   emms-info-functions '(emms-info-libtag emms-info-ogg))

  (global-set-key "\C-ce"
                  '(lambda ()
                    (interactive)
                    (emms-show t))))
