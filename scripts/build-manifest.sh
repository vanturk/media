#!/bin/bash
# Rebuilds manifest.json from the files on disk. Run after adding or removing media:
#   bash scripts/build-manifest.sh
# Needs ffprobe (brew install ffmpeg).
set -euo pipefail
cd "$(dirname "$0")/.."
BASE="https://vanturk.github.io/media/"

# Image categories: any folder holding <shape>/*.webp. Listed in this order first, new ones after.
ORDER="dessert fruit interior-design oversize male female"
CATS=()
for c in $ORDER; do [ -d "$c" ] && CATS+=("$c"); done
for d in */; do
  c="${d%/}"
  case " $ORDER vids scripts " in *" $c "*) continue ;; esac
  compgen -G "$c/*/*.webp" > /dev/null && CATS+=("$c")
done
{
  echo "{"
  echo "  \"base\": \"$BASE\","
  echo "  \"images\": {"
  firstc=1
  for c in "${CATS[@]}"; do
    [ $firstc = 1 ] || echo ","; firstc=0
    printf '    "%s": {\n' "$c"
    firsts=1
    for s in cinema landscape portrait square; do
      [ -d "$c/$s" ] || continue
      [ $firsts = 1 ] || echo ","; firsts=0
      printf '      "%s": [' "$s"
      firstf=1
      for f in $(ls "$c/$s" | sort -n); do
        p="$c/$s/$f"
        wh=$(ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=s=,:p=0 "$p")
        [ $firstf = 1 ] || printf ','; firstf=0
        printf '\n        {"src": "%s", "width": %s, "height": %s}' "$p" "${wh%,*}" "${wh#*,}"
      done
      printf '\n      ]'
    done
    printf '\n    }'
  done
  echo ""
  echo "  },"
  echo "  \"videos\": {"
  firsts=1
  for s in landscape portrait square; do
    [ $firsts = 1 ] || echo ","; firsts=0
    printf '    "%s": [' "$s"
    firstf=1
    for n in $(ls vids/$s | sed 's/vid-//;s/.mp4//' | sort -n); do
      p="vids/$s/vid-$n.mp4"
      wh=$(ffprobe -v error -select_streams v -show_entries stream=width,height -of csv=s=,:p=0 "$p")
      d=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$p")
      a=$(ffprobe -v error -select_streams a -show_entries stream=codec_name -of csv=p=0 "$p")
      [ $firstf = 1 ] || printf ','; firstf=0
      printf '\n      {"src": "%s", "width": %s, "height": %s, "duration": %.1f, "audio": %s, "bytes": %s}' \
        "$p" "${wh%,*}" "${wh#*,}" "$d" "$([ -n "$a" ] && echo true || echo false)" "$(stat -f%z "$p")"
    done
    printf '\n    ]'
  done
  echo ""
  echo "  }"
  echo "}"
} > manifest.json
