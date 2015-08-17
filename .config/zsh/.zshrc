#!/bin/zsh

# antigen {{{1
antigen_url="https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh"
[[ -r ${ADOTDIR}/antigen.zsh ]] || ( mkdir $ADOTDIR && curl -L "$antigen_url" -o ${ADOTDIR}/antigen.zsh )
source ${ADOTDIR}/antigen.zsh

antigen bundle zsh-users/zsh-completions src/
antigen bundle zsh-users/zsh-history-substring-search
antigen apply

# zsh-history-substring-search
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=red,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

# source files {{{1
zsh_files[1]="${ZDOTDIR}/functions"
zsh_files[2]="${ZDOTDIR}/zshrc.local"
zsh_files[3]="${ZDOTDIR}/base16-default.dark.rcn.sh"
# TODO: customize fzf bindings
zsh_files[4]="/etc/profile.d/fzf.zsh"

for zsh_file in ${zsh_files[@]}; do
    [[ -f $zsh_file ]] && source $zsh_file
done

# keybinds {{{1
bindkey "\e[1~" beginning-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[3~" delete-char
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history

# proper incremental history line search
autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# file rename magic
bindkey "^xp" copy-prev-shell-word

# Paste the selected entry from locate output into the command line
bindkey '\ei' fzf-locate-widget

# Quick cd to bookmarked directory
bindkey '\eb' fzf-cd-bookmark

# Paste the selected command from history into the command line
bindkey '^R' fzf-history

# load interface to the terminfo database
zmodload zsh/terminfo

# Shift-tab to perform backwards menu completion
[[ -n "$terminfo[kcbt]" ]]  &&  bindkey "$terminfo[kcbt]" reverse-menu-complete
[[ -n "$terminfo[cbt]" ]]   &&  bindkey "$terminfo[cbt]"  reverse-menu-complete

# aliases {{{1
alias e="$EDITOR"
alias l="$PAGER"
alias m="mpv"
alias p="pacman"
alias y="yaourt"
alias s="sudo "
alias ls="ls -A -h --group-directories-first -F --color=auto"
alias lb="ls -A -s --block-size=1 --group-directories-first -F --color=auto"
alias ll="ls --group-directories-first --color -l -F"
alias rm="rm -I"
alias mkdir="mkdir -pv"
alias mnt="mount |column -t"
alias grep='grep --color=auto -d skip'
alias zrep='zgrep --color=auto -d skip'
alias wrk='screen -c $HOME/.config/scriptz/screen-wrk -D -R wrk'
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
HISTFILE=${ZDOTDIR}/history
HISTSIZE=10000
SAVEHIST=10000

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
setopt histignorespace      # remove history lines with leading space
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

# Disable CTRL-s and CTRL-q
[[ $- =~ i ]] && stty -ixoff -ixon

# completion {{{1
# load completion
autoload -U compinit && compinit

# load completion listing extensions
zmodload zsh/complist

# autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

# provide verbose completion information
zstyle ':completion:*' verbose true

# persistent rehash to find new executables after installing
zstyle ':completion:*' rehash true

# activate color-completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# expansion options
# allow one error for every three characters typed in approximate completer
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:' max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# activate menu completion for kill/killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*' original true

# activate menu
zstyle ':completion:*:history-words' menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' stop yes 

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
 
# completion caching
zstyle ':completion:*' use-cache yes
zstyle ':completion::complete:*' cache-path ${ZDOTDIR}/cache/$HOST
 
# expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:history-words' list false
 
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ignore completion functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# include non-hidden directories in globbed file completions for certain commands
zstyle ':completion::complete:*' '\'
 
# tag-order 'globbed-files directories' all-files
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'
 
# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:' verbose false
 
# separate matches into groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
 
# format on completion
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format $'%{\e[0;33m%}No matches for:%{\e[0m%} %d'
 
# describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
 
# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:man:*' menu yes select

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*' menu select=5

# ssh/scp host and login completion
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
          ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ }
          ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
          ${${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && <~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*}
          )'
# }}}

# load renaming function
autoload zmv

# load user prompt
( autoload -U promptinit && promptinit ) && setprompt

# vim: fdm=marker ts=4 sw=4
