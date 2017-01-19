[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

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
export PS1="\w\$(__git_ps1)$ "

if hash rbenv 2> /dev/null; then eval "$(rbenv init -)"; fi
