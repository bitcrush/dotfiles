#!/bin/zsh

# $HOME/.zshrc
# vim: fdm=marker ts=4 sw=4

# environment {{{1
# Dircolors...
eval `dircolors -b`

# Exports
typeset -U path
path=($HOME/bin/ /usr/bin/core_perl/ /usr/bin/vendor_perl/ $path)
export LANGUAGE='en_US.utf8'
export LOCALE='en_US.utf8'
export LC_ALL='en_US.utf8'
export LC_COLLATE='C'
export EDITOR='vim'
export PAGER='less'
export VISUAL='vim'
export BROWSER='firefox'
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export LIBVA_DRIVER_NAME="vdpau"
export VDPAU_DRIVER="r600"
export STEAM_FRAME_FORCE_CLOSE=1

# zsh-history-substring-search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

# color manpages without using most
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# linux console colors
# TODO: set to base16
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
else
    # set additional colors for base16-theme
    printf_template="\033]4;%d;rgb:%s\033\\"
    printf $printf_template 16 "dc/96/56"
    printf $printf_template 17 "a1/69/46"
    printf $printf_template 18 "28/28/28"
    printf $printf_template 19 "38/38/38"
    printf $printf_template 20 "b8/b8/b8"
    printf $printf_template 21 "e8/e8/e8"
    unset printf_template
fi

# source files {{{1
#source ~/.zsh/zle
source ~/.zsh/functions

# antigen {{{1
source ~/.zsh/antigen/antigen.zsh
#antigen bundle robbyrussell/oh-my-zsh lib/
#antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen apply

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
zmodload zsh/terminfo

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
#bindkey "\e[A" history-search-backward
#bindkey "\e[B" history-search-forward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
#bindkey -M menuselect "\C-n" accept-and-menu-complete

# file rename magic
bindkey "^xp" copy-prev-shell-word

# Shift-tab to perform backwards menu completion
if [[ -n "$terminfo[kcbt]" ]]; then
    bindkey "$terminfo[kcbt]" reverse-menu-complete
elif [[ -n "$terminfo[cbt]" ]]; then # required for GNU screen
    bindkey "$terminfo[cbt]"  reverse-menu-complete
fi

# aliases {{{1
alias e="$EDITOR"
alias l="$PAGER"
alias m="mpv"
alias p="pacman"
alias s="sudo "
alias ls="ls -A -h --group-directories-first -F --color=auto"
alias lb="ls -A -s --block-size=1 --group-directories-first -F --color=auto"
alias ll="ls --group-directories-first --color -l -F"
alias rm="rm -I"
alias mkdir="mkdir -pv"
alias j="jobs -l"
alias mnt="mount |column -t"
alias dl="cd /home/racoon/files/downloads"
alias fmusic="cd /mnt/music/music"
alias fabs="cd /mnt/sdb3/cache/abs/local/"
alias fgit="cd /mnt/sdb3/cache/git/"
alias grep='grep --color=auto -d skip'
alias irssi="screen -D -R irssi irssi"
alias wrk='screen -c $HOME/.config/scriptz/screen-wrk -D -R wrk'
#alias rrtorrent='ssh -t tha screen -D -R rtorrent rtorrent'
alias chm-d="find -type d -exec chmod 755 {} \;"
alias chm-f="find -type f -exec chmod 644 {} \;"
alias myip="curl icanhazip.com"
alias defrag="/opt/quake3/iodfengine.x86_64 +set fs_game defrag +disconnect"
alias mkpw="makepasswd --chars=10 --string=123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ-_. --count=1"
alias skype='xhost +local: && sudo -u skype /usr/bin/skype'
alias startx="startx -nolisten tcp"
alias xev-slim="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias vw='vim -c VimwikiIndex'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias steamclean='find ~/.local/share/Steam/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" \) -print -delete'

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
unsetopt beep               # turn off beeps
unsetopt clobber            # use >! and >>! instead of > and >> to create or truncate files
setopt completeinword       # not just at the end
setopt extendedglob         # weird & wacky pattern matching - yay zsh!
setopt extendedhistory      # puts timestamps in the history
unsetopt flow_control       # if unset, output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled
unsetopt globdots           # * shouldn't match dotfiles. ever.
setopt hash_list_all        # whenever a command completion is attempted, make sure the entire command path is hashed first
setopt histignorealldups    # remove duplicates from history
unsetopt histignorespace    # remove history lines with leading space
setopt histreduceblanks     # remove superfluous blanks from history lines
setopt histverify           # when using ! cmds, confirm first
unsetopt hup                # and don't kill them, either
setopt incappendhistory     # every zsh session appends to history file (without waiting til shell exits)
setopt interactivecomments  # escape commands so i can use them later
unsetopt listtypes          # show types in completion
setopt long_list_jobs       # list jobs in the long format by default
unsetopt menu_complete      # do not autoselect the first completion entry
setopt multios              # perform implicit tees or cats when multiple redirections are attempted
unsetopt nomatch            # try to avoid the 'zsh: no matches found...'
setopt notify               # report the status of backgrounds jobs immediately
setopt pushd_minus          # switch + and - when used on directory stack number
setopt pushdignoredups      # don't push duplicates onto the directory stack
setopt sharehistory         # share history in realtime between shells and use timestamps
unsetopt shwordsplit        # use zsh style word splitting
setopt unset                # don't error out when unset parameters are used

# completion {{{1
compctl -/ cd                       # type a dir's name to cd into it
zstyle ':completion:*' menu select  # autocompletion with an arrow-key driven interface
zstyle :compinstall filename '${HOME}/.zshrc'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:man:*' menu yes select
# activate menu
zstyle ':completion:*:history-words' menu yes
# complete 'cd -<tab>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*' menu select=5
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
 
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
# }}}

setprompt
