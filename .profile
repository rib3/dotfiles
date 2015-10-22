source ~/bin/utils.sh

# Mega command history...
HISTSIZE=100000

# Yeah...
export HOMEBREW_NO_EMOJI=1

alias g='git'

function oncd {
  echo oncd "${PWD}"
  PROJECT=$(echo "${PWD}" | sed -E "s/(.*workspace\/([^/]*))?.*/\2/")
  echo "PROJECT: '${PROJECT}'"
  if [ ! -z "${PROJECT}" ]; then
    echo title "${PROJECT}"
    title "${PROJECT}"
  fi
}

function cd () { builtin cd "$@" && oncd; }
