#!/bin/bash

# Clone this script in your ROM Repo using following commands.
# cd rom_repo
# curl https://raw.githubusercontent.com/LegacyServer/Scripts/master/script_build.sh > script_build.sh

# Some User's Details. Please fill it with your own details.

# Replace "legacy" with your own SSH Username in lowercase
username=erny

# Colors makes things beautiful
export TERM=xterm

    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    blu=$(tput setaf 4)             #  blue
    cya=$(tput setaf 6)             #  cyan
    txtrst=$(tput sgr0)             #  Reset

# Auto update script
wget https://github.com/ErnyTech/Scripts/raw/master/lineageos_build.sh -O lineageos_build.sh.new
md5sum=$(md5sum lineageos_build.sh)
newmd5sum=$(md5sum lineageos_build.sh.new)

if [ "$newmd5sum" -ne "$md5sum" ];
then
cat lineageos_build.sh.new > lineageos_build.sh
source lineageos_build.sh
exit
fi

# CCACHE UMMM!!! Cooks my builds fast

if [ "$use_ccache" = "yes" ];
then
echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/$username
prebuilts/misc/linux-x86/ccache/ccache -M 50G
fi

if [ "$use_ccache" = "clean" ];
then
export CCACHE_DIR=/home/ccache/$username
ccache -C
wait
echo -e ${grn}"CCACHE Cleared"${txtrst};
exit 0
fi

# Its Clean Time
if [ "$make_clean" = "yes" ];
then
make clean && make clobber
wait
echo -e ${cya}"OUT dir from your repo deleted"${txtrst};
exit '
fi

# Build ROM
. build/envsetup.sh
breakfast $device
brunch $device
