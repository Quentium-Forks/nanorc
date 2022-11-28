#!/bin/bash

_fetch_sources() {
  # check for unzip before we continue
  if [ ! "$(command -v unzip)" ]; then
    echo 'unzip is required but was not found. Install unzip first and then run this script again.' >&2
    exit 1
  fi

  wget -qO /tmp/nanorc.zip https://github.com/Quentium-Forks/nanorc/archive/main.zip
  mkdir -p ~/.nano/

  cd ~/.nano/ || exit
  unzip -qo /tmp/nanorc.zip
  mv nanorc-main/* ./
  rm -rf nanorc-main
  rm /tmp/nanorc.zip
}

_update_nanorc() {
  cat nanorc > "$NANORC_FILE"

  for file in *.nanorc; do
    cp "$file" ~/.nano/
    if ! grep -q "$file" "${NANORC_FILE}"; then
      echo "include \"~/.nano/$file\"" >> "$NANORC_FILE"
    fi
  done
}

_update_nanorc_lite() {
  sed -i '/include "\/usr\/share\/nano\/\*\.nanorc"/i include "~\/.nano\/*.nanorc"' "${NANORC_FILE}"
}

NANORC_FILE=~/.nanorc

case "$1" in
-l | --lite)
  UPDATE_LITE=1
  ;;
-h | --help)
  echo "Install script for nanorc syntax highlights"
  echo "Call with -l or --lite to update .nanorc with secondary precedence to existing .nanorc includes"
  exit 0
  ;;
esac

if [ $UPDATE_LITE ]; then
  _update_nanorc_lite
else
  _fetch_sources
  _update_nanorc
fi
