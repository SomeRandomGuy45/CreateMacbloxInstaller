mkdir -p ~/Desktop/InstallerPackage/Scripts
cp ~/Desktop/Installer/Install.sh ~/Desktop/InstallerPackage/Scripts/postinstall
mkdir ~/Desktop/InstallerPackage/Root
pkgbuild --root ~/Desktop/InstallerPackage/Root --scripts ~/Desktop/InstallerPackage/Scripts --identifier com.macbloxinstaller --version 1.0 --install-location /Applications ~/Desktop/Installer/Installer.pkg
rm -rf ~/Desktop/InstallerPackage
mkdir -p ~/Desktop/InstallerPackage/Scripts
cp ~/Desktop/Installer/Install_Testing.sh ~/Desktop/InstallerPackage/Scripts/postinstall
mkdir ~/Desktop/InstallerPackage/Root
pkgbuild --root ~/Desktop/InstallerPackage/Root --scripts ~/Desktop/InstallerPackage/Scripts --identifier com.macbloxinstaller --version 1.0 --install-location /Applications ~/Desktop/Installer/Installer_Testing.pkg
rm -rf ~/Desktop/InstallerPackage
rm -rf Macblox.dmg
appdmg installer.json Macblox.dmg