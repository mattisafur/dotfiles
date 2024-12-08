# general options
setopt INTERACTIVE_COMMENTS  # allow comments in terminal
setopt MAGIC_EQUAL_SUBST     # enable filename expansion for arguments of the form `anything=expression`
setopt NOTIFY                # report the status of background jobs immediately
setopt NUMERIC_GLOB_SORT     # sort filenames numerically when it makes sense

# history
setopt SHARE_HISTORY           # share history between sessions
setopt HIST_IGNORE_SPACE       # don't add command prefixed with space to history
setopt HIST_IGNORE_ALL_DUPS    # ignore all duplicates in history
setopt HIST_VERIFY             # expand history before running comand `sudo !!` will be expended to `sudo <last command>` before executing it

HISTSIZE=1000                  # history size
SAVEHIST=$HISTSIZE             # history size to be committed to history file
HISTFILE=~/.history            # history file location

# ls colors
if [[ $(command -v dircolors) == "/*" ]]; then
	source "$(dircolors)"
fi

# completion
autoload -Uz compinit
compinit
zstyle ':completion:*:*:*:*:*' menu select               # allow completion selection using arrow keys
zstyle ':completion:*' format 'Completing %d'            # add completion infomation to suggestions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colorize completion
zstyle ':completion:*' group-name ''                     # ungroup completion results

# prompt
autoload -Uz promptinit && promptinit && prompt adam1

# keybinds
bindkey -e
bindkey "^[[1;5C" forward-word   # ctrl + ->
bindkey "^[[1;6D" backward-word  # ctrl + <-

# general aliases
alias ls="ls --color"
alias lsa="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias mkcd='() { mkdir $1 && cd $1 }'
alias cdtemp='cd $(mktemp -d)'


# #################################
# ## Tool specific configuration ##
# #################################

# docker
if [[ $(command -v docker) == /* ]]; then
	alias dr="docker run"
	alias da="docker attach"
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

# k8s
if [[ $(command -v kubectl) == /* ]]; then
	source <(kubectl completion zsh)

	alias kg="kubectl get"
	alias kd="kubectl describe"
	alias kl="kubectl logs"
	alias klf="kubectl logs -f"
	alias kc="kubectl create"
	alias ka="kubectl apply"
	alias kexe="kubectl exec"
	alias katt="kubectl attach"
	alias kdel="kubectl delete"
	alias kdbg="kubectl debug"
	alias kconf="kubectl config"
fi

# helm
if [[ $(command -v helm) == /* ]]; then
	source <(helm completion zsh)

	alias hi="helm install"
	alias hu="helm upgrade"
	alias hui="helm upgrade -i"
	alias hunin="helm uninstall"
	alias hs="helm show"
	alias hg="helm get"
	alias hls="helm list"
fi

# minikube
if [[ $(command -v minikube) == /* ]]; then
	source <(minikube completion zsh)

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

# terraform
if [[ $(command -v terraform) == /* ]]; then
	complete -o nospace -C /usr/bin/terraform terraform
fi

# opentofu
if [[ $(command -v tofu) == /* ]]; then
	complete -o nospace -C /usr/bin/tofu tofu
fi

# aws cli
if [[ $(command -v aws) == /* && $(command -v aws_completer) == /* ]]; then
	complete -C $(command -v aws_completer) aws
fi

# golang
if [[ -d "/usr/local/go" ]]; then
	export PATH=$PATH:"/usr/local/go/bin"
fi
