#!/bin/bash

## To check input is empty or not
is_empty() {
  if [ $# -eq  0 ];then
    return 1;;
  fi
    return 0;;
}

## Check if app installed
isInstalled() {
  local appNameOrBundleId=$1 isAppName=0 bundleId
  # Determine whether an app *name* or *bundle ID* was specified.
  [[ $appNameOrBundleId =~ \.[aA][pP][pP]$ || $appNameOrBundleId =~ ^[^.]+$ ]] && isAppName=1
  if (( isAppName )); then # an application NAME was specified
    # Translate to a bundle ID first.
    bundleId=$(osascript -e "id of application \"$appNameOrBundleId\"" 2>/dev/null) ||
      { echo "$FUNCNAME: ERROR: Application with specified name not found: $appNameOrBundleId" 1>&2; return 1; }
  else # a BUNDLE ID was specified
    bundleId=$appNameOrBundleId
  fi
    # Let AppleScript determine the full bundle path.
  fullPath=$(osascript -e "tell application \"Finder\" to POSIX path of (get application file id \"$bundleId\" as alias)" 2>/dev/null ||
    { echo "$FUNCNAME: ERROR: Application with specified bundle ID not found: $bundleId" 1>&2; return 1; })
  printf '%s\n' "$fullPath"
  # Warn about /Volumes/... paths, because applications launched from mounted
  # devices aren't persistently installed.
  if [[ $fullPath == /Volumes/* ]]; then
    echo "NOTE: Application is not persistently installed, due to being located on a mounted volume." >&2
  fi
}

