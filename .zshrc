#!/bin/zsh

# $HOME/.zshrc
# vim: fdm=marker ts=4 sw=4

# environment {{{1
# Dircolors...
eval `dircolors -b`
 
# Exports
typeset -U path
path=($HOME/bin/ /usr/bin/core_perl/ /usr/bin/vendor_perl/ $path)
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

# color manpages without using most
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

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
alias y="yaourt"
alias s="sudo "
alias ls="ls -A -h --group-directories-first -F --color=auto"
alias lb="ls -A -s --block-size=1 --group-directories-first -F --color=auto"
alias ll="ls --group-directories-first --color -l -F"
alias rm="rm -I"
alias cp="advcp -g"
alias mv="advmv -g"
alias dl="cd /home/racoon/files/downloads"
alias music="cd /mnt/music/music"
alias fkvm="cd /mnt/sdb3/kvm"
alias fabs="cd /mnt/sdb3/cache/abs/local/"
alias fgit="cd /mnt/sdb3/cache/git/"
alias fxwax="cd /mnt/sdb3/xwax/"
alias grep='grep --color=auto -d skip'
alias exit="clear; exit"
alias irssi="screen -D -R irssi irssi"
#alias rtorrent='screen -D -R rtorrent rtorrent'
alias wrk='screen -c $XDG_CONFIG_HOME/scriptz/screen-wrk -D -R wrk'
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
alias aljazeera="rtmpdump -v -r rtmp://livestfslivefs.fplive.net/livestfslive-live/ -y "aljazeera_en_veryhigh" -a "aljazeeraflashlive-live" -o -| mplayer -"
alias defrag="quake3 +set fs_game defrag +disconnect"
alias startx="startx -nolisten tcp"

# history {{{1
HISTFILE=~/.zsh/history
HISTSIZE=3000
SAVEHIST=3000

# options {{{1
setopt alwaystoend          # when complete from middle, move cursor
setopt auto_cd              # try cd command if not executable
setopt auto_menu            # use menu completion after 2nd TAB
setopt auto_pushd           # automatically append dirs to the push/pop list
#setopt cdablevars          # avoid the need for an explicit $
setopt completeinword       # not just at the end
setopt extendedglob         # weird & wacky pattern matching - yay zsh!
#setopt extendedhistory     # puts timestamps in the history
unsetopt flow_control       # if unset, output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled
setopt globdots             # no leading . in a filename required to be matched
setopt histignorealldups    # remove duplicates from history
setopt histignorespace      # remove history lines with leading space
setopt histreduceblanks     # remove superfluous blanks from history lines
setopt histverify           # when using ! cmds, confirm first
#setopt incappendhistory    # every zsh session appends to history file (without waiting til shell exits)
setopt interactivecomments  # escape commands so i can use them later
unsetopt menu_complete      # do not autoselect the first completion entry
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
setopt nobeep               # turn off beeps
setopt noclobber            # use >! and >>! instead of > and >> to create or truncate files
setopt nohup                # and don't kill them, either
setopt nolisttypes          # show types in completion
#setopt nopromptcr          # don't add \n which overwrites cmds with no \n
setopt pushd_minus          # switch + and - when used on directory stack number
setopt pushdignoredups      # don't push duplicates onto the directory stack
setopt sharehistory         # share history in realtime between shells and use timestamps

# completion {{{1
compctl -/ cd               # type a dir's name to cd into it

