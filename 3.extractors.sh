#!/usr/bin/env bash
#
# WAIT!!! BEFORE YOU TRY TO RUN THIS SCRIPT!!!
# You MUST copy the Data directory from the WotLK game directory to your $HOME
# directory.
#
# bash <(curl -s https://raw.githubusercontent.com/yeenbean/azerothcore-automated/main/3.extractors.sh)


init() {
  set -euo pipefail # strict mode
  #set -x            # uncomment when debugging your script
  IFS=$'\n\t'       # IFS restricted to newline and tab
}


main() {
  init # run init function


  # cd to our expected directory
  cd ~/


  # check that Data directory exists
  if [ -d "$HOME/Data" ]
  then
    echo "Data directory found."
  else
    echo "Error: Data directory not found in your home directory."
    echo "Please copy it over before proceeding."
    exit -1
  fi


  # copy over binaries for extractors
  cp -v ~/azeroth-server/bin/map_extractor ~/map_extractor
  cp -v ~/azeroth-server/bin/mmaps_generator ~/mmaps_generator
  cp -v ~/azeroth-server/bin/vmap4_assembler ~/vmap4_assembler
  cp -v ~/azeroth-server/bin/vmap4_extractor ~/vmap4_extractor


  # build DBC and Maps files
  ./map_extractor

  # build visual maps
  ./vmap4_extractor
  ./vmap4_assembler Buildings vmaps

  # build movement maps
  mkdir mmaps
  ./mmaps_generator


  # move everything to the build directory
  mkdir -v ~/azeroth-server/
  mv -v ./dbc ~/azeroth-server/
  mv -v ./maps ~/azeroth-server/
  mv -v ./vmaps ~/azeroth-server/
  mv -v ./mmaps ~/azeroth-server/


  # delete binaries
  rm -v ~/map_extractor
  rm -v ~/mmaps_generator
  rm -v ~/vmap4_assembler
  rm -v ~/vmap4_extractor
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