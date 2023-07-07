#!/usr/bin/env bash
#
# bash <(curl -s url)


init() {
  set -euo pipefail # strict mode
  #set -x            # uncomment when debugging your script
  IFS=$'\n\t'       # IFS restricted to newline and tab
}


main() {
  init # run init function

  # make sure we are in home directory
  cd ~/

  # clone repository
  git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch azerothcore --depth 1

  # prep build directory
  cd azerothcore
  mkdir build
  cd build

  # configure build
  cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/azeroth-server/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static

  # build all the things
  make -j $(nproc --all)
  make install
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