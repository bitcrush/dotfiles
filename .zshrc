#!/bin/zsh

# $HOME/.zshrc
# vim: fdm=marker ts=4 sw=4

# environment {{{1
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
export MOZ_DISABLE_PANGO=1
#export OOO_FORCE_DESKTOP='gnome'

# source files {{{1
source ~/.zsh/style
#source ~/.zsh/zle

# system functions {{{1
# load completion and user prompt
autoload -U compinit promptinit
compinit
promptinit

# load renaming function
autoload zmv

# math
autoload -U zcalc

zmodload zsh/complist

# aliases {{{1
alias e="$EDITOR"
alias l="$PAGER"
alias m="mplayer"
alias p="pacman"
alias b="bauerbill"
alias ba="bauerbill --aur"
alias s="sudo "
alias ls="ls -A -h --group-directories-first -F --color=auto"
alias lb="ls -A -s --block-size=1 --group-directories-first -F --color=auto"
alias ll="ls --group-directories-first --color -l -F"
alias rm="rm -I"
alias dl="cd /home/racoon/files/downloads"
alias music="cd /mnt/music/music"
alias fkvm="cd /mnt/sdb3/kvm"
alias fabs="cd /mnt/sdb3/cache/abs/local/"
alias fgit="cd /mnt/sdb3/cache/git/"
alias fxwax="cd /mnt/sdb3/xwax/"
alias grep='grep --color=auto -d skip'
alias exit="clear; exit"
alias irssi='screen -D -R irssi irssi'
alias rtorrent='screen -D -R rtorrent rtorrent'
alias rrtorrent='ssh -t tha screen -D -R rtorrent rtorrent'
alias rbots='ssh -t bha screen -D -r bots'
alias newsbeuter='TERM=xterm newsbeuter'
alias chm-d="find -type d -exec chmod 755 {} \;"
alias chm-f="find -type f -exec chmod 644 {} \;"
alias lower="convmv --lower --notest $1"
alias myip="wget -q http://whatismyip.org -O - | cat && echo"
alias awreload="echo 'awesome.restart()' | awesome-client"
alias rreconn="wget -O - --post-data 'disconnect=Trennen' http://192.168.2.1/cgi-bin/statusprocess.exe > /dev/null 2> /dev/null"
alias ledoff="ssh rr gpio enable 3"
alias startx="startx -nolisten tcp"

# prompt {{{1
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
        precmd () { print -Pn "\e]0;%~\a" }
        preexec () { print -Pn "\e]0;%~ ($1)\a" }
    ;;
    screen)
        precmd () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;%n@%M [%~]\a"
        }
        preexec () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;%n@%M [%~] ($1)\a"
        }
    ;;
esac

setprompt () {
    autoload -U colors zsh/terminfo
    colors
    setopt prompt_subst
 
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
    PR_USER="%n"
    PR_DATE="%T"
 
    PROMPT=$'${PR_GREEN}${PR_USER}${PR_NO_COLOR} ${PR_WHITE}%~${PR_NO_COLOR} ${PR_MAGENTA}»${PR_NO_COLOR} '
    #RPROMPT=$'${PR_MAGENTA}«${PR_NO_COLOR} ${PR_BLUE}${PR_DATE}${PR_NO_COLOR}'
}
 
setprompt

# history {{{1
HISTFILE=~/.zsh/history
HISTSIZE=3000
SAVEHIST=3000

# options {{{1
setopt automenu				# use menu completion after 2nd TAB
setopt autocd				# try cd command if not executable
setopt autopushd			# automatically append dirs to the push/pop list
setopt pushd_minus			# switch + and - when used on directory stack number
setopt globdots				# no leading . in a filename required to be matched
setopt noclobber			# use >! and >>! instead of > and >> to create or truncate files
setopt histreduceblanks		# remove superfluous blanks from history lines
setopt histignorespace		# remove history lines with leading space
setopt sharehistory			# share history in realtime between shells and use timestamps
#setopt incappendhistory	# every zsh session appends to history file (without waiting til shell exits)
#setopt extendedhistory		# puts timestamps in the history
setopt pushdignoredups		# don't push duplicates onto the directory stack
setopt histignorealldups	# remove duplicates from history
#setopt cdablevars			# avoid the need for an explicit $
setopt nohup				# and don't kill them, either
setopt nolisttypes			# show types in completion
setopt extendedglob			# weird & wacky pattern matching - yay zsh!
setopt completeinword		# not just at the end
setopt alwaystoend			# when complete from middle, move cursor
setopt nopromptcr			# don't add \n which overwrites cmds with no \n
setopt histverify			# when using ! cmds, confirm first
setopt interactivecomments	# escape commands so i can use them later
setopt nobeep				# turn off beeps


# completion {{{1
compctl -/ cd				# type a dir's name to cd into it

# functions {{{1
extract () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar xvzf $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        tar xvjf $1
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar x $1
    elif [[ $lower == *.tar ]]; then
        tar xvf $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
    # Change in to the newly created directory, and
    # list the directory contents, if there is one.
    current_dirs=( *(N/) )
    for i in {1..${#current_dirs}}; do
        if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
            cd $current_dirs[$i]
            break
        fi
    done
}

roll () {
    FILE=$1
    case $FILE in
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.tar) shift && tar cf $FILE $* ;;
        *.zip) shift && zip $FILE $* ;;
        *.7z) shift && 7z x $FILE $* ;;
    esac
}

udevinfo () {
    DPATH=$(udevadm info -q path -n $1)
    udevadm info -a -p $DPATH
}

mkcd () { mkdir "$1" && cd "$1"; }

psgrep () { ps ax | grep $1 | grep -v grep }

genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=20
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

shdebug() {
	env PS4=' ${BASH_SOURCE}:${LINENO}(${FUNCNAME[0]}) ' sh -x $*
}

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# keybinds {{{1
bindkey "\e[1~" beginning-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
bindkey -M menuselect "\C-N" accept-and-menu-complete
