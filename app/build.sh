#!/usr/bin/env -S bash -e

SIDE=""

if [[ "$1" == "--left" ]]; then
  SIDE="left"
elif [[ "$1" == "--right" ]]; then
  SIDE="right"
else
  echo "Choose a side --left/--right. Aborting!"
  exit 1
fi

udisksctl mount -b /dev/sda
west build -d "build/${SIDE}" -p -b nice_nano_v2 -- -DSHIELD="splitkb_aurora_corne_${SIDE}" -DZMK_CONFIG=../../zmk-config/config/
cp "build/${SIDE}/zephyr/zmk.uf2" "/run/media/guif/NICENANO/" 

