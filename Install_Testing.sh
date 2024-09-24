#!/bin/zsh

# Really cool installer which does stuff for macblox
# im not 100% sure if this works

: '

    TODO:
        Maybe add a arg for the install.sh that lets use input a password instead of asking it twice
        Also maybe turn this into obj-c++ and c++ installer

'

killall bootstrap
killall play
killall GameWatcher
killall Macblox

# soon add a file
# cuz we are just assuming the version to be the latest
latest_version=$(curl -s "https://api.github.com/repos/SomeRandomGuy45/MacBlox/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
current_user=$(whoami)

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    TYPE="x64"
elif [ "$ARCH" = "arm64" ]; then
    TYPE="arm"
else
    echo "Unknown architecture: $ARCH"
    exit 1
fi

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
#create_loading_dialog
cd /Users/$current_user
echo "$PASSWORD" | sudo -S rm -rf Macblox_Build
echo "$PASSWORD" | sudo -S rm -rf Macblox_Build.zip
echo "[INFO] Building MacBlox"
# Download the repository as a ZIP file
curl -L -o Macblox_Build.zip https://github.com/SomeRandomGuy45/Macblox_Build/archive/refs/heads/main.zip
# Unzip the downloaded ZIP file
unzip Macblox_Build.zip
# Move into the extracted directory (it'll be named "Macblox_Build-main")
cd Macblox_Build-main
cd "Macblox_${TYPE}"
echo "$PASSWORD" | sudo -S chmod +x "Play.app/Contents/MacOS/play"
echo "$PASSWORD" | sudo -S chmod +x "Play.app/Contents/Resources/Discord"
echo "$PASSWORD" | sudo -S chmod +x "Play.app/Contents/MacOS/Bootstrap.app/Contents/MacOS/bootstrap"
echo "$PASSWORD" | sudo -S chmod +x "Play.app/Contents/MacOS/Bootstrap.app/Contents/Resources/helper.sh"
echo "$PASSWORD" | sudo -S chmod +x "Play.app/Contents/MacOS/GameWatcher.app/Contents/MacOS/GameWatcher"
echo "$PASSWORD" | sudo -S chmod +x "Macblox.app/Contents/MacOS/Macblox"
echo "$PASSWORD" | sudo -S chmod +x "Open Roblox.app/Contents/MacOS/openRoblox"
cd ..
mkdir -p "/Users/$current_user/Library/Application Support/Macblox_Installer_Data"

cat <<EOF > /Users/$current_user/Library/Application\ Support/Macblox_Installer_Data/config.json
{
   "version" : "${latest_version}",
   "branch" : "main"
}
EOF

echo "[INFO] Finshed building MacBlox"
echo "$PASSWORD" | sudo -S mkdir /Applications/Macblox
#should copy the items not the folder it self
echo "$PASSWORD" | sudo -S mv "Macblox_${TYPE}"/* /Applications/Macblox
sleep 1
#close_loading_dialog
