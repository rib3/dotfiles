[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

shopt -s histappend

__reboot_required_ps1 () {
  [[ -e /var/run/reboot-required ]] && {
    echo "REBOOT:"
  }
}

# fallback in case git completion doesn't get loaded
__git_ps1 () {
  :
}

# avoid command not found package suggestions
unset command_not_found_handle

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

if hash brew 2> /dev/null; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# Git autocomplete for `g` also
complete -o default -o nospace -F _git g

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

export PROMPT_DIRTRIM="3" # Trim dirs printed by PS1's "\w"

#export PS1="\h:\W \u\$(__git_ps1)$ "
export PS1="\$(__reboot_required_ps1)\w\$(__git_ps1)$ "
if [ ! -z "${SSH_CLIENT}" ]; then
  export PS1="\h:${PS1}"
fi
