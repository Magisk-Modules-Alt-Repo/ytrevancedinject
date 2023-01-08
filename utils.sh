grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}

check_version(){
  STOCKAPPVER=$(dumpsys package $PACKAGE_NAME | grep versionName | cut -d= -f 2 | sed -n '1p')
  RVAPPVER=$(grep_prop version "$MODDIR/module.prop")
  if [ "$STOCKAPPVER" != "$RVAPPVER" ]; then
      W=$(sed -E 's/^description=(\[.*][[:space:]]*)?/description=[ ❌ The current version of YouTube does not match. ] /g' "$MODDIR/module.prop")
      echo -n "$W" >"$TMPFILE"
	  return 1
  fi
  return 0
}

PACKAGE_NAME=$(grep_prop package "$MODDIR/module.prop")