# functions {{{1
extract() {
    local old_dirs current_dirs lower
    old_dirs=( *(N/) )
    unset REMOVE_ARCHIVE
    
    if test "$1" = "-r"; then
        REMOVE_ARCHIVE=1
        shift
    fi

    if [[ -f $1 ]]; then
        lower=${(L)1}
        case $lower in
            *.tar.bz2) tar xvjf $1;;
            *.tar.gz) tar xvzf $1;;
            *.tar.xz) tar xvJf $1;;
            *.tar.lzma) tar --lzma -xvf $1;;
            *.bz2) bunzip $1;;
            *.rar) unrar x $1;;
            *.gz) gunzip $1;;
            *.tar) tar xvf $1;;
            *.tbz2) tar xvjf $1;;
            *.tgz) tar xvzf $1;;
            *.zip) unzip $1;;
            *.Z) uncompress $1;;
            *.7z) 7z x $1;;
            *) echo "'$1' cannot be extracted via >extract<"; return 1;;
        esac

        if [[ $REMOVE_ARCHIVE -eq 1 && $? -eq 0 ]]; then
            echo removing "$1";
            /bin/rm "$1";
        fi

    else
        echo "'$1' is not a valid file"
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

psgrep () { ps ax | grep $1 | grep -v grep; }

genpasswd() {
    local l=$1
    [ "$l" == "" ] && l=20
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

shdebug() { env PS4=' ${BASH_SOURCE}:${LINENO}(${FUNCNAME[0]}) ' sh -x $*; }

bashdebug() { env PS4=' ${BASH_SOURCE}:${LINENO}(${FUNCNAME[0]}) ' bash -x $*; }

irclog() {
    local LOG="$1"
    local SEARCH="$2"
    local LOGPATH=$HOME/files/logs/irclogs
    case $LOG in
        bc) grep "$SEARCH" "$LOGPATH/B_OFTC/#bitcrush.log" ;;
        g) grep "$SEARCH" "$LOGPATH/B_OFTC/geroyche.log" ;;
        s) grep "$SEARCH" "$LOGPATH/B_OFTC/sure.log" ;;
        t) grep "$SEARCH" "$LOGPATH/B_OFTC/tex.log" ;;
        *) echo "\"$LOG\" is not a supported parameter (bc,g,s,t)" ;;
    esac
}

yamj() {
    local HD="$1"
    cd $HOME/files/downloads/popcorn\ hour/yamj
    case $HD in
        nici) ./MovieJukebox.sh -k -c -p tvjukebox-nici.properties ;;
        movie) ./MovieJukebox.sh -k -c ;;
        tv) ./MovieJukebox.sh -k -c -p tvjukebox.properties ;;
        *) echo "\"$HD\" unknown argument." ;;
    esac
}

flac2mp3() {
    for i in *.flac; do
        flac -d "$i" && lame --cbr -m s -h -b 320 "${i/.flac/.wav}" "${i/.flac/.mp3}" && \
        rm "${i/.flac/.wav}" && \
        [[ $1 = "-d" ]] && rm "$i"
    done
}

git_prompt_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}"
}

git_prompt_status() {
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    elif $(echo "$INDEX" | grep '^M ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    echo $STATUS
}

#zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

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

# prompt {{{1
setprompt() {
    autoload -U colors zsh/terminfo
    colors
    setopt prompt_subst
 
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    done

    PR_NO_COLOR="%{$terminfo[sgr0]%}"
    PR_USER="%n"

    ZSH_THEME_GIT_PROMPT_PREFIX="${PR_MAGENTA}« ${PR_BLUE}git:${PR_RED}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="${PR_NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_DIRTY="${PR_BLUE} ${PR_YELLOW}*${PR_NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_CLEAN="${PR_BLUE}"
 
    ZSH_THEME_GIT_PROMPT_ADDED="${PR_GREEN} +"
    ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_BLUE} M"
    ZSH_THEME_GIT_PROMPT_DELETED="${PR_RED} D"
    ZSH_THEME_GIT_PROMPT_RENAMED="${PR_MAGENTA} R"
    ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_YELLOW} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_CYAN} -"

    PROMPT=$'${PR_GREEN}${PR_USER}${PR_NO_COLOR} ${PR_WHITE}%~${PR_NO_COLOR} ${PR_MAGENTA}%(!.#.») ${PR_NO_COLOR} '
    RPS1='$(git_prompt_branch)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX'
}
 
setprompt
