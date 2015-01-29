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
export BROWSER='chromium'
export HISTCONTROL='ignoredups'
export MOZ_DISABLE_PANGO=1
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export LIBVA_DRIVER_NAME="vdpau"
export VDPAU_DRIVER="r600"
export STEAM_FRAME_FORCE_CLOSE=1

# color manpages without using most
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# linux console colors
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P8505354" #darkgrey
    echo -en "\e]P1f92672" #darkred
    echo -en "\e]P9ff5995" #red
    echo -en "\e]P282b414" #darkgreen
    echo -en "\e]PAb6e354" #green
    echo -en "\e]P3fd971f" #brown
    echo -en "\e]PBfeed6c" #yellow
    echo -en "\e]P456c2d6" #darkblue
    echo -en "\e]PC8cedff" #blue
    echo -en "\e]P58c54fe" #darkmagenta
    echo -en "\e]PD9e6ffe" #magenta
    echo -en "\e]P6465457" #darkcyan
    echo -en "\e]PE899ca1" #cyan
    echo -en "\e]P7ccccc6" #lightgrey
    echo -en "\e]PFf8f8f2" #white
    clear # back to default input colours
fi

# source files {{{1
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

#zmodload zsh/complist

## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

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
#bindkey -M menuselect "\C-n" accept-and-menu-complete

## file rename magic
bindkey "^xp" copy-prev-shell-word

#m# k Shift-tab Perform backwards menu completion
if [[ -n "$terminfo[kcbt]" ]]; then
    bindkey "$terminfo[kcbt]" reverse-menu-complete
elif [[ -n "$terminfo[cbt]" ]]; then # required for GNU screen
    bindkey "$terminfo[cbt]"  reverse-menu-complete
fi

# aliases {{{1
alias e="$EDITOR"
alias l="$PAGER"
alias m="mplayer -nolirc"
alias p="pacman"
alias s="sudo "
alias ls="ls -A -h --group-directories-first -F --color=auto"
alias lb="ls -A -s --block-size=1 --group-directories-first -F --color=auto"
alias ll="ls --group-directories-first --color -l -F"
alias rm="rm -I"
alias mkdir="mkdir -pv"
alias dl="cd /home/racoon/files/downloads"
alias fmusic="cd /mnt/music/music"
alias fabs="cd /mnt/sdb3/cache/abs/local/"
alias fgit="cd /mnt/sdb3/cache/git/"
alias grep='grep --color=auto -d skip'
alias irssi="screen -D -R irssi irssi"
alias wrk='screen -c $HOME/.config/scriptz/screen-wrk -D -R wrk'
#alias rrtorrent='ssh -t tha screen -D -R rtorrent rtorrent'
alias newsbeuter='TERM=xterm newsbeuter'
alias chm-d="find -type d -exec chmod 755 {} \;"
alias chm-f="find -type f -exec chmod 644 {} \;"
alias myip="curl icanhazip.com"
alias defrag="/opt/quake3/iodfengine.x86_64 +set fs_game defrag +disconnect"
alias mkpw="makepasswd --chars=10 --string=123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ-_. --count=1"
alias skype='xhost +local: && sudo -u skype /usr/bin/skype'
alias startx="startx -nolisten tcp"
#alias mailfetch="ssh rha fdm fetch && offlineimap -u basic -o"
alias xev-slim="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias pd="plowdown --skip-final --run-after ~/files/scripts/ariaplow.sh"
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

# history {{{1
HISTFILE=~/.zsh/history
HISTSIZE=3000
SAVEHIST=3000

