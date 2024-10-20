# Set up the prompt

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'



# configure word navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# configure general aliases
alias ll="ls -l"

# enable starship
USE_STARSHIP=false
if [[ $USE_STARSHIP == true ]] && [[ $(command -v starship) == /* ]]; then
	eval "$(starship init zsh)"
else
	autoload -Uz promptinit
	promptinit
	prompt adam1
fi
unset USE_STARSHIP

# configure docker
if [[ $(command -v docker) == /* ]]; then
	alias dr="docker run"
	alias dps="docker ps"
	alias dpsa="docker ps -a"
	alias drm="docker rm"
	alias drmf="docker rm -f"
fi

# configure k8s
if [[ $(command -v kubectl) == /* ]]; then
	source <(kubectl completion zsh)
	alias k="kubectl"
	alias kg="kubectl get"
	alias kd="kubectl describe"
	alias kl="kubectl logs"
fi

# configure helm
if [[ $(command -v helm) == /* ]]; then
	source <(helm completion zsh)
fi
