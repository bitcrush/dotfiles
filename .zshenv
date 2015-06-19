#!/bin/zsh

# location of zsh config files
ZDOTDIR=${HOME}/.config/zsh

# Dircolors...
eval `dircolors -b`

# Exports
typeset -U path
path=($HOME/bin/ $path)
export LANGUAGE='en_US.utf8'
export LOCALE='en_US.utf8'
export LC_ALL='en_US.utf8'
export LC_COLLATE='C'
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'
export BROWSER='firefox'

# color manpages without using most
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

