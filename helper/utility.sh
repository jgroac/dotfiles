#!/bin/bash

# Color Codes & Custom utilities
# Source: http://natelandau.com/bash-scripting-utilities/

## Fonts
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

## Colors
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

## To check input is empty or not
is_empty() {
if [ $# -eq  0 ]
  then
    return 1
fi
  return 0
}

## To check programs exit or not
is_exists() {
if [ $(type -P $1) ]; then
  return 1
fi
  return 0
}

## To check file exits or not
is_file_exists() {
if [ -f "$file" ]
then
	return 1
else
	return 0
fi
}

# Custom echo functions

ask() {
  printf "\n${bold}$@${reset}"
}

e_thanks() {
  printf "\n${bold}${purple}$@${reset}\n"
}

e_header() {
  printf "\n${underline}${bold}${green}%s${reset}\n" "$@"
}

e_arrow() {
  printf "\n ᐅ $@\n"
}

e_success() {
  printf "\n${green}✔ %s${reset}\n" "$@"
}

e_error() {
  printf "\n${red}✖ %s${reset}\n" "$@"
}

e_warning() {
  printf "\n${tan}ᐅ %s${reset}\n" "$@"
}

e_underline() {
  printf "\n${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
  printf "\n${bold}%s${reset}\n" "$@"
}

e_note() {
  printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

whichapp() {
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

## END
