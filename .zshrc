# general options
setopt INTERACTIVE_COMMENTS  # allow comments in terminal
setopt MAGIC_EQUAL_SUBST     # enable filename expansion for arguments of the form `anything=expression`
setopt NOTIFY                # report the status of background jobs immediately
setopt NUMERIC_GLOB_SORT     # sort filenames numerically when it makes sense
unsetopt LIST_BEEP           # disable bell on completion

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
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit
zstyle ':completion:*:*:*:*:*' menu select               # allow completion selection using arrow keys
zstyle ':completion:*' format 'Completing %d'            # add completion infomation to suggestions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colorize completion
zstyle ':completion:*' group-name ''                     # ungroup completion results

# prompt
autoload -Uz promptinit && promptinit && prompt adam1

# keybinds
bindkey -e
bindkey "^[[1;5C" forward-word   # ctrl + ->
bindkey "^[[1;5D" backward-word  # ctrl + <-

# general aliases
alias lsa="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias mkcd='() { mkdir -p $1 && cd $1 }'
alias cdtemp='cd $(mktemp -d)'

# color aliases
alias ls="ls --color=auto"
alias grep="grep --color"
alias egrep="egrep --color"
alias fgrep="fgrep --color"
alias rgrep="rgrep --color"
alias diff="diff --color"
alias ip="ip --color=auto"


# #################################
# ## Tool specific configuration ##
# #################################

# git
if [[ $(command -v git) == /* ]]; then
	alias ga="git add"
	alias gc="git commit"
	alias gstat="git status"
	alias gl="git log"
	alias glg="git log --graph"
	alias glga="git log --graph --all"
fi

# docker
if [[ $(command -v docker) == /* ]]; then
	alias dr="docker run"
	alias dstr="docker start"
	alias dstp="docker stop"
	alias da="docker attach"
	alias dexe="docker exec"
	alias dps="docker ps"
	alias dpsa="docker ps -a"
	alias dl="docker logs"
	alias dlf="docker logs -f"
	alias drm="docker rm"
	alias drmf="docker rm -f"

	alias dconprune="docker contaier prune"

	alias dimg="docker image"
	alias dimgls="docker image ls"
	alias dimgprn="docker image prune"
	
	alias dvol="docker volume"
	alias dvolls="docker volume ls"
	alias dvolc="docker volume create"
	alias dvoli="docker volume inspect"
	alias dvolrm="docker volume rm"
	alias dvolp="docker volume prune"
	
	alias dnet="docker network"
	alias dnetls="docker network ls"
	alias dnetc="docker network create"
	alias dneti="docker network inspect"
	alias dnetrm="docker network rm"
	alias dnetp="docker network prune"

	alias dc="docker compose"
	alias dcu="docker compose up"
	alias dcud="docker compose up -d"
	alias dcd="docker compose down"
	alias dcr="docker compose restart"
	alias dcps="docker compose ps"
	alias dcpsa="docker compose ps -a"
	alias dcls="docker compose ls"
	alias dcl="docker compose logs"
	alias dclf="docker compose logs -f"
	alias dcp="docker compose pull"
	alias dcstat="docker compose stats"

	alias drmall='docker ps -qa | xargs docker rm'
	alias drmallf='docker ps -qa | xargs docker rm -f'
	alias dimgrmall='docker image ls -q | xargs docker image rm'
	alias dimgrmallf='docker image ls -q | xargs docker image rm -f'
fi

# k8s
if [[ $(command -v kubectl) == /* ]]; then
	_complete_kubectl() {
		unfunction $0
		source <(kubectl completion zsh)
	}
	compdef _complete_kubectl kubectl

	alias kg="kubectl get"
	alias kd="kubectl describe"
	alias kl="kubectl logs"
	alias klf="kubectl logs -f"
	alias kc="kubectl create"
	alias ka="kubectl apply"
	alias ke="kubectl edit"
  alias kpf="kubectl port-forward"
	alias kexe="kubectl exec"
	alias katt="kubectl attach"
	alias kdel="kubectl delete"
	alias kdbg="kubectl debug"
	alias kconf="kubectl config"

  alias kconfuse="kubectl config use-context"
  alias kconfcurr="kubectl config current-context"
	alias kconfns="kubectl config set-context --current --namespace"
	alias kgsd="kubectl get secrets -o jsonpath='{.data}'"
	alias kgsdd='() { kubectl get secrets $1 --output jsonpath="{.data.$2}" | base64 --decode && echo }'
	alias kgeverything='kubectl get $(kubectl api-resources --verbs=list -o name | tr "\n" "," | sed "s/,$//")'
	alias kgeverythingnamespaced='kubectl get $(kubectl api-resources --namespaced --verbs=list -o name | tr "\n" "," | sed "s/,$//")'
fi

# helm
if [[ $(command -v helm) == /* ]]; then
	_complete_helm() {
		unfunction $0
		source <(helm completion zsh)
	}
	compdef _complete_helm helm

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
	_complete_minikube() {
		unfunction $0
		source <(minikube completion zsh)
	}
	compdef _complete_minikube minikube

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

# kind
if [[ $(command -v kind) == /* ]]; then
	__complete_kind() {
		unfunction $0
		source <(kind completion zsh)
	}
	compdef __complete_kind kind
fi

# talos
if [[ $(command -v talosctl) == /* ]]; then
	_complete_talosctl() {
		unfunction $0
		source <(talosctl completion zsh)
	}
	compdef _complete_talosctl talosctl
fi

# terraform
if [[ $(command -v terraform) == /* ]]; then
	_complete_terraform() {
		unfunction $0
		complete -o nospace -C /usr/bin/terraform terraform
	}
	compdef _complete_terraform terraform
fi

# opentofu
if [[ $(command -v tofu) == /* ]]; then
	_complete_tofu() {
		unfunction $0
		complete -o nospace -C /usr/bin/tofu tofu
	}
	compdef _complete_tofu tofu
fi

# aws cli
if [[ $(command -v aws) == /* && $(command -v aws_completer) == /* ]]; then
	_complete_aws() {
		unfunction $0
		complete -C $(command -v aws_completer) aws
	}
	compdef _complete_aws aws
fi

# golang
if [[ -d "/usr/local/go" ]]; then
	export PATH=$PATH:"/usr/local/go/bin"

	export GOPATH="$HOME/go"
	export PATH=$PATH:"$GOPATH/bin"
fi

# rust
if [[ $(command -v rustup) == /* ]]; then
	_complete_rustup() {
		unfunction $0
		source <(rustup completions zsh)
	}
	compdef _complete_rustup rustup
fi

# tmux
if [[ $(command -v tmux) == /* ]]; then
	alias ta="tmux a"
	alias tls="tmux ls"
	alias tm="tmux"
fi

if [[ $(command -v gem) == /* ]]; then
  export GEM_HOME="$HOME/gems"
  export PATH="$PATH:$HOME/gems/bin"
fi
