# zsh options
setopt interactivecomments # allow comments in interactive shell
setopt histignorealldups   # pervent duplicates in history file
setopt sharehistory        # share history accross all shell sessions

# use emacs keybinds
bindkey -e

# command completion
autoload -Uz compinit && compinit
autoload -U bashcompinit && bashcompinit

# configure history
HISTFILE=1000             # max history entries
SAVEHIST=1000             # max history saved to file
HISTFILE="~/.zsh_history" # history file path

# configure word navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# configure general aliases
alias ls="ls --color=auto"
alias ll="ls -l"
alias lsa="ls -a"
alias lla="ls -la"
alias mkcd='() { mkdir $1 && cd $1 }'
alias cdtemp='cd $(mktemp -d)'

# configure ls colors
if [[ $(command -v dircolors) == /* ]]; then
	source <(dircolors)
fi

# enable starship
USE_STARSHIP=false
if [[ $USE_STARSHIP == true && $(command -v starship) == /* ]]; then
	eval "$(starship init zsh)"
else
	autoload -Uz promptinit
	promptinit
	prompt adam1
fi
unset USE_STARSHIP

# configure docker
if [[ $(command -v docker) == /* ]]; then
	alias d="docker"
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
	alias kdbg="kubectl debug"
	alias kconf="kubectl config"
fi

# configure helm
if [[ $(command -v helm) == /* ]]; then
	source <(helm completion zsh)

	alias h="helm"
	alias hi="helm install"
	alias hu="helm upgrade"
	alias hui="helm upgrade -i"
	alias hunin="helm uninstall"
	alias hls="helm list"
fi

# configure minikube
if [[ $(command -v minikube) == /* ]]; then
	source <(minikube completion zsh)

	alias m="minikube"
	alias mstr="minikube start"
	alias mstp="minikube stop"
	alias mdel="minikube delete"
	alias msvc="minikube service"
	alias msvcl="minikube service list"
	alias mtun="minikube tunnel"
	alias mimg="minikube image"
	alias mstat="minikube status"
	alias mdash="minikube dashboard"
fi

# configure terraform
if [[ $(command -v terraform) == /* ]]; then
	complete -o nospace -C /usr/bin/terraform terraform
fi

# configure opentofu
if [[ $(command -v tofu) == /* ]]; then
	complete -o nospace -C /usr/bin/tofu tofu
fi

# configure aws cli
if [[ $(command -v aws) == /* && $(command -v aws_completer) == /* ]]; then
	complete -C $(command -v aws_completer) aws
fi