# options {{{1
setopt alwaystoend          # when complete from middle, move cursor
setopt append_history       # append history list to the history file (important for multiple parallel zsh sessions!)
setopt auto_cd              # try cd command if not executable
setopt auto_menu            # use menu completion after 2nd TAB
setopt auto_pushd           # automatically append dirs to the push/pop list
#setopt cdablevars          # avoid the need for an explicit $
setopt completeinword       # not just at the end
setopt extendedglob         # weird & wacky pattern matching - yay zsh!
#setopt extendedhistory     # puts timestamps in the history
unsetopt flow_control       # if unset, output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled
setopt globdots             # no leading . in a filename required to be matched
setopt hash_list_all        # whenever a command completion is attempted, make sure the entire command path is hashed first
setopt histignorealldups    # remove duplicates from history
setopt histignorespace      # remove history lines with leading space
setopt histreduceblanks     # remove superfluous blanks from history lines
setopt histverify           # when using ! cmds, confirm first
#setopt incappendhistory    # every zsh session appends to history file (without waiting til shell exits)
setopt interactivecomments  # escape commands so i can use them later
unsetopt menu_complete      # do not autoselect the first completion entry
setopt long_list_jobs       # list jobs in the long format by default
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
setopt nobeep               # turn off beeps
setopt noclobber            # use >! and >>! instead of > and >> to create or truncate files
#setopt noglobdots          # * shouldn't match dotfiles. ever.
setopt nohup                # and don't kill them, either
setopt nolisttypes          # show types in completion
setopt nonomatch            # try to avoid the 'zsh: no matches found...'
#setopt nopromptcr          # don't add \n which overwrites cmds with no \n
setopt notify               # report the status of backgrounds jobs immediately
setopt noshwordsplit        # use zsh style word splitting
setopt pushd_minus          # switch + and - when used on directory stack number
setopt pushdignoredups      # don't push duplicates onto the directory stack
setopt sharehistory         # share history in realtime between shells and use timestamps
setopt unset                # don't error out when unset parameters are used

# completion {{{1
compctl -/ cd                       # type a dir's name to cd into it
zstyle ':completion:*' menu select  # autocompletion with an arrow-key driven interface
zstyle :compinstall filename '${HOME}/.zshrc'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
zstyle ':completion:*:correct:*' insert-unambiguous true	# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:man:*' menu yes select
zstyle ':completion:*:history-words' menu yes 			# activate menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select 	# complete 'cd -<tab>' with menu
zstyle ':completion:*' menu select=5

zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
 
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
 
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
          ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ }
          ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
          ${${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && <~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*}
          )'
 
# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
 
# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
 
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
 
# Include non-hidden directories in globbed file completions for certain commands
zstyle ':completion::complete:*' '\'
 
# tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
 
# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:-command-:*:' verbose false
 
# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'
 
# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"
 
# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
 
# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true

# functions {{{1

# extract {{{2
function extract() {
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

# roll {{{2
function roll () {
    FILE=$1
    case $FILE in
        *.tar.bz2) shift && tar cjf $FILE $* ;;
        *.tar.gz) shift && tar czf $FILE $* ;;
        *.tgz) shift && tar czf $FILE $* ;;
        *.tar) shift && tar cf $FILE $* ;;
        *.zip) shift && zip $FILE -r $* ;;
        *.7z) shift && 7z a $FILE $* ;;
    esac
}

# udevinfo {{{2
function udevinfo () {
    DPATH=$(udevadm info -q path -n $1)
    udevadm info -a -p $DPATH
}

# mkcd {{{2
function mkcd () { mkdir "$1" && cd "$1"; }

# psgrep {{{2
function psgrep () { ps ax | grep $1 | grep -v grep; }

