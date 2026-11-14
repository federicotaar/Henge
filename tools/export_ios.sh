#!/bin/zsh
# Makes a folder Henge on iOS can bring in: drop it on Henge in Finder (the
# iPhone's Files section) or pick it in the Files app.
#   tools/export_ios.sh DISK AUX ECID [NAME] [RAM_MB] [OUTDIR]
# The disk goes in packed (disk.img.hvsparse: holes left out) so that 64 GB of
# mostly empty image moves as what it actually holds. Reads the disk; writes nothing to it.
set -e
DISK=$1; AUX=$2; ECID=$3; NAME=${4:-Mac}; RAM=${5:-2048}; OUT=${6:-$HOME/Desktop/$NAME}
[ -f "$DISK" ] && [ -f "$AUX" ] && [ -n "$ECID" ] || { echo "usage: $0 DISK AUX ECID [NAME] [RAM_MB] [OUTDIR]" >&2; exit 2; }
# ECID and RAM go into machine.json unquoted: reject anything non-numeric up front
# instead of packing a folder whose manifest is not valid JSON
case $ECID in (*[!0-9]*) echo "ECID must be a decimal number (the device's ECID, e.g. from ideviceinfo)" >&2; exit 2;; esac
case $RAM in (*[!0-9]*) echo "RAM_MB must be a number of megabytes (e.g. 2048)" >&2; exit 2;; esac
HERE="$(cd "$(dirname "$0")/.." && pwd)"
make -C "$HERE" build/hvsparse >/dev/null
mkdir -p "$OUT"
cp /System/Library/Frameworks/Virtualization.framework/Resources/AVPBooter.vmapple2.bin "$OUT/"
cp "$AUX" "$OUT/auxiliary.bin"
echo "packing the disk (only its data moves)..."
"$HERE/build/hvsparse" pack "$DISK" "$OUT/disk.img.hvsparse"
cat > "$OUT/machine.json" <<JSON
{"name": "$NAME", "ecid": $ECID, "seed": 12345, "ramMB": $RAM}
JSON
echo "$OUT: $(du -sh "$OUT" | cut -f1)"
