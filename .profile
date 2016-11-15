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

alias g='git'
alias vi='vim'
alias l.='ls -d .*'
alias la='ls -a'
alias ld='lrt ~/Downloads'
alias lf='ls -FA'
alias ll='ls -lA'
alias lrs='ls -lrS'
alias lrt='ls -lrt'

# alias GNU find (defaults to cwd for path...)
if hash gfind; then
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
