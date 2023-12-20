#!/bin/bash

_fetch_repo() {
  # check for unzip before we continue
  if [ ! "$(command -v unzip)" ]; then
    echo 'unzip is required but was not found. Install unzip first and then run this script again.' >&2
    exit 1
  fi

  wget -qO /tmp/nanorc.zip https://github.com/Quentium-Forks/nanorc/archive/main.zip
  mkdir -p ~/.nano/

  cd ~/.nano/
  unzip -qo /tmp/nanorc.zip
  mv nanorc-main/* ./

  rm -rf nanorc-main/
  rm /tmp/nanorc.zip
}

_move_sources() {
  mkdir -p ~/.nano/

  cp -f *.nanorc ~/.nano/
}

_reset_nanorc() {
  cat nanorc > "$NANORC_FILE"
  echo "" >> "$NANORC_FILE"

  for file in *.nanorc; do
    if ! grep -q "$file" "${NANORC_FILE}"; then
      echo "include \"~/.nano/$file\"" >> "$NANORC_FILE"
    fi
  done
}

_update_nanorc_path() {
  sed -i '/include "\/usr\/share\/nano\/\*\.nanorc"/i include "~\/.nano\/*.nanorc"' "${NANORC_FILE}"
}

NANORC_FILE=~/.nanorc

case "$1" in
-p | --path)
  UPDATE_LITE=1
  ;;
-s | --sources)
  UPDATE_SOURCES=1
  ;;
-h | --help)
  echo "Install script for nanorc syntax highlights"
  echo "Call with -p or --path to update the path of .nanorc files with secondary precedence to existing .nanorc includes"
  echo "Call with -s or --sources to update .nanorc files with local sources from this repository"
  exit 0
  ;;
esac

if [ $UPDATE_LITE ]; then
  _update_nanorc_path
elif [ $UPDATE_SOURCES ]; then
  _move_sources
  _reset_nanorc
else
  _fetch_repo
  _reset_nanorc
fi
