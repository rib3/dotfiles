PATH="/usr/local/sbin:${PATH}"

# homebrew installed gnu software
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# ~/bin first!
PATH="${HOME}/bin:$PATH"

# Mega command history...
HISTSIZE=100000

# Yeah...
export HOMEBREW_NO_EMOJI=1

setup_ssh_agent () {
  local SHARED_SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
  if [ -z "${SSH_AUTH_SOCK}" ]; then
    if [ -S "${SHARED_SSH_AUTH_SOCK}" ]; then
      export SSH_AUTH_SOCK="${SHARED_SSH_AUTH_SOCK}"
    fi
  fi
  if ssh-add -l 2>&1 | grep -v "onnection refused" > /dev/null; then
    return
  fi
  if hash ssh-agent 2>/dev/null; then
    eval `ssh-agent`
    ln -sf "${SSH_AUTH_SOCK}" "${SHARED_SSH_AUTH_SOCK}"
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

# alias GNU find (defaults to cwd for path...)
if hash gfind 2>/dev/null; then
  alias find=gfind
fi

# colors for (gnu) ls, dir, and *grep
if hash gdircolors 2>/dev/null; then
  test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
  alias ls='gls -F --color=auto'
  alias dir='gdir --color=auto'
  alias vdir='gvdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

function vg {
  vagrant ssh -c "cd /vagrant; $*"
}

alias s3-cli='$(which node) --max_old_space_size=4096 $(which s3-cli)'

[[ -s "$HOME/.profile.local" ]] && source "$HOME/.profile.local"
