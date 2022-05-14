#!/bin/bash
mkdir -p ~/platformio_packages
for d in */ ; do
    cd "$d"
    simavr_tar="simavr.tar.gz"
    simavr_zip="simavr.zip"
    simavr_extracted="simavr"
    echo "Testing $d"
    ls
    mv *.zip simavr.zip
    if test -f "$simavr_tar"; then
        echo "tar gz files existed"
        tar xfv "$simavr_tar" --one-top-level
    elif test -f "$simavr_zip"; then
        echo "zip file existed"
        unzip $simavr_zip -d $simavr_extracted
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
        ("Linux 64-bit") echo "\"linux_x86_64\"";;
        ("Linux 32-bit") echo "\"linux_x86\"";;
        ("Windows 64-bit") echo "\"windows_amd64\"";;
        ("Windows 32-bit") echo "\"windows_x86\"";;
        ("Mac OS Intel 64-bit") echo "\"darwin_x86_64\", \"darwin_arm64\"";;
        ("Linux AArch64") echo "\"linux_aarch64\"";;
        ("Linux ARMv6l") echo "\"linux_armv6l\"";;
        ("Linux ARMv7l") echo "\"linux_armv7l\",\"linux_armv8l\"";;
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
    $system
  ],
  "repository": {
    "type": "git",
    "url": "https://github.com/buserror/simavr"
  }
}
EOF
    #~/.platformio/penv/bin/platformio package pack -o ~/platformio_packages "$simavr_extracted"
    pio package pack -o ~/platformio_packages "$simavr_extracted"
    cd ..
done
cd ~
ls -lh platformio_packages
pwd
