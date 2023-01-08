#!/system/bin/sh
MODDIR="${0%/*}"
MODNAME="${MODDIR##*/}"

# API_VERSION = 1
STAGE="$1" # prepareEnterMntNs or EnterMntNs
PID="$2" # PID of app process
UID="$3" # UID oLbf app process
PROC="$4" # Process name. Example: com.google.android.gms.unstable
USERID="$5" # USER ID of app
# API_VERSION = 2
# Enable ash standalone
# Enviroment variables: MAGISKTMP, API_VERSION

TMPFILE="$MAGISKTMP/.magisk/modules/$MODNAME/module.prop"
. "$MODDIR/utils.sh"

RUN_SCRIPT(){
    if [ "$STAGE" == "prepareEnterMntNs" ]; then
        prepareEnterMntNs
    elif [ "$STAGE" == "EnterMntNs" ]; then
        EnterMntNs
    fi
}

prepareEnterMntNs(){
    # script run before enter the mount name space of app process

    if [ "$API_VERSION" -lt 2 ]; then
        # Need API 2 and newer
        exit 1
    fi

    if [ "$PROC" == "com.android.vending" ]; then
        // hack
        exit 0
    fi

    if [ "$PROC" == "$PACKAGE_NAME" ] || [ "$UID" -lt 10000 ] || [ "$PROC" == "com.android.systemui" ]; then
        touch "$MODDIR/loaded"
        STOCKAPPVER=$(dumpsys package $PACKAGE_NAME | grep versionName | cut -d= -f 2 | sed -n '1p')
        RVAPPVER=$(grep_prop version "$MODDIR/module.prop")
        check_version || exit 1
        exit 0
    fi

    #exit 0 # allow script to run in EnterMntNs stage
    exit 1 # close script and don't allow script to run in EnterMntNs stage
}


EnterMntNs(){
    # script run after enter the mount name space of app process and you allow this script to run in EnterMntNs stage

    if [ "$PROC" == "com.android.vending" ]; then
        . "$MODDIR/detachyt.sh"
        exit 1
    fi

    W=$(sed -E 's/^description=(\[.*][[:space:]]*)?/description=[ 😋 Dynamic mount is working. ] /g' "$MODDIR/module.prop")
    echo -n "$W" >"$TMPFILE"
    . "$MODDIR/mount.sh"
    exit 1
}

RUN_SCRIPT