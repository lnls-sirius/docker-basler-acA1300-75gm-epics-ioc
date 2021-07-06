#!/bin/bash

# Variables telling us where to get things
HERE="$(dirname "$0")"
VERSION="ffmpeg-4.0.2"
SOURCE="https://ffmpeg.org/releases/${VERSION}.tar.xz"
YASM="http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz"

# fail if we can't do anything
set -e

# remove ffmpeg things in vendor dir
rm -rf ${HERE}/vendor/ffmpeg*
rm -rf ${HERE}/vendor/yasm*

# Now get the the zip files
for z in $SOURCE $YASM; do
	wget -P "${HERE}/vendor" $z
done

# untar the source
echo "Untarring source..."
tar Jxvf "${HERE}/vendor/$(basename $SOURCE)" -C "${HERE}/vendor"

# untar yasm
echo "Untarring yasm..."
tar xzf "${HERE}/vendor/$(basename $YASM)" -C "${HERE}/vendor"

# remove the archives
for z in $SOURCE $YASM; do
	rm "${HERE}/vendor/$(basename $z)"
done

# move the untarred archives to the correct names
mv "${HERE}/vendor/${VERSION}" "${HERE}/vendor/ffmpeg"
mv ${HERE}/vendor/yasm* "${HERE}/vendor/yasm"

# patch win32 #defines for VC2003 compiler
# patch -d "${HERE}" -p0 < "${HERE}/vendor/vc2003.patch"

# echo "You can now type make to build this module"