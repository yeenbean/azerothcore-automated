#!/usr/bin/env bash
#
# bash <(curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/4.db.sh)


init() {
  set -euo pipefail # strict mode
  #set -x            # uncomment when debugging your script
  IFS=$'\n\t'       # IFS restricted to newline and tab
}


main() {
  init # run init function

  
  # change directory to working
  cd ~/

  # download sql query file
  curl https://raw.githubusercontent.com/azerothcore/azerothcore-wotlk/master/data/sql/create/create_mysql.sql -O

  # execute sql query file
  sudo mysql < create_mysql.sql

  # duplicate distributed config files and allow user to configure
  cp -v azeroth-server/etc/authserver.conf.dist azeroth-server/etc/authserver.conf
  cp -v azeroth-server/etc/worldserver.conf.dist azeroth-server/etc/worldserver.conf

  # next steps
  dialog --msgbox "You now need to manually start authserver and worldserver together. This will create the database. Once this is created, shutdown both worldserver and authserver, login to the database using Keira3, and update the realmlist to point to this server's public IP address." 20 60
  clear
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