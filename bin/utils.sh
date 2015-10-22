die() {
  [ -n "$1" ] && echo "${1}"
  exit 1
}

escape() {
  echo "${1}" | sed "s/\W*//g"
}

title() {
  MODE="0" # 1 - tab, 2 - title, 0 - both
  echo -ne "\033]${MODE};${*}\007"
}
