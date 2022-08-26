#!/bin/bash
###############################################################################
# linux script recording & replay wrapper
# written by George Liu <https://centminmod.com>
###############################################################################
VER=0.1
CPUS=$(nproc)

if [ -f /usr/bin/yum ] && [[ ! -f /usr/bin/scriptreplay || ! -f /usr/bin/script ]]; then
  sudo yum -q -y install util-linux
elif [ -f /usr/bin/apt ] && [[ ! -f /usr/bin/scriptreplay || ! -f /usr/bin/script ]]; then
  sudo apt install util-linux
fi

if [[ -f /usr/local/bin/pigz && "$CPUS" -gt '1' ]]; then
  COMPRESSBIN='/usr/local/bin/pigz'
elif [[ -f /usr/bin/pigz && "$CPUS" -gt '1' ]]; then
  COMPRESSBIN='/usr/bin/pigz'
else
  COMPRESSBIN='/usr/bin/gzip'
fi

if [ -f /usr/bin/pzcat ]; then
  ZCATBIN='/usr/bin/pzcat'
elif [ -f /usr/bin/zcat ]; then
  ZCATBIN='/usr/bin/zcat'
fi

record() {
  SESSION_NAME="$1"
  FILEPREFIX="$HOME/.script/$(date '+%Y-%m-%d')/$(date '+%Y-%m-%d_%H-%M-%S')-${SESSION_NAME:-session}"
  mkdir -p $FILEPREFIX
  /usr/bin/script -t -f -q 2>"${FILEPREFIX}/time.txt" "${FILEPREFIX}/cmds"
  $COMPRESSBIN "${FILEPREFIX}/time.txt"
  $COMPRESSBIN "${FILEPREFIX}/cmds"
  echo -e "${FILEPREFIX}/cmds.gz\n${FILEPREFIX}/time.txt.gz\n"
}

replay() {
  CMD_FILE="$1"
  TIME_FILE="$2"
  SPEED="$3"
  if [[ -f "$CMD_FILE" && -f "$TIME_FILE" ]]; then
    if [ "$3" ]; then
      scriptreplay -t <("$ZCATBIN" "$TIME_FILE") <("$ZCATBIN" "$CMD_FILE") "$SPEED"
    else
      scriptreplay -t <("$ZCATBIN" "$TIME_FILE") <("$ZCATBIN" "$CMD_FILE")
    fi
  else
    echo
    echo "error: required file path(s) to cmds.gz or time.txt.gz do not exist"
    echo
    echo "existing files detected:"
    tree --charset utf8 --sort=ctime -n -f "$HOME/.script/"
    echo
    help
  fi
}

list_files() {
  echo "saved files listing:"
  echo
  tree --charset utf8 --sort=ctime -n -f "$HOME/.script/"
  echo
}

help() {
  echo
  echo "Usage:"
  echo
  echo "$0 rec SESSION_NAME"
  echo "$0 play /path/to/cmds.gz /path/to/time.txt.gz"
  echo "$0 play /path/to/cmds.gz /path/to/time.txt.gz 2"
  echo "$0 list"
  echo
}

case "$1" in
  rec )
    record "$2"
    ;;
  play )
    replay "$2" "$3" "$4"
    ;;
  list )
    list_files
    ;;
  * )
    help
    ;;
esac