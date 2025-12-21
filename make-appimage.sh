#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q librecad | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/librecad.png
export DESKTOP=/usr/share/applications/librecad.desktop

# fix massive screwed up from upstream
rm -f /usr/share/librecad/plugins/'*.so'

# Deploy dependencies
quick-sharun \
	/usr/bin/librecad \
	/usr/bin/ttf2lff  \
	/usr/lib/librecad \
	/usr/share/librecad

# The gtk3 plugin does not change the look of the app for some reason
# this bug also hapens when test the native distro package
rm -f ./AppDir/lib/qt/plugins/platformthemes/libqgtk3.so

# Turn AppDir into AppImage
quick-sharun --make-appimage
