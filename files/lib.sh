#!/bin/sh

bldred='\033[1;31m'
bldgrn='\033[1;32m'
bldblu='\033[1;34m'
bldylw='\033[1;33m' # Yellow
txtrst='\033[0m'

# Returns the absolute path of a given string
abspath () { case "$1" in /*)printf "%s\n" "$1";; *)printf "%s\n" "$PWD/$1";; esac; }

logit () {
  printf "%b\n" "$1" 
}


info () {
  printf "%b\n" "${bldblu}[INFO]${txtrst} $1" 
}

pass () {
  printf "%b\n" "${bldgrn}[PASS]${txtrst} $1" 
}

warn () {
  printf "%b\n" "${bldred}[WARN]${txtrst} $1" 
}

note () {
  printf "%b\n" "${bldylw}[NOTE]${txtrst} $1" 
}

yell () {
  printf "%b\n" "${bldylw}$1${txtrst}\n"
}

beginjson () {
  printf "{\n  \"citypay-scanner\": \"%s\",\n  \"start\": %s," "$1" "$2" | tee "$logger.json" 2>/dev/null 1>&2
}

endjson (){
  printf "\n  \"end\": %s \n}\n" "$1" | tee -a "$logger.json" 2>/dev/null 1>&2
}

logjson (){
  printf "\n  \"%s\": \"%s\"," "$1" "$2" | tee -a "$logger.json" 2>/dev/null 1>&2
}

integerjson (){
  printf "\n  \"%s\": %s," "$1" "$2" | tee -a "$logger.json" 2>/dev/null 1>&2
}

yell_info() {
yell "# ------------------------------------------------------------------------------
# CityPay Scanner v$version
#
# Checks for dozens of common best-practices around deploying Docker containers in production.
# Inspired by the CIS Docker Community Edition Benchmark v1.1
# ------------------------------------------------------------------------------"
}