#!/bin/bash
#variables for storing links and locations
file=packages/packagemanager.txt
#####################################################################################
#list function
list (){
	printf '\t\e[1;34m%-6s\e[m\n' "Welcome to easy setup script"

	if [[ -f "$file" ]]; then
		package=$(cat $file)
		printf '\t\e[1;31m%-6s\e[m\n' "Your package manager is : $(cat $file)"
	else
		packagemanager
		return 1
	fi
	printf '\t\e[1;33m%-6s\e[m\n' "reply with a number of your choosing"
	printf '\t\e[1;32m%-6s\e[m\n' "1. Update your full system"
	printf '\t\e[1;32m%-6s\e[m\n' "2. Install asusctl"
	printf '\t\e[1;32m%-6s\e[m\n' "3. Mic not working"
	printf '\t\e[1;32m%-6s\e[m\n' "4. Mount ntfs partitions at boot"
	printf '\t\e[1;32m%-6s\e[m\n' "5. Squeeze maximum battery life"
	printf '\t\e[1;32m%-6s\e[m\n' "6. Clear cache and remove unused dependencies"
	printf '\t\e[1;32m%-6s\e[m\n' "7. Install pulseeffects presets for better sound quality"
	printf '\t\e[1;32m%-6s\e[m\n' "8. Mic input key not working"
	printf '\t\e[1;32m%-6s\e[m\n' "9. Exit script"
	printf '\t\e[1;32m%-6s\e[m' "enter choice : "
	read choice
	case $choice in
	1)
		updates
		return 1
		;;
	2)
		asusctl
		;;
	3)	microphone
		return 1
		;;
	4)
		partition
		return 1
		;;
	
	5)
		battery
		return 1
		;;
	6)
		cache
		return 1
		;;

	7)
		pulse
		return 1
		;;
	8)
		mickey
		return 1
		;;
	9)
		exit 0
		;;
esac	 
}
#####################################################################################
#package manager selection
packagemanager(){
	printf '\t\e[1;34m%-6s\e[m\n' "Choose Your Package Manager"
	printf '\t\e[1;32m%-6s\e[m\n' "1. Apt"	
	printf '\t\e[1;32m%-6s\e[m\n' "2. Dnf"
	printf '\t\e[1;32m%-6s\e[m\n' "3. Zypper"
	printf '\t\e[1;32m%-6s\e[m\n' "4. Pacman"
	read choice
	case $choice in
		1)
			echo "apt" > $file
			package="apt"
			;;
		2)
			echo "dnf" > $file
			package="dnf"
			;;
		3)
			echo "zypper" > $file
			package="zypper"
			;;
		4)
			echo "pacman" > $file
			package="pacman"
			;;
		*)
			echo "Invalid input try again"
			packagemanager
		;;
