while [ "$(resetprop sys.boot_completed)" != 1 ]; do
    sleep 1
done
sleep 1
MODDIR="${0%/*}"
MODNAME="${MODDIR##*/}"
sh "$MODPATH/detachyt.sh"
MAGISKTMP="$(magisk --path)" || MAGISKTMP=/sbin
TMPFILE="$MAGISKTMP/.magisk/modules/$MODNAME/module.prop"
. "$MODDIR/utils.sh"
[ -e "$MODDIR/loaded" ] || { check_version && . "$MODDIR/mount.sh"; } || exit 0

W=$(sed -E 's/^description=(\[.*][[:space:]]*)?/description=[ 😅 File is mounted globally because Dynamic mount is not working. ] /g' "$MODDIR/module.prop")
echo -n "$W" >"$TMPFILE"