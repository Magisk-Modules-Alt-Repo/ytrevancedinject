MODDIR="${0%/*}"
MODNAME="${MODDIR##*/}"
MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin

PROPFILE="$MAGISKTMP/.magisk/modules/$MODNAME/module.prop"
TMPFILE="$MAGISKTMP/revanced.prop"
cp -af "$MODDIR/module.prop" "$TMPFILE"

sed -Ei 's/^description=(\[.*][[:space:]]*)?/description=[ ⛔ Module is not working. ] /g' "$TMPFILE"
flock "$MODDIR/module.prop"

mount --bind "$TMPFILE" "$PROPFILE"

rm -rf "$MODDIR/loaded"
exit 0