mkdir -p InstallerPackage/Scripts
cp Installer/Install.sh InstallerPackage/Scripts/postinstall
mkdir InstallerPackage/Root
pkgbuild --root InstallerPackage/Root --scripts InstallerPackage/Scripts --identifier com.macbloxinstaller --version 1.0 --install-location /Applications Installer/Installer.pkg
rm -rf InstallerPackage
mkdir -p InstallerPackage/Scripts
cp Installer/Install_Testing.sh InstallerPackage/Scripts/postinstall
mkdir InstallerPackage/Root
pkgbuild --root InstallerPackage/Root --scripts InstallerPackage/Scripts --identifier com.macbloxinstaller --version 1.0 --install-location /Applications Installer/Installer_Testing.pkg
rm -rf InstallerPackage
rm -rf Macblox.dmg
appdmg installer.json Macblox.dmg