# tty
bindkey "^[[1~"   beginning-of-line  # Home
bindkey "^[[4~"   end-of-line        # End
bindkey "^[[3~"   delete-char        # Delete
# no Alt+Right
# no Alt+Left
# no Ctrl+Right
# no Ctrl+Left
# no Ctrl+Bksp
# no Ctrl+Del

# pts
bindkey "^[[H"    beginning-of-line  # Home
bindkey "^[[F"    end-of-line        # End
bindkey "^[[3~"   delete-char        # Delete
bindkey "^[[1;3C" forward-word       # Alt+Right
bindkey "^[[1;3D" backward-word      # Alt+Left
bindkey "^[[1;5C" forward-word       # Ctrl+Right
bindkey "^[[1;5D" backward-word      # Ctrl+Left
bindkey "^H"      backward-kill-word # Ctrl+Bksp
bindkey "^[[3;5~" kill-word          # Ctrl+Del

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{red}$?%f %(!.%F{red}%n%f.%F{blue}%n%f) %F{green}%*%f %F{white}%~%f %F{red}${vcs_info_msg_0_}%f%# '

WORDCHARS=_

alias ls=' ls --color=auto -F'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -al'
alias pwd=' pwd'
alias clear=' clear'
alias exit=' exit'
alias grep='grep --color=auto'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

SAVEHIST=1000
HISTFILE="$XDG_STATE_HOME"/zsh/history
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS

# Completion files: Use XDG dirs
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
autoload -Uz compinit
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
