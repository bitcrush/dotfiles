#!/bin/zsh

# Dircolors...
eval `dircolors -b`
 
# Exports
typeset -U path
path=($HOME/bin/ $path)
test -n "$DISPLAY" && export TERM='rxvt-256color'
export LC_ALL='en_US.utf8'
export LANGUAGE='en_US.utf8'
export LOCALE='en_US.utf8'
export LC_COLLATE='C'
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'
export BROWSER='firefox'
export HISTCONTROL='ignoredups'
#export OOO_FORCE_DESKTOP='gnome'
export MOZ_DISABLE_PANGO=1
