#!/bin/zsh

# Really cool installer which does stuff for macblox
# im not 100% sure if this works

: '

    TODO:
        Maybe add a arg for the install.sh that lets use input a password instead of asking it twice
        Also maybe turn this into obj-c++ and c++ installer

'

latest_commit=$(curl -s "https://api.github.com/repos/SomeRandomGuy45/MacBlox/commits/main" | grep '"sha"' | head -n 1 | sed -E 's/.*"([^"]+)".*/\1/')

# Function to create a loading dialog using osascript
create_loading_dialog() {
  osascript <<EOF
  tell application "System Events"
      set myDialog to display dialog "Installing" buttons {"Stop"} default button "Stop" giving up after 86400 -- 1 day timeout
  end tell
EOF
}

# Function to close the loading dialog
close_loading_dialog() {
  osascript <<EOF
  tell application "System Events" to keystroke return
EOF
}

PASSWORD=$(osascript -e 'Tell application "System Events" to display dialog "Enter your password:" default answer "" with hidden answer buttons {"OK"} default button "OK"' -e 'text returned of result')
create_loading_dialog
cd ~
echo "[INFO] Checking if Xcode Tools is installed"
#i forgot where i found this :((((
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "[INFO] Command Line Tools for Xcode not found. Installing from softwareupdate…"
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
else
  echo "[INFO] Command Line Tools for Xcode have been installed."
fi
echo "$PASSWORD" | sudo -S xcodebuild -license accept
echo "\n[INFO] Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/SomeRandomGuy45/brew_install/main/installer.sh)"
echo "[INFO] Install Required Libs"
brew install wxwidgets@3.2
brew install openssl
brew install lua
pip3 install --upgrade pip
pip3 install https://github.com/SomeRandomGuy45/pypresence/archive/master.zip
#git clone https://github.com/SomeRandomGuy45/discord_rpc.git
#echo "$PASSWORD" | sudo -S mv ~/discord_rpc/lib/libdiscord-rpc.a /usr/local/lib
#echo "$PASSWORD" | sudo -S mkdir /usr/local/include/discord-rpc
#echo "$PASSWORD" | sudo -S mv ~/discord_rpc/include/discord_register.h /usr/local/include/discord-rpc
#echo "$PASSWORD" | sudo -S mv ~/discord_rpc/include/discord_rpc.h /usr/local/include/discord-rpc
mkdir -p "~/Library/Application Support/Macblox_Installer_Data"

cat <<EOF > ~/Library/Application\ Support/Macblox_Installer_Data/config.json
{
   "version" : "${latest_version}",
   "branch" : "testing"
}
EOF

echo "$PASSWORD" | sudo -S rm -rf MacBlox
echo "[INFO] Building MacBlox"
git clone https://github.com/SomeRandomGuy45/MacBlox.git
cd MacBlox
make
echo "[INFO] Finshed building MacBlox"
echo "$PASSWORD" | sudo -S mv build/Macblox /Applications/
sleep 1
close_loading_dialog
