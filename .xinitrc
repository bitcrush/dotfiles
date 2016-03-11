#!/bin/sh

# set environment variables
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd"
export LIBVA_DRIVER_NAME="vdpau"
export VDPAU_DRIVER="r600"
export STEAM_FRAME_FORCE_CLOSE=1
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# source X resources
[[ -f ${HOME}/.Xresources ]] && xrdb -merge ${HOME}/.Xresources

# disable mouse acceleration
xset m 0 0 &

# set keyboard rate
xset r rate 200 30 &

# turn on screensaver
xset s on &

# enable numlock
numlockx on &

# sync PRIMARY and CLIPBOARD buffer
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# set default mixer levels
(amixer -- sset DAC,0 -18dB && amixer -- sset DAC,1 -18dB) > /dev/null &&
amixer -- sset Master 50% > /dev/null &&

sleep 5 &&

# allow local connections to the X server
# required for running X11 applications like "skype" as different user
xhost +local: &

# start X11 compositor
compton -b &

# start notification daemon
dunst &

# start the automatic screen locker
xautolock -time 15 -locker "if ! pidof physlock > /dev/null; then physlock -ms; fi" -detectsleep -secure &

# run the window manager
exec i3 # -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
