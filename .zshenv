#!/bin/zsh

# location of zsh/zplug config files
ZDOTDIR=${HOME}/.config/zsh
ZPLUG_HOME=${ZDOTDIR}/zplug

# set space between right prompt and terminal margin (V>=5.0.5)
[[ ! $TTY =~ tty ]] && ZLE_RPROMPT_INDENT=0

# Dircolors...
eval `dircolors -b`

# Exports
typeset -U path
path=($HOME/bin $path)
export GPG_TTY=$(tty)
export LANGUAGE='en_US.utf8'
export LOCALE='en_US.utf8'
export LC_ALL='en_US.utf8'
export LC_COLLATE='C'
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'
export BROWSER='firefox'

# fzf
export FZF_DEFAULT_COMMAND="find -type f"
export FZF_DEFAULT_OPTS="--extended --cycle"
export FZF_TMUX_HEIGHT=12

# color manpages without using most
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

