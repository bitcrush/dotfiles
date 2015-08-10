#!/bin/zsh

# location of zsh/antigen config files
ZDOTDIR=${HOME}/.config/zsh
ADOTDIR=${ZDOTDIR}/antigen

# Dircolors...
eval `dircolors -b`

# Exports
typeset -U path
path=($HOME/bin/ $path)
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

