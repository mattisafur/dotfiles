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
HISTFILE=~/.zsh_history            # history file location

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
alias l="ls -l"
alias ll="ls -la"
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
	alias d="docker"
	alias dex="docker exec"
	alias dl="docker logs"
	alias dlf="docker logs --follow"
	alias dp="docker pull"
	alias dps="docker ps"
	alias dpsa="docker ps --all"
	alias dr="docker run"
	alias drm="docker rm"
	alias drmf="docker rm --force"

	alias dc="docker compose"
	alias dcd="docker compose down"
	alias dcl="docker compose logs"
	alias dclf="docker compose logs --follow"
	alias dcls="docker compose ls"
	alias dcps="docker compose ps"
	alias dcpsa="docker compose ps --all"
	alias dcp="docker compose pull"
	alias dcr="docker compose restart"
	alias dcstp="docker compose stop"
	alias dcstr="docker compose start"
	alias dcu="docker compose up"
	alias dcud="docker compose up --detach"

	alias dcon="docker container"
	alias dconprn="docker container prune"

	alias dimg="docker image"
	alias dimgls="docker image ls"
	alias dimgprn="docker image prune"
	alias dimgprna="docker image prune --all"
	alias dimgrm="docker image rm"

	alias dnet="docker network"
	alias dnetls="docker network ls"
	alias dnetprn="docker network prune"
	alias dnetrm="docker network rm"

	alias dvol="docker volume"
	alias dvolls="docker volume ls"
	alias dvolprn="docker volume prune"
	alias dvolprna="docker volume prune --all"
	alias dvolrm="docker volume rm"
fi

# k8s
if [[ $(command -v kubectl) == /* ]]; then
	_complete_kubectl() {
		unfunction $0
		source <(kubectl completion zsh)
	}
	compdef _complete_kubectl kubectl

	alias k="kubectl"
	alias ka="kubectl apply"
	alias kc="kubectl create"
	alias kconf="kubectl config"
	alias kconfcurr="kubectl config current-context"
	alias kconfns="kubectl config set-context --current --namespace"
	alias kconfuse="kubectl config use-context"
	alias kd="kubectl describe"
	alias kdbg="kubectl debug"
	alias kdel="kubectl delete"
	alias ke="kubectl edit"
	alias kex="kubectl exec"
	alias kexp="kubectl explain"
	alias kg="kubectl get"
	alias kgeverything='kubectl get $(kubectl api-resources --verbs=list --output name | tr "\n" "," | sed "s/,$//")'
	alias kgeverythingnamespaced='kubectl get $(kubectl api-resources --verbs=list --output name --namespaced | tr "\n" "," | sed "s/,$//")'
	alias kgsd="kubectl get secrets --output jsonpath='{.data}'"
	alias kgsdd='() { kubectl get secrets $1 --output jsonpath=".data.$2" | base64 --decode && echo }'
	alias kl="kubectl logs"
	alias klf="kubectl logs --follow"
	alias kpf="kubectl port-forward"
fi

# helm
if [[ $(command -v helm) == /* ]]; then
	_complete_helm() {
		unfunction $0
		source <(helm completion zsh)
	}
	compdef _complete_helm helm

	alias h="helm"
	alias hg="helm get"
	alias hi="helm install"
	alias hls="helm list"
	alias hp="helm pull"
	alias hpu="helm pull --untar"
	alias hs="helm show"
	alias hstat="helm status"
	alias hu="helm upgrade"
	alias hui="helm upgrade --install"
	alias hunin="helm uninstall"

	alias hrep="helm repo"
	alias hrepa="helm repo add"
	alias hrepu="helm repo update"

	alias hsear="helm search"
	alias hsearh="helm search hub"
	alias hsearr="helm search repo"
fi

# minikube
if [[ $(command -v minikube) == /* ]]; then
	_complete_minikube() {
		unfunction $0
		source <(minikube completion zsh)
	}
	compdef _complete_minikube minikube

	alias mdash="minikube dashboard"
	alias mdel="minikube delete"
	alias mstat="minikube status"
	alias mstp="minikube stop"
	alias mstr="minikube start"
	alias msvc="minikube service"
	alias msvcl="minikube service list"
	alias mtun="minikube tunnel"
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

# ruby
if [[ $(command -v gem) == /* ]]; then
  export GEM_HOME="$HOME/gems"
  export PATH="$PATH:$HOME/gems/bin"
fi

# neovim
if [[ $(command -v nvim) == /* ]]; then
	export EDITOR="nvim"
fi

# tmux
if [[ $(command -v tmux) == /* ]]; then
	alias tm="[[ ! -v TMUX ]] && ( tmux ls &>/dev/null && tmux attach || tmux )"
fi

