#!/bin/bash
#
#
#
echo "█       ▄   █  █▀  ▄▄▄▄▄   ▄█▄    █▄▄▄▄ ▀▄    ▄ █ ▄▄     ▄▄▄▄▀ ▄███▄   █▄▄▄▄ " 
echo "█        █  █▄█   █     ▀▄ █▀ ▀▄  █  ▄▀   █  █  █   █ ▀▀▀ █    █▀   ▀  █  ▄▀ "
echo "█     █   █ █▀▄ ▄  ▀▀▀▀▄   █   ▀  █▀▀▌     ▀█   █▀▀▀      █    ██▄▄    █▀▀▌  "
echo "███▄  █   █ █  █ ▀▄▄▄▄▀    █▄  ▄▀ █  █     █    █        █     █▄   ▄▀ █  █  "
echo "    ▀ █▄ ▄█   █            ▀███▀    █    ▄▀      █      ▀      ▀███▀     █   "
echo "       ▀▀▀   ▀                     ▀              ▀                     ▀    "
echo "Automated LUKS Encryption"
echo
echo "Select correct volume for LUKS Encryption"

fdisk -l

echo "Wich is the VOLUME?"
read SEL_VOL 

echo "Wich is the future name for Luks VOLUME?"
read NAME_VOL

cryptsetup --verbose --verify-passphrase luksFormat /dev/$SEL_VOL

cryptsetup luksOpen /dev/$SEL_VOL NAME_VOL

mkfs.ext3 -L persistence /dev/mapper/$NAME_VOL

e2label /dev/mapper/$NAME_VOL persistence

mkdir -p /mnt/$NAME_VOL

mount /dev/mapper/$NAME_VOL /mnt/$NAME_VOL

echo "/ union" > /mnt/$NAME_VOL/persistence.conf

umount /dev/mapper/$NAME_VOL

cryptsetup luksClose /dev/mapper/$NAME_VOL

echo "Script TERMINATED..."

exit 0