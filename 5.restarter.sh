#!/usr/bin/env bash
#
# bash <(curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/5.restarter.sh)


init() {
  set -euo pipefail # strict mode
  #set -x            # uncomment when debugging your script
  IFS=$'\n\t'       # IFS restricted to newline and tab
}


main() {
  init # run init function

  # cd into server folder
  cd ~/azeroth-server

  # download scripts
  curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/restarter/auth.sh -O
  curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/restarter/restarter.sh -O
  curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/restarter/shutdown.sh -O
  curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/restarter/world.sh -O

  chmod +x ./restarter.sh
  chmod +x ./shutdown.sh
  chmod +x ./auth.sh
  chmod +x ./world.sh

  echo "Restarter scripts are now located in ./azeroth-server."
  echo "Run restarter.sh to start the full server."
  echo "Run shutdown.sh to--you guessed it--stop the server."
  echo "If you are running a world server on a different host from your auth,"
  echo "don't use restarter.sh. Instead, use auth.sh or world.sh depending on"
  echo "your application."
}


# make sure bash 4 is being used and run the script, exit otherwise
# this prevents people from running the script with an unsupported interpreter
if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]
then
  echo "This script requires Bash version 4 or newer."
  exit 1
else
  main
fi