#!/bin/sh

# quake3e mac update
# author. Diego Ulloa
# website: https://diegoulloa.dev/

set -e # exit on error

# Variables
declare -r BRANCH="master"

# Local dependencies
declare -r quake3e="https://github.com/mikekelly/quake3e-mac-install/raw/$BRANCH/dependencies/quake3e.zip"

# Versions files
declare -r latest_version_url="https://raw.githubusercontent.com/mikekelly/quake3e-mac-install/$BRANCH/version"
declare -r current_version_file_path=~/Library/Application\ Support/Quake3/version

# Escape if no version files is present
if ! [ -f "$current_version_file_path" ]; then
  echo "\nCould not found the version file on your system."
  exit 0
fi

# Get current quake3e version on the system
current_version=$(cat "$current_version_file_path")

# Fetch latest version from server
latest_version=$(curl $latest_version_url | sed '/^[[:space:]]*$/d')

# Escape if is already updated to lastest
if [ "$current_version" == "$latest_version" ]; then
  echo "\nquake3e is up to date :)"
  exit 0
fi

# Start installation
cd /Applications

# Download quake3e
echo "\n
**************************************************
  Downloading latest quake3e ...
**************************************************
\n"

curl -L $quake3e > quake3e.zip

echo "\n
++++++++++++++++++++++++++++++++++++++++++++++++++
  Updating current quake3e ...
++++++++++++++++++++++++++++++++++++++++++++++++++
\n"

unzip -a -o quake3e.zip
rm -f quake3e.zip

if [ -d __MACOSX  ]; then
  cd __MACOSX

  if [ -d quake3e ]; then
    rm -rf quake3e
    rm -rf ._quake3e
  fi

  cd ..

  if [ ! `ls -A __MACOSX` ]; then
    rm -rf __MACOSX
  fi
fi

# Update local version
echo $latest_version > "$current_version_file_path"

echo "\n\n-> quake3e successfully updated."
