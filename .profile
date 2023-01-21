PATH="${HOME}/.npm-user/bin:${PATH}" # .npmrc: prefix
PATH="/usr/local/sbin:${PATH}"
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"       # brew coreutils "prefixless"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}" # "
export GOPATH="${HOME}/.gopath"
PATH="${GOPATH}/bin:${PATH}"
PATH="${HOME}/.cargo/bin:${PATH}" # rust
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" # This loads nvm
export PYENV_ROOT="${HOME}/.pyenv"
PATH="${PYENV_ROOT}/bin:${PATH}"
PATH="${HOME}/.local/bin:${PATH}" # pip --user
PATH="${HOME}/bin:${PATH}" # keep as last PATH tweak

HISTSIZE=100000 # Mega command history...
HISTFILESIZE="${HISTSIZE}" # do need to set this?

export EDITOR='vim' # avoid git interaction issue with vim's vi mode
export PIP_REQUIRE_VIRTUALENV="true"
export PYTHONDONTWRITEBYTECODE=1
export HOMEBREW_NO_EMOJI=1

if hash ag 2>/dev/null; then
  # ag uses .gitignore
  export FZF_DEFAULT_COMMAND='ag -g ""'
fi

if hash rg 2>/dev/null; then
  # rg better at using .gitignore
  export FZF_DEFAULT_COMMAND='rg --color never --files'
fi

setup_ssh_agent () {
  local SHARED_SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
  if [ -z "${SSH_AUTH_SOCK}" \
    -a -S "${SHARED_SSH_AUTH_SOCK}" ]; then
    export SSH_AUTH_SOCK="${SHARED_SSH_AUTH_SOCK}"
  fi
  ssh-add -l > /dev/null 2>&1 # test agent functionality
  if [ "${?}" -ne 2 ]; then # 2 means unable to contact agent
    return # existing agent is working
  fi
  if hash ssh-agent 2>/dev/null; then
    eval `ssh-agent`
    if [ -d $(dirname "${SHARED_SSH_AUTH_SOCK}") ]; then
      ln -sf "${SSH_AUTH_SOCK}" "${SHARED_SSH_AUTH_SOCK}" \
        && export SSH_AUTH_SOCK="${SHARED_SSH_AUTH_SOCK}"
    fi
  fi
}

setup_ssh_agent

alias g='git'
alias l.='ls -d .*'
alias la='ls -a'
alias ld='lrt ~/Downloads'
alias lf='ls -FA'
alias ll='ls -lA'
alias lrs='ls -lrS'
alias lrt='ls -lrt'
alias vi='vim'
alias vea='source venv/bin/activate'
alias ved='deactivate'

# alias GNU find (defaults to cwd for path...)
if hash gfind 2>/dev/null; then
  alias find=gfind
fi

if hash dircolors 2>/dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -F --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
fi

# GNU and macOS (BSD) *grep both support color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias s3-cli='$(which node) --max_old_space_size=4096 $(which s3-cli)'

function tp {
  WRAPPER_BIN="${HOME}/.tmuxp/${1}"
  if [ -x "${WRAPPER_BIN}" ]; then
    "${WRAPPER_BIN}" "${@:2}"
  else
    tmuxp load "${@}"
  fi
}

function ws {
  tp "${@}" || {
    echo "activating tmux manually"
    WS_DIR="${1}"
    if [ ! -d "${WS_DIR}" ]; then
        WS_DIR="${HOME}/workspace/${WS_DIR}"
    fi
    # subshell to retain working directory
    (cd "${WS_DIR}" && exec tmux new-session -As "${1}")
  }
}

function mkdcd {
  DIR=`date -I`
  if [ -n "${1}" ]; then
    DIR="${DIR}.${1// /_}"
  fi
  mkdir "${DIR}" && cd "${DIR}" && pwd
}

[[ -s "$HOME/.profile.local" ]] && source "$HOME/.profile.local"