# genpasswd {{{2
function genpasswd() {
    local l=$1
    [ "$l" == "" ] && l=20
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

# debug {{{2
function shdebug() { env PS4=' ${BASH_SOURCE}:${LINENO}(${FUNCNAME[0]}) ' sh -x $*; }
function bashdebug() { env PS4=' ${BASH_SOURCE}:${LINENO}(${FUNCNAME[0]}) ' bash -x $*; }

# youtubeConvert {{{2
function youtubeConvert() {
    ffmpeg -i $1 -c:v libx264 -crf 18 -preset slow -pix_fmt yuv420p -c:a copy ${1%.*}\ \(youtube\ ready\).mkv
}

# flac2mp3 {{{2
function flac2mp3() {
    [[ $1 = "-d" ]] && DEL=1 && shift
    for i in "$@"; do

        TART=$(metaflac --show-tag=ARTIST $i)
        TTIT=$(metaflac --show-tag=TITLE $i)
        TYR=$(metaflac --show-tag=DATE $i)
        TALB=$(metaflac --show-tag=ALBUM $i)
        TGNR=$(metaflac --show-tag=GENRE $i)
        TTNR=$(metaflac --show-tag=TRACKNUMBER $i)

        flac -c -d "$i" | lame --noreplaygain --cbr -m s -h -b 320 \
        --add-id3v2 --pad-id3v2 --ignore-tag-errors \
        --tt "${TTIT#*=}" \
        --tn "${TTNR#*=}" \
        --ta "${TART#*=}" \
        --tl "${TALB#*=}" \
        --ty "${TYR#*=}" \
        --tg "${TGNR#*=}" \
        - "${i/.flac/.mp3}" && \
        [[ $DEL == 1 ]] && rm "$i"
    done
}

# filename2tag {{{2
function filename2tag() {
    for file in "$@"; do
        ALBUM=$(sed 's/\(\[.*\] \)\?\(.*\)\( - \)\(.*\)\([[(][12][09][0-9][0-9][])]\)/\4/' <<<"${PWD##*/}")
        ALBUM="${ALBUM% }"
        ALBUM="${ALBUM% \[[0-9A-Z]*\]}"
        YEAR=$(grep -oP '(?<=[\[\(])[12][09][0-9]{2}(?=[\]\)])' <<<"${PWD##*/}")
        ARTIST=$(sed 's/^\([0-9]*\ \)\?\(.*\)\( - \)\(.*\)\(\..*$\)/\2/' <<<"$file")
        TITLE=$(sed 's/^\([0-9]*\ \)\?\(.*\)\( - \)\(.*\)\(\..*$\)/\4/' <<<"$file")
        
        echo -e "album:\t$ALBUM"
        echo -e "year:\t$YEAR"
        echo -e "file:\t${file%.*}"
        echo -e "artist:\t$ARTIST"
        echo -e "title:\t$TITLE"
    
        case $file in
            *.mp3)
                id3tag --artist="$ARTIST" --song="$TITLE" --album="$ALBUM" --year="$YEAR" "$file"
            ;;
            *.flac)
                flac -T ARTIST="$ARTIST" TITLE="$TITLE" ALBUM="$ALBUM" DATE="$YEAR" "$file"
            ;;
        esac
    done
}

# tag2filename {{{2
function tag2filename() {
    for file in "$@"; do
        case $file in
            *.mp3)
                FILENAME=$(basename "$file")
                ARTIST=`/usr/bin/mutagen-inspect "$file" | grep TPE1`
                TITLE=`/usr/bin/mutagen-inspect "$file" | grep TIT2`
                NR=`/usr/bin/mutagen-inspect "$file" | grep TRCK`
                /bin/mv -v "$file" "${NR%%/*} ${ARTIST#*=} - ${TITLE#*=}${file##*.}"
            ;;
            *.flac)
                ARTIST=$(metaflac --show-tag=ARTIST $file)
                TITLE=$(metaflac --show-tag=TITLE $file)
                YEAR=$(metaflac --show-tag=DATE $file)
                ALBUM=$(metaflac --show-tag=ALBUM $file)
                NR=$(metaflac --show-tag=TRACKNUMBER $file)
                echo
                echo -e "file:\t$file"
                echo -e "artist:\t${ARTIST#*=}"
                echo -e "title:\t${TITLE#*=}"
                echo
                /bin/mv -v "$file" "`printf '%02d' ${NR#*=}` ${ARTIST#*=} - ${TITLE#*=}.${file##*.}"
                
            ;;
        esac
    done
}

# git_prompt {{{2
function git_prompt_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}"
}

function git_prompt_status() {
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

    ZSH_THEME_GIT_PROMPT_PREFIX="${PR_RED}"
    #ZSH_THEME_GIT_PROMPT_PREFIX="${PR_BLUE}git:${PR_RED}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="${PR_NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_DIRTY="${PR_BLUE} ${PR_YELLOW}*${PR_NO_COLOR}"
    ZSH_THEME_GIT_PROMPT_CLEAN="${PR_BLUE}"
 
    ZSH_THEME_GIT_PROMPT_ADDED="${PR_GREEN} +"
    ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_BLUE} M"
    ZSH_THEME_GIT_PROMPT_DELETED="${PR_RED} D"
    ZSH_THEME_GIT_PROMPT_RENAMED="${PR_MAGENTA} R"
    ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_YELLOW} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_CYAN} -"

    #VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"

    PROMPT=$'${PR_GREEN}${PR_USER}${PR_NO_COLOR} ${PR_WHITE}%~${PR_NO_COLOR} ${PR_MAGENTA}%(!.#.») ${PR_NO_COLOR} '
    RPS1='${PR_MAGENTA}« ${PR_YELLOW}[${PR_NO_COLOR}%?${PR_YELLOW}]${PR_NO_COLOR} $(git_prompt_branch)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX'
}
 
setprompt
