# break if shell is not interactive
[[ ! -o interactive ]] && return

# general options
setopt INTERACTIVE_COMMENTS  # allow comments in terminal
setopt MAGIC_EQUAL_SUBST     # enable filename expansion for arguments of the form `anything=expression`
setopt NOTIFY                # report the status of background jobs immediately
setopt NUMERIC_GLOB_SORT     # sort filenames numerically when it makes sense
setopt GLOB_DOTS             # inlude hidden filed in glob
setopt AUTO_PUSHD            # automatically pushd on cd commands
unsetopt LIST_BEEP           # disable bell on completion

# history
setopt SHARE_HISTORY         # share history between sessions
setopt HIST_IGNORE_SPACE     # don't add commands prefixed with space to history
setopt HIST_IGNORE_ALL_DUPS  # ignore all duplicates in history
setopt HIST_VERIFY           # expand history before running comand `sudo !!` will be expended to `sudo <last command>` before executing it

HISTSIZE=1000                # history size
SAVEHIST=$HISTSIZE           # history size to be committed to history file
HISTFILE=$HOME/.zsh_history  # history file location

# ls colors
if [[ $(command -v dircolors) == /* ]]; then
    source <(dircolors)
fi

# completion
autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit
zstyle ':completion:*:*:*:*:*' menu select               # allow completion selection using arrow keys
zstyle ':completion:*' format 'Completing %d'            # add completion infomation to suggestions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colorize completion

# prompt
autoload -Uz promptinit && promptinit && prompt adam1

# keybinds
bindkey -e
bindkey "^[[1;5C" forward-word    # ctrl + ->
bindkey "^[[1;5D" backward-word   # ctrl + <-
bindkey "^[[1~" beginning-of-line # Home
bindkey "^[[4~" end-of-line       # End

# general aliases
alias lsa="ls -a"
alias l="ls -l"
alias ll="ls -la"
alias mkcd='() { mkdir -p $1 && cd $1 }'
alias cdtemp='cd $(mktemp -d)'
alias fda="fd --hidden"
alias diffy="diff --side-by-side"

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
    alias g="git"
    alias ga="git add"
    alias gb="git branch"
    alias gc="git commit"
fi

# docker
if [[ $(command -v docker) == /* ]]; then
    alias d="docker"
    alias db="docker build"
    alias dex="docker exec"
    alias dl="docker logs"
    alias dlf="docker logs --follow"
    alias dp="docker pull"
    alias dps="docker ps"
    alias dpsa="docker ps --all"
    alias dr="docker run"
    alias drm="docker rm"
    alias drmf="docker rm --force"
    alias dstp="docker stop"
    alias dstr="docker start"

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
    alias dcub="docker compose up --build"
    alias dcud="docker compose up --detach"
    alias dcudb="docker compose up --detach --build"

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
    alias kexpr="kubectl explain --recursive"
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
    alias h="helm"
    alias hg="helm get"
    alias hi="helm install"
    alias hls="helm list"
    alias hp="helm pull"
    alias hpu="helm pull --untar"
    alias hs="helm show"
    alias hstat="helm status"
    alias ht="helm template"
    alias htd="helm template --debug"
    alias hu="helm upgrade"
    alias hui="helm upgrade --install"
    alias hunin="helm uninstall"

    alias hrep="helm repo"
    alias hrepa="helm repo add"
    alias hrepls="helm repo list"
    alias hrepu="helm repo update"

    alias hsear="helm search"
    alias hsearh="helm search hub"
    alias hsearr="helm search repo"
fi

# minikube
if [[ $(command -v minikube) == /* ]]; then
    alias mdash="minikube dashboard"
    alias mdel="minikube delete"
    alias mstat="minikube status"
    alias mstp="minikube stop"
    alias mstr="minikube start"
    alias msvc="minikube service"
    alias msvcl="minikube service list"
    alias mtun="minikube tunnel"
fi

# aws cli
if [[ $(command -v aws) == /* && $(command -v aws_completer) == /* ]]; then
    _complete_aws() {
        unfunction $0
        complete -C $(command -v aws_completer) aws
        _complete $@
    }
    compdef _complete_aws aws
fi

# neovim
if [[ $(command -v nvim) == /* ]]; then
    export EDITOR="nvim"
fi

# tmux
if [[ $(command -v tmux) == /* ]]; then
    alias tm="[[ ! -v TMUX ]] && ( tmux ls &>/dev/null && tmux attach || tmux )"
fi

