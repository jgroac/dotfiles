#!/bin/bash

#Set Colors

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

# Headers and  Logging
ask() {
  printf "\n${bold}$@${reset}"
}

prompt_confirm() {
  while true; do
    read -p "" yn
    case $yn in
      [yY] )
        return 1;;
      [nN] )
        return 0;;
      * ) return 0;;
    esac
  done
}

to_header() {
  printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}
to_arrow() {
  printf "➜ $@\n"
}
to_success() {
  printf "${green}✔ %s${reset}\n" "$@"
}
to_error() {
  printf "${red}✖ %s${reset}\n" "$@"
}
to_warning() {
  printf "${tan}➜ %s${reset}\n" "$@"
}
to_underline() {
  printf "${underline}${bold}%s${reset}\n" "$@"
}
to_bold() {
  printf "${bold}%s${reset}\n" "$@"
}
to_note() {
  printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}
