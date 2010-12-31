#!/bin/sh
#
# ~/.xinitrc

export SDL_VIDEO_X11_DGAMOUSE="0"
nvidia-settings -l &
nvidia-settings -a InitialPixmapPlacement=2 -a GlyphCache=1 &
xset m 0 0 &
xset r rate 200 30 &
xset s on &
numlockx on &
setxkbmap -option terminate:ctrl_alt_bksp &
(amixer -- sset DAC,0 -32dB && amixer -- sset DAC,1 -32dB) > /dev/null &&

[ `pidof urxvtd` ] || urxvtd -q -o -f &&
sleep 5 &&
xsetroot -solid '#3A3A3A' &
exec ssh-agent awesome 2> ~/.config/awesome/session-log
