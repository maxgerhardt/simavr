#!/bin/bash

for d in */ ; do
    cd "$d"
    simavr_tar="simavr.tar.gz"
    simavr_zip="*.zip"
    simavr_extracted="simavr"
    if test -f "$simavr_tar"; then
        echo "tar gz files existed"
        tar xfv "$simavr_tar" --one-top-level
    elif test -f "$simavr_zip"; then
        echo "zip file existed"
        unzip $simavr_zip
    else
        echo "No archive existed"
        continue
    fi
    datecode=$(date "+%y%m%d")
    system="unknown"
    dir=${d::-1}
    echo "Deriving system type from $dir"
    system=$(
    case "$dir" in
        ("Linux 64-bit") echo "linux_x86_64";;
        ("Linux 32-bit") echo "linux_x86";;
        ("Windows 64-bit") echo "windows_amd64";;
        ("Windows 32-bit") echo "windows_x86";;
        (*) echo "Unknown system" && exit ;;
    esac)
    echo "The system type is $system"
    cat << EOF > $simavr_extracted/package.json
{
  "name": "tool-simavr",
  "version": "1.10700.$datecode",
  "description": "simavr is a lean, mean and hackable AVR simulator",
  "keywords": [
    "simulator",
    "avr",
    "microchip"
  ],
  "license": "GPL-3.0-or-later",
  "system": [
    "$system"
  ],
  "repository": {
    "type": "git",
    "url": "https://github.com/buserror/simavr"
  }
}
EOF
    pio package pack "$simavr_extracted"
    cd ..
done
