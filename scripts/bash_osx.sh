#!/bin/sh

function die() {
   echo "$@"
   exit 1
}

brew update || die

brew install bash-completion || die

# At the end of the bash-completion install, it will print the lines you need to add to your .bash_profile.

# You *may* also need to upgrade to latest bash (OS X ships an old version.)

# brew install bash || die


#  --- add this to /etc/shells (need admin privileges)
#  /usr/local/bin/bash
#  ----END---

# Change your user shell to bash from brew

# chsh -s /usr/local/bin/bash || die

BASH_LOC="$(brew --prefix)/bin/bash"

echo << END
Last steps:
  Add $(brew --prefix)/bin/bash to /etc/shells
  Add $(brew --prefix)/bin/bash to /etc/shells
  Change your shell to $(brew --prefix)/bin/bash

END

brew info bash-completion
# 0

# echo "Everything setup, reopen any terminals."

# Make sure installed packages are up to date

brew upgrade

# Another nice thing is that any other commands installed via brew that come with their own completion libraries will automatically get updated to the bash-completion dir.
