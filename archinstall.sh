#!/usr/bin/env bash
#
# to download the file:
# curl https://raw.githubusercontent.com/amerzak/arch/master/archinstall.sh >> archinstall.sh && chmod +x archinstall.sh
#

# begin
clear
echo -e "\033[32mMy arch installer!\033[0m"
pacman --noconfirm -Sy archlinux-keyring
#loadkeys fr
timedatectl set-ntp true
clear && lsblk
echo -e "\033[32mEnter device name (full path) : \033[0m"
read device
fdisk $device
echo -e "\033[32mNow! Mount and make file systems on partitions manually\033[0m"
sed '1,/^#install$/d' $0 > archinstallation.sh
chmod +x archinstallation.sh
# change to to where you automate the mkfss and mount
# ./archinsrallation.sh
exit

#install
clear
echo -e "\033[32mMount point of system partition (full path):\033[0m"
read syspart
pacstrap $syspart base base-devel linux linux-firmware grub vim git stow
genfstab -U $syspart >> $syspart/etc/fstab

sed '1,/^#config$/d' $0 > $syspart/archconfig.sh
chmod +x $syspart/archconfig.sh
arch-chroot $syspart ./archconfig.sh
exit

#config
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
echo -e "\033[32mHostname? : \033[0m"
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -P
passwd
clear
lsblk
echo -e "\033[32mInstalling grub on, device (full path) : \033[0m"
read device
grub-install $device
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\033[32mInstalling some necessary programs ... \033[0m"
pacman -S --noconfirm pulseaudio pulseaudio-alsa alsa-utils networkmanager firefox pamixer vim vi xorg-server xorg-xinit unzip zsh dash
systemctl enable NetworkManager
systemctl start NetworkManager

echo -e "\033[32mUsername? : \033[0m"
read user
export user=$user
useradd -m -G wheel -s /bin/zsh $user
passwd $user
visudo

sed '1,/^#setupuser$/d' $0 > archsetup.sh
#chmod +x archsetup.sh
asetup_path=/home/$user/archsetup.sh
chown $username:$user $asetup_path
chmod +x $asetup_path
su -c $asetup_path -s /bin/sh $user
exit 

#setupuser
ping -q -c 3 example.org > /dev/null || echo -e "\033[31mNo Internet!!\033[0m"
su -c 'cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si PKGBUILD' $user
echo -e "\033[34mDone!\033[0m"
echo -e "\033[34mReboot now\033[0m"
