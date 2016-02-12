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
