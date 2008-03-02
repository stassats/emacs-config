(add-to-path 'emms)

(require 'emms-setup)
(require 'emms-lastfm)
(require 'emms-info-mp3info)

(emms-standard)
(emms-default-players)

(emms-playing-time 1)
(emms-playing-time-disable-display)

(nconc emms-player-mplayer-parameters '("-ao" "esd"))
(add-to-list 'emms-info-functions 'emms-info-mp3info)

(setq 
 emms-lastfm-username "stassats"
 emms-source-file-default-directory "~/music/"
 emms-show-format "/me слухает %s"
 emms-player-list 
       '(emms-player-lastfm-radio emms-player-mplayer-playlist emms-player-mplayer))

(global-set-key "\C-ce"
                '(lambda ()
                   (interactive)
                   (emms-show t)))