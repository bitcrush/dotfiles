#!/bin/sh

export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export LIBVA_DRIVER_NAME="vdpau"
export VDPAU_DRIVER="r600"
export STEAM_FRAME_FORCE_CLOSE=1
export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh

[[ -f ${HOME}/.Xresources ]] && xrdb -merge ${HOME}/.Xresources
xset m 0 0 &
xset r rate 200 30 &
xset s on &
xset +fp /usr/share/fonts/local
xset fp rehash
numlockx on &
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
setxkbmap -option terminate:ctrl_alt_bksp &
(amixer -- sset DAC,0 -32dB && amixer -- sset DAC,1 -32dB) > /dev/null &&

sleep 5 &&
xhost +local: &
wmname LG3D &
compton --config ~/.compton.conf -b &
dunst &

#exec ssh-agent i3 # -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
exec i3 # -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
