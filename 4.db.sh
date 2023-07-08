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

  # warn user of next steps
  dialog --msgbox "This script will now start the authserver and worldserver individually to populate the database. Once each server is started, stop it gracefully to continue the execution of the script." 20 60
  clear

  # change directory into the server root
  cd ~/azeroth-server

  # launch each server. the user is expected to manually shut them down after
  # db is generated.
  bin/authserver
  bin/worldserver

  # warn user of next steps
  dialog --msgbox "Databases should now be populated. If required, login to the database using HeidiSQL via SSH tunnel and set the realmlist IP to your external WAN address." 20 60
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