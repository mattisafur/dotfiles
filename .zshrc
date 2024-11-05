# zsh options
setopt interactivecomments # allow comments in interactive shell
setopt histignorealldups   # pervent duplicates in history file
setopt sharehistory        # share history accross all shell sessions

# use emacs keybinds
bindkey -e

# command completion
autoload -Uz compinit
compinit

# configure history
HISTFILE=1000             # max history entries
SAVEHIST=1000             # max history saved to file
HISTFILE="~/.zsh_history" # history file path

# configure word navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# configure general aliases
alias ll="ls -l"
alias lsa="ls -a"
alias lla="ls -la"

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

	alias dc="docker compose"
	alias dcu="docker compose up"
	alias dcud="docker compose up -d"
	alias dcd="docker compose down"
	alias dcps="docker compose ps"
	alias dcpsa="docker compose ps -a"
fi

# configure k8s
if [[ $(command -v kubectl) == /* ]]; then
	source <(kubectl completion zsh)

	alias k="kubectl"
	alias kg="kubectl get"
	alias kd="kubectl describe"
	alias kl="kubectl logs"
	alias kc="kubectl create"
	alias ka="kubectl apply"
	alias kconf="kubectl config"
fi

# configure helm
if [[ $(command -v helm) == /* ]]; then
	source <(helm completion zsh)
fi

# configure terraform
if [[ $(command -v terraform) == /* ]]; then
	autoload -U +X bashcompinit && bashcompinit
	complete -o nospace -C /usr/bin/terraform terraform
fi