esac		
list
}
#####################################################################################
#Update system
updates()
{
if [[ "$package" == "apt" ]]
then
sudo apt-get update && sudo apt-get -y upgrade
elif [[ "$package" == "dnf" ]]
then
sudo dnf upgrade
elif [[ "$package" == "zypper" ]]
then
sudo zypper -n update && sudo zypper -n dup
elif [[ "$package" == "pacman" ]]
then
sudo pacman -Syyu
else
echo "no"
fi
}
#####################################################################################
#microphone fix
microphone()
{
local mic=/etc/modprobe.d/alsa-base.conf
printf '\t\e[1;32m%-6s\e[m\n' "for proper microphone detection we need to edit alsa base.conf."
printf '\t\e[1;32m%-6s\e[m\n' "if u get Codec: Realtek ALC294 then u just need to enter y and if u get any other codec enter n"
printf '\t\e[1;32m%-6s\e[m\n' "Printing codec version"
cat /proc/asound/card*/codec* | grep Codec
printf '\t\e[1;32m%-6s\e[m\n' "Is your codec Realtek ALC294 ? type [y/n]"
read choice
if [[ "$choice" == 'y' ]]
then
	if [[ -f "$mic" ]]
	then
	printf '\t\e[1;32m%-6s\e[m\n' "Creating a copy of original alsa-base.conf as alsa-base.conf.bak in the same directory
	replace the alsa-base.conf with the backup if any issue arises."
	sudo cp $mic $mic.bak
	echo 'options snd-hda-intel model=dell-headset-multi' | sudo tee -a $mic> /dev/null
	else
	sudo touch $mic
	echo 'options snd-hda-intel model=dell-headset-multi' | sudo tee $mic > /dev/null
	fi
else
printf '\t\e[1;32m%-6s\e[m\n' "visit https://www.kernel.org/doc/html/latest/sound/hd-audio/models.html and find the correct codec version for your device and paste it below"
echo "enter codec : "
read codec
if [[ -f "$mic" ]]
then
echo "creating a copy of original alsa-base.conf as alsa-base.conf.bak in the same directory replace the alsa-base.conf with the backup if any issue arises."
sudo $mic $mic.bak
echo "options snd-hda-intel model=${codec}" | sudo tee -a $mic > /dev/null
else
sudo touch $mic
echo "options snd-hda-intel model=${codec}" | sudo tee $mic > /dev/null
fi
fi
printf '\t\e[1;32m%-6s\e[m\n' "Reboot and your headset microphone should work"
sleep 7
clear
list
}
#####################################################################################
#pulseeffects presets
pulse(){
local file2=packages/pulse.sh
#Thanks to Jackhack96 for writing an automated script https://github.com/JackHack96/PulseEffects-Presets 
#curl is required for the scripts to work
if [[ ! -x "$file2" ]]
then
	chmod +x $file2
	fi
bash "$file2"
#presets installed. select from pulseeffects
sleep 7
clear
list
}
#####################################################################################
#ntfs partition to mount at boot
partition(){
local DIRECTORY=/media
printf '\e[1;31m%-6s\e[m\n' "IF U WANNA READ ABOUT MOUNTING PARTITIONS IN LINUX GO VISIT https://wiki.archlinux.org/title/Fstab"
#checking if folder exists
if [[ ! -d "$DIRECTORY" ]]
then
sudo mkdir "$DIRECTORY"
fi
printf '\t\e[1;32m%-6s\e[m' "Write the name of the folder u want to mount your parition in 
(It can be any name. It'll show as that name in your file manager).
Enter the name : " 
read foldname
local loca="${DIRECTORY}/${foldname}"
sudo mkdir "$loca"
printf '\t\e[1;32m%-6s\e[m\n' "Partition would be mounted at : $loca "  
printf '\e[1;31m%-6s\e[m\n' "
READ THESE COMMENTS VERY CAREFULLY
Find the name of ur partition which u want to mount"
printf '\e[1;35m%-6s\e[m\n' "
My lsblk command shows me  : 
NAME        FSTYPE FSVER LABEL   UUID                                 FSAVAIL FSUSE% MOUNTPOINT         
nvme0n1                                                                                                 
├─nvme0n1p1 vfat   FAT32         9C50-E155                              66.3M    31% /boot/efi          
├─nvme0n1p2                                                                                             
├─nvme0n1p3 ntfs                 B2D25554D2551DC3                                                       
├─nvme0n1p4 ntfs                 1A4A94884A946275                                                       
├─nvme0n1p5 ntfs         Storage 9A84C8F984C8D8C1                        110G    65% 
├─nvme0n1p6 btrfs                d12d770b-01f6-4f2f-a148-068349fd5a0e   54.1G    30% /var               
└─nvme0n1p7 swap   1             63ca847b-2bd0-44aa-b24f-9f6c8b1edc2d                [SWAP]             
My drive is nvme0n1p5 which i want to mount.
Yours will be different so please find out the correct drive partition you want to mount. 
You can simply note down yours and paste it in when asked for."
sleep 7
printf '\e[1;32m%-6s\e[m' "Are you ready to continue [y/n] : " 
read choice
if [[ "$choice" == 'y' ]]
then
clear
printf '\t\e[1;32m%-6s\e[m\n' "CAREFULLY NOTE DOWN YOUR PARTITON NAME" 
lsblk -f
sleep 7
printf '\e[1;30m%-6s\e[m \n' "creating backup of fstab as fstab.bak. restore original if issue arises."
sudo cp /etc/fstab /etc/fstab.bak
printf '\e[1;32m%-6s\e[m\n' "I hope you would have noted it down properly." 
printf '\e[1;30m%-6s\e[m' " Enter your partiton name : "
read partname
printf '\e[1;30m%-6s\e[m \n' "creating backup of fstab as fstab.bak. restore original if issue arises."
sudo cp /etc/fstab /etc/fstab.bak
echo -e "/dev/${partname}/\t${loca}\tntfs-3g\tpermissions,locale=en_US.utf8\t0\t2" | sudo tee -a /etc/fstab > /dev/null
printf '\e[1;30m%-6s\e[m \n' "On next reboot your partition should be mounted automatically"
sleep 5
clear
list 
else
echo "returning to main menu"
sleep 5
clear
list
fi
}
###############################################################################################################################
#Squeeze maximum battery life
battery()
{
printf '\e[1;30m%-6s\e[m \n' "Most distros ship default with tlp. 
So if not available in your distro Install it yourself
Visit https://linrunner.de/tlp/ for installation details"
sudo cp packages/tlp.conf /etc/
sudo cp packages/pcioff.sh /bin/
sudo cp packages/pciauto.service /etc/systemd/system/pciauto.service
systemctl restart tlp.service
systemctl enable pciauto.service && systemctl start pciauto.service
printf '\e[1;30m%-6s\e[m \n' "You should get better battery now"
printf '\e[1;30m%-6s\e[m \n' "returning to main menu..."
sleep 7
clear
list
}
#############################################################################################################################
asusctl(){
local asusctl_sus="https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/x86_64/asusctl-3.7.2-1.5.x86_64.rpm"
local asusctl_fed33="https://download.opensuse.org/repositories/home:/luke_nukem:/asus/Fedora_34/x86_64/asusctl-3.7.2-1.8.x86_64.rpm"
local asusctl_fed34="https://download.opensuse.org/repositories/home:/luke_nukem:/asus/Fedora_34/x86_64/asusctl-3.7.2-1.8.x86_64.rpm"
local asusctl_deb="https://download.opensuse.org/repositories/home:/luke_nukem:/asus/xUbuntu_21.04/amd64/asusctl_3.7.1-1.6_amd64.deb"
if [[ "$package" == "apt" ]]
then
wget --no-check-certificate $asusctl_deb -O asusctl.deb
sudo apt-get install ./asusctl.deb && sudo apt-get install -f
elif [[ "$package" == "dnf" ]]
then
	printf '\e[1;30m%-6s\e[m' "Are you using fedora 33 or fedora 34. enter your fedora version number : "
	read version
	if [[ $version -eq 33 ]]
	then
		wget --no-check-certificate $asusctl_fed33 -O asusctl.rpm
		sudo dnf install asusctl.rpm
		elif [[ $version -eq 34 ]]
	then
		wget --no-check-certificate $asusctl_fed34 -O asusctl.rpm
		sudo dnf install asusctl.rpm
	fi
elif [[ "$package" == "zypper" ]]
then
	wget --no-check-certificate $asusctl_sus -O asusctl.rpm
	sudo zypper install asusctl.rpm
elif [[ "$package" == "pacman" ]]
then
if [ -x /bin/yay ]
then
	yay -S asusctl-git
elif [ -x /bin/paru ]
then
	paru -S asusctl-git
elif [ -x /bin/pamac ]
then
	pamac install asusctl-git
fi
fi
if [[ $? -eq 0 ]]
then
	systemctl daemon-reload && systemctl restart asusd
	systemctl --user enable asus-notify.service
	systemctl --user start asus-notify.service
	printf '\e[1;32m%-6s\e[m' "Asusctl installed. Reboot for proper functionality."
else
	echo "The installation failed. visit https://gitlab.com/asus-linux/asusctl for installation instructions "
fi
list
}
mickey()
{
local DIRECTORY=/etc/udev/hwdb.d
if [[ ! -d "$DIRECTORY" ]] 
then 
	sudo mkdir "$DIRECTORY" 
fi 
sudo cp packages/90-nkey.hwdb /etc/udev/hwdb.d/
sudo systemd-hwdb update
sudo udevadm trigger
printf '\e[1;32m%-6s\e[m' "Reboot and your mic key should be working."
sleep 7
clear
list
}
cache()
{
if flatpak list
then
flatpak uninstall --unused
fi
if [[ "$package" == "apt" ]]
then
sudo apt autoremove && sudo apt clean
elif [[ "$package" == "dnf" ]]
then
sudo dnf autoremove
sudo dnf clean all
elif [[ "$package" == "zypper" ]]
then
sudo zypper cc -a
elif [[ "$package" == "pacman" ]]
then
        sudo pacman -Rns $(pacman -Qtdq)
fi
if [[ $? -eq 0 ]]
then
echo "Cache and orphaned packages cleared"
echo "returning to menu"
fi
sleep 5
clear
list
}
list	
