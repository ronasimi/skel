# vi mode
bindkey -v

# TERMINAL TYPE
export TERM='xterm-256color'

# WINDOW TITLE
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () { print -Pn "\e]0;%n@%m: %~\a" } 
    preexec () { print -Pn "\e]0;$1\a" }
  ;;
  screen|screen-256color)
    precmd () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM\a" 
      }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - $1\a" 
      }
  ;; 
esac

HISTFILE=~/.histfile
HISTSIZE=1024
SAVEHIST=1024
autoload -U colors zsh-mime-setup select-word-style
colors          # colors
zsh-mime-setup  # run everything as if it's an executable
select-word-style bash # ctrl+w on words

zstyle :compinstall filename '/home/ron/.zshrc'

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# ADDITIONAL KEYBINDINGS
bindkey '\e[1;5C' forward-word            # C-Right		
bindkey '\e[1;5D' backward-word           # C-Left		
bindkey '\e[5~'   history-search-backward # PgUp		
bindkey '\e[6~'   history-search-forward  # PgDn		
bindkey '^R'      history-incremental-pattern-search-backward

#autoload -U promptinit
#promptinit

# AUTOCOMPLETION
autoload -U compinit
compinit
zmodload -i zsh/complist        
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt interactivecomments	# bash style interactive comments

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} =     # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu yes select
zstyle ':completion:*' force-list always
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:*:killall:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
users=(ron root)           # because I don't care about others
zstyle ':completion:*' users $users

#generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic gdb

# AUTOCOLOR
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Modified Solarized dark color scheme
# ------------------------------------
function solar
{
   if [ "$TERM" = "linux" ]
   then
    	echo -en "\e]P8262626" #_grey    base03
  	echo -en "\e]P01c1c1c" # black   base02
      	echo -en "\e]PA586e75" # green   base01
      	echo -en "\e]PB657b83" # yellow  base00
      	echo -en "\e]PC839496" # blue    base0
      	echo -en "\e]PE93a1a1" # cyan    base1
      	echo -en "\e]P7eee8d5" #*grey    base2
      	echo -en "\e]PFfdf6e3" # white   base3
      	echo -en "\e]P3b58900" # brown   yellow
      	echo -en "\e]P9cb4b16" # red     orange
      	echo -en "\e]P1dc322f" #_red     red
      	echo -en "\e]P5d33682" #_magenta magenta
      	echo -en "\e]PD6c71c4" # magenta violet
      	echo -en "\e]P4268bd2" #_blue    blue
      	echo -en "\e]P62aa198" #_cyan    cyan
      	echo -en "\e]P2859900" #_green   green
      	clear #for artifacting
   fi
}

# PATHS
export PATH=/usr/local/bin:$PATH
export PATH=/home/ron/.bin:$PATH

# EDITOR
export EDITOR="nano"

# CCACHE
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

#PKGFILE HOOK
source /usr/share/doc/pkgfile/command-not-found.zsh

# COLORED MAN PAGES
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;33;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

# POWERLINE
powerline-daemon -q
. /usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh
