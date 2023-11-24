#!/usr/bin/env bash

# This file is part of the microplay-hub
# Designs by Liontek1985
# for RetroPie and offshoot
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# mpcore
# v2.08

rp_module_id="mpcore"
rp_module_desc="Microplay Base Setup"
rp_module_repo="git https://github.com/microplay-hub/mpcore.git master"
rp_module_section="core"
rp_module_flags="noinstclean"

function depends_mpcore() {
    local depends=(cmake)
     getDepends "${depends[@]}"
}

function sources_mpcore() {
    if [[ -d "$md_inst" ]]; then
        git -C "$md_inst" reset --hard  # ensure that no local changes exist
    fi
    gitPullOrClone "$md_inst"
}

function install_mpcore() {
    local mpcoresetup="$scriptdir/scriptmodules/supplementary"
    cd "$md_inst"

	local HOST=$(hostname)
	
#	cp -r -u "mpcore.sh" "$mpcoresetup/mpcore.sh"
    chown -R $user:$user "$mpcoresetup/mpcore.sh"
	chmod 755 "$mpcoresetup/mpcore.sh"
	rm -r "mpcore.sh"
	
    if [[ ! -f "$configdir/all/$md_id.cfg" ]]; then
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
        iniSet "MPCORESTATUS" "not-installed"
        iniSet "MPCOREOSUPD" "not-updated"	
        iniSet "MPCOREHOST" "$HOST"
        iniSet "MPBOARD" "not-detected"
        iniSet "RPIMSG" "Disable"
        iniSet "RPI4OC" "Disable"
    fi
    chown $user:$user "$configdir/all/$md_id.cfg"
	chmod 755 "$configdir/all/$md_id.cfg"


	
    if isPlatform "sun50i-h616"; then
		iniSet "MPBOARD" "sun50i-h616"
    elif isPlatform "sun50i-h6"; then
		iniSet "MPBOARD" "sun50i-h6"
    elif isPlatform "sun8i-h3"; then
		iniSet "MPBOARD" "sun8i-h3"
    elif isPlatform "armv7-mali"; then
		iniSet "MPBOARD" "armv7-mali"
    elif isPlatform "rpi1"; then
		iniSet "MPBOARD" "RPI1"	
    elif isPlatform "rpi2"; then
		iniSet "MPBOARD" "RPI2"	
    elif isPlatform "rpi3"; then
		iniSet "MPBOARD" "RPI3"		
    elif isPlatform "rpi4"; then
		iniSet "MPBOARD" "RPI4"		
    elif isPlatform "rpi5"; then
		iniSet "MPBOARD" "RPI5"	
    fi
	
}

function sbc_mpcore() {

    if isPlatform "sun50i-h616"; then
		iniSet "MPBOARD" "sun50i-h616"
    elif isPlatform "sun50i-h6"; then
		iniSet "MPBOARD" "sun50i-h6"
    elif isPlatform "sun8i-h3"; then
		iniSet "MPBOARD" "sun8i-h3"
    elif isPlatform "armv7-mali"; then
		iniSet "MPBOARD" "armv7-mali"
    elif isPlatform "rpi1"; then
		iniSet "MPBOARD" "RPI1"	
    elif isPlatform "rpi2"; then
		iniSet "MPBOARD" "RPI2"	
    elif isPlatform "rpi3"; then
		iniSet "MPBOARD" "RPI3"		
    elif isPlatform "rpi4"; then
		iniSet "MPBOARD" "RPI4"		
    elif isPlatform "rpi5"; then
		iniSet "MPBOARD" "RPI5"	
    fi
	
}


function remove_mpcore() {
	#uninstall script
	uninstall_mpcore
	
	#remove modul folder
	rm -rf "$md_inst"
    rm -r "$configdir/all/$md_id.cfg"
}

function uninstall_mpcore() {
	#default modt
    if isPlatform "sun50i-h616"; then
		cp -r "/etc/update-motd.d/10-orangepi-header.backup" "/etc/update-motd.d/10-orangepi-header"
		rm -r "/etc/update-motd.d/10-orangepi-header.backup"
		chown -R $user:$user "/etc/update-motd.d/10-orangepi-header"
		chmod 755 "/etc/update-motd.d/10-orangepi-header"
    elif isPlatform "sun50i-h6"; then
		cp -r "/etc/update-motd.d/10-orangepi-header.backup" "/etc/update-motd.d/10-orangepi-header"
		rm -r "/etc/update-motd.d/10-orangepi-header.backup"
		cp -r "motd_logo/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header"
		chown -R $user:$user "/etc/update-motd.d/10-orangepi-header"
		chmod 755 "/etc/update-motd.d/10-orangepi-header"
    elif isPlatform "sun8i-h3"; then
		cp -r "/etc/update-motd.d/10-armbian-header.backup" "/etc/update-motd.d/10-armbian-header"
		rm -r "/etc/update-motd.d/10-armbian-header.backup"
		chown -R $user:$user "/etc/update-motd.d/10-armbian-header"
		chmod 755 "/etc/update-motd.d/10-armbian-header"
    elif isPlatform "armv7-mali"; then
		cp -r "/etc/update-motd.d/10-armbian-header.backup" "/etc/update-motd.d/10-armbian-header"
		rm -r "/etc/update-motd.d/10-armbian-header.backup"
		chown -R $user:$user "/etc/update-motd.d/10-armbian-header"
		chmod 755 "/etc/update-motd.d/10-armbian-header"
    elif isPlatform "rpi"; then
		rm -r "/etc/update-motd.d/11-microplay-welcome-message"
		rm -r "/home/pi/rpi-microplay-motd.sh"
		rm -r "/home/pi/.bash_profile"
    fi
	
	#remove screensaver
	rm -r "Screensaver/." "/opt/retropie/configs/all/emulationstation/slideshow/media/mp_saver.png"

	#default bootlogo settings
    if isPlatform "sun50i-h616"; then
	cp -r "/boot/boot.bmp.backup" "/boot/boot.bmp"
	rm -r "/boot/boot.bmp.backup"
	sed -i "2s~.*~bootlogo=false~" /boot/orangepiEnv.txt
    elif isPlatform "sun50i-h6"; then
	cp -r "/boot/boot.bmp.backup" "/boot/boot.bmp"
	rm -r "/boot/boot.bmp.backup"
	sed -i "2s~.*~bootlogo=false~" /boot/orangepiEnv.txt
    elif isPlatform "sun8i-h3"; then
	cp -r "/boot/boot.bmp.backup" "/boot/boot.bmp"
	rm -r "/boot/boot.bmp.backup"
	sed -i "2s~.*~bootlogo=false~" /boot/armbianEnv.txt
    elif isPlatform "armv7-mali"; then
	cp -r "/boot/boot.bmp.backup" "/boot/boot.bmp"
	rm -r "/boot/boot.bmp.backup"
	sed -i "2s~.*~bootlogo=false~" /boot/armbianEnv.txt
    elif isPlatform "rpi"; then
	echo "Please wait"
    fi	
	
	#default hostname
	cp -r "/etc/hostname.backup" "/etc/hostname"
	rm -r "/etc/hostname.backup"
	local HOST=$(hostname)
    iniSet "MPCOREHOST" "$HOST"
}

function configmp_mpcore() {
	chown $user:$user "$configdir/all/$md_id.cfg"	
    iniConfig "=" '"' "$configdir/all/$md_id.cfg"	
}


function sshaccess_mpcore() {
    if isPlatform "rpi"; then
	echo "Activate Raspberry-PI SSH"
	echo "Please wait"
	sleep 1
 	systemctl start ssh
  	systemctl enable ssh
	sleep 1
	echo "SSH-Status"
 	systemctl is-enabled ssh
  	sleep 3
    fi	


}


function defaccess_mpcore() {
	echo "Set retropie folder permissions back"
	echo "Please wait"
	sleep 1
	chown -cR pi:pi "/home/pi/RetroPie"
	chown -cR pi:pi "/home/pi/RetroPie-Setup"
	chown -cR root:root "/home/pi/RetroPie-Setup/tmp"
	chown -cR root:root "/etc/emulationstation"
	chown -cR root:root "/opt/retropie"
	chown -cR pi:pi "/opt/retropie/configs"
}

function osupdate_mpcore() {
	local NOW=$(date +"%Y-%m-%d")
	echo "...starting OS Update and Upgrade"
	sleep 1
	apt-get update && apt-get upgrade -y
	sleep 1	
	iniSet "MPCOREOSUPD" "$NOW"
}

function fwupdate_mpcore() {

    if isPlatform "rpi"; then
	echo "...starting RPI Firmware-Update"
	sleep 1
	sudo apt install rpi-update -y
	sleep 1
    else
	echo "...no Firmware-Updates"    
    fi
	
}

function defcontrol_mpcore() {
	echo "set default Controller config"
	rm "$configdir/all/emulationstation/es_input.cfg"
	printMsgs "dialog" "Controller config set to default .\n\nRestart System to apply."
}

function bootloader_mpcore() {
    if isPlatform "sun50i-h616"; then
	echo "install Bootloader"
	chown -R root:root "/boot/boot.bmp"
	cp -r "/boot/boot.bmp" "/boot/boot.bmp.backup"
	cp -r "bootloader/boot.bmp" "/boot/boot.bmp"
	chown -R root:root "/boot/boot.bmp"
	chmod 755 "/boot/boot.bmp"
	sed -i "2s~.*~bootlogo=true~" /boot/orangepiEnv.txt
    elif isPlatform "sun50i-h6"; then
	echo "install Bootloader"
	chown -R root:root "/boot/boot.bmp"
	cp -r "/boot/boot.bmp" "/boot/boot.bmp.backup"
	cp -r "bootloader/boot.bmp" "/boot/boot.bmp"
	chown -R root:root "/boot/boot.bmp"
	chmod 755 "/boot/boot.bmp"
	sed -i "2s~.*~bootlogo=true~" /boot/orangepiEnv.txt
    elif isPlatform "sun8i-h3"; then
	echo "install Bootloader"
	chown -R root:root "/boot/boot.bmp"
	cp -r "/boot/boot.bmp" "/boot/boot.bmp.backup"
	cp -r "bootloader/boot.bmp" "/boot/boot.bmp"
	chown -R root:root "/boot/boot.bmp"
	chmod 755 "/boot/boot.bmp"
	sed -i "2s~.*~bootlogo=true~" /boot/armbianEnv.txt
    elif isPlatform "armv7-mali"; then
	echo "install Bootloader"
	chown -R root:root "/boot/boot.bmp"
	cp -r "/boot/boot.bmp" "/boot/boot.bmp.backup"
	cp -r "bootloader/boot.bmp" "/boot/boot.bmp"
	chown -R root:root "/boot/boot.bmp"
	chmod 755 "/boot/boot.bmp"
	sed -i "2s~.*~bootlogo=true~" /boot/armbianEnv.txt
    elif isPlatform "rpi"; then
	echo "install Bootloader"
    fi	
}

function hostname_mpcore() {
	cp -r "/etc/hostname" "/etc/hostname.backup"
	echo "set FTP-Hostname"
	hostnamectl set-hostname microplay		
	sleep 1
	local HOST=$(hostname)
        iniSet "MPCOREHOST" "$HOST"
    		if isPlatform "rpi"; then
			sed -i "6s~.*~127.0.1.1       microplay~" /etc/hosts
    		fi	
    	sleep 1
}

function hostupdate_mpcore() {
	local HOST=$(hostname)
        iniSet "MPCOREHOST" "$HOST"
}

function motd_mpcore() {
	echo "install motd logo file"
    if isPlatform "sun50i-h616"; then
		cp -r "/etc/update-motd.d/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header.backup"
		cp -r "motd_logo/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header"
		chown -R $user:$user "/etc/update-motd.d/10-orangepi-header"
		chmod 755 "/etc/update-motd.d/10-orangepi-header"
    elif isPlatform "sun50i-h6"; then
		cp -r "/etc/update-motd.d/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header.backup"
		cp -r "/etc/update-motd.d/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header.backup"
		cp -r "motd_logo/10-orangepi-header" "/etc/update-motd.d/10-orangepi-header"
		chown -R $user:$user "/etc/update-motd.d/10-orangepi-header"
		chmod 755 "/etc/update-motd.d/10-orangepi-header"
    elif isPlatform "sun8i-h3"; then
		cp -r "/etc/update-motd.d/10-armbian-header" "/etc/update-motd.d/10-armbian-header.backup"
		cp -r "motd_logo/10-armbian-header" "/etc/update-motd.d/10-armbian-header"
		chown -R $user:$user "/etc/update-motd.d/10-armbian-header"
		chmod 755 "/etc/update-motd.d/10-armbian-header"
    elif isPlatform "armv7-mali"; then
		cp -r "/etc/update-motd.d/10-armbian-header" "/etc/update-motd.d/10-armbian-header.backup"
		cp -r "motd_logo/10-armbian-header" "/etc/update-motd.d/10-armbian-header"
		chown -R $user:$user "/etc/update-motd.d/10-armbian-header"
		chmod 755 "/etc/update-motd.d/10-armbian-header"
     elif isPlatform "rpi"; then
		cp -r "motd_logo/rpi-microplay-motd.sh" "/home/pi/rpi-microplay-motd.sh"
  		ln -s /home/pi/rpi-microplay-motd.sh /etc/update-motd.d/11-microplay-welcome-message
		touch "/home/pi/.bash_profile"
		chown -R $user:$user "/home/pi/rpi-microplay-motd.sh"
		chown -R $user:$user "/home/pi/.bash_profile"
		chmod 755 "/home/pi/rpi-microplay-motd.sh"
		chmod 755 "/home/pi/.bash_profile"
    fi
}


function screensaver_mpcore() {
	echo "#install Screensaver images"
	cp -rf "Screensaver/." "/opt/retropie/configs/all/emulationstation"
	chown -cR pi:pi "/opt/retropie/configs/all/emulationstation"
	chmod -R 755 "/opt/retropie/configs/all/emulationstation"
}

function platformcfg_mpcore() {
    if isPlatform "sun50i-h616"; then
		echo "cleaning folders"		
		sudo userdel -r orangepi
		rm -r /home/orangepi
		sleep 1
    elif isPlatform "sun50i-h6"; then
		echo "cleaning folders"		
		sudo userdel -r orangepi
		rm -r /home/orangepi
		sleep 1
    elif isPlatform "sun8i-h3"; then
		sudo apt-get install avahi-daemon
		>/etc/dhcp/dhclient-enter-hooks.d/unset_old_hostname
    elif isPlatform "armv7-mali"; then
		sudo apt-get install avahi-daemon
		>/etc/dhcp/dhclient-enter-hooks.d/unset_old_hostname
    elif isPlatform "rpi"; then
			if grep -q "#disable_overscan=1" /boot/config.txt; then
				sed -i "s/#disable_overscan=1/disable_overscan=1/" /boot/config.txt
			else
				echo "dialog" "Overscan already Disabled"
			fi

      			if grep -q "console=tty1" /boot/cmdline.txt; then
				sed -i "s/console=tty1/console=tty3/" /boot/cmdline.txt
			fi

         		if grep -q "console=tty3" /boot/cmdline.txt; then
				echo "dialog" "console already tty3"
			fi
			
			if grep -q "quiet" /boot/cmdline.txt; then
				echo "dialog" "Boot-Message is already Disabled"
			else
				echo "quiet" >> /boot/cmdline.txt
			fi

		>/etc/dhcp/dhclient-enter-hooks.d/unset_old_hostname
    fi
}

function useraccess_mpcore() {
    if isPlatform "sun50i-h616"; then
	echo "we change now the User Access"
	yes mpcore | passwd root
	yes mpcore | passwd pi
	echo "User: pi , Passwd: mpcore"
	echo "User: root , Passwd: mpcore"
	sleep 6
    elif isPlatform "sun50i-h6"; then
	echo "we change now the User Access"
	yes mpcore | passwd root
	yes mpcore | passwd pi
	echo "User: pi , Passwd: mpcore"
	echo "User: root , Passwd: mpcore"
	sleep 6
    elif isPlatform "sun8i-h3"; then
	echo "we change now the User Access"
	yes mpcore | passwd root
	yes mpcore | passwd pi
	echo "User: pi , Passwd: mpcore"
	echo "User: root , Passwd: mpcore"
	sleep 6
    elif isPlatform "armv7-mali"; then
	echo "we change now the User Access"
	yes mpcore | passwd root
	yes mpcore | passwd pi
	echo "User: pi , Passwd: mpcore"
	echo "User: root , Passwd: mpcore"
	sleep 6
    elif isPlatform "rpi"; then
	echo "we change now the User Access"
	yes mpcore | passwd root
	yes mpcore | passwd pi
	echo "User: pi , Passwd: mpcore"
	echo "User: root , Passwd: mpcore"
	sleep 6
    fi
}

function esfull_mpcore() {
	echo "install es_systems full list"
	cp -r "/etc/emulationstation/es_systems.cfg" "/etc/emulationstation/es_systems.bkup"
	cp -rf "es_systems/Full/es_systems.cfg" "/etc/emulationstation/es_systems.cfg"
	chmod 755 "/etc/emulationstation/es_systems.cfg"
	printMsgs "dialog" "ES-Systems list updated\n\nRestart Emulationstation to apply."
}


function rpibootmsg_mpcore() {
    options=(	
        RPA "Enable RPI Boot-Message"
        RPB "Disable RPI Boot-Message"
		RPX "[current setting: $rpimsg]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        RPA)
			if grep -q "quiet" /boot/cmdline.txt; then
				sed -i "/^quiet*\s*$/d" /boot/cmdline.txt
    			else
				echo "dialog" "quiet mod already disabled"
    				sleep 1
			fi

      			if grep -q "console=tty1" /boot/cmdline.txt; then
				sed -i "s/console=tty1/console=tty3/" /boot/cmdline.txt
			fi

         		if grep -q "console=tty3" /boot/cmdline.txt; then
				echo "dialog" "console already tty3"
    				sleep 1
			fi
   
            iniSet "RPIMSG" "Enable"
            ;;
        RPB)
			if grep -q "quiet" /boot/cmdline.txt; then
				echo "dialog" "quiet mod already enabled"
        			sleep 1
			else
				echo "quiet" >> /boot/cmdline.txt
			fi

      			if grep -q "console=tty3" /boot/cmdline.txt; then
				sed -i "s/console=tty3/console=tty1/" /boot/cmdline.txt
			fi

         		if grep -q "console=tty1" /boot/cmdline.txt; then
				echo "dialog" "console already tty1"
    				sleep 1
			fi
   
            iniSet "RPIMSG" "Disable"
            ;;
    esac
}

function rpi4oc_mpcore() {
    options=(	
        ROA "set RPI4 Safe-OC-Mod"
        ROB "Disable OC-Mod"
		ROX "[current setting: $rpi4oc]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        ROA)
			if grep -q "over_voltage=" /boot/config.txt; then
				printMsgs "dialog" "PI already Overclocked"
			else
				sed -i "/700 MHz is the default/a over_voltage=5\narm_freq=2000\ngpu_freq=700\ngpu_mem=256" /boot/config.txt
			fi
            iniSet "RPI4OC" "OC-MOD-Safe"
            printMsgs "dialog" "Set $rpi4oc - CPU 2000Mhz GPU 700Mhz Overvoltage 6"
            ;;
        ROB)
			if grep -q "over_voltage=" /boot/config.txt; then
				sed -i "/^over_voltage=5*\s*$/d" /boot/config.txt
				sed -i "/^arm_freq=2000*\s*$/d" /boot/config.txt
				sed -i "/^gpu_freq=700*\s*$/d" /boot/config.txt
				sed -i "/^gpu_mem=256*\s*$/d" /boot/config.txt
			else
				printMsgs "dialog" "Overclocking is already Disabled"
			fi
            iniSet "RPI4OC" "Disable"
            ;;
    esac
}

function changestatus_mpcore() {
    options=(	
        MPI "Install MPCORE-Base"
        MPU "Deinstall MPCORE-Base"
		MPX "[current setting: $mpcorestatus]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        MPI)
            if dialog --defaultno --yesno "Are you sure you want convert RetroPie to Microplay-hub *mpcore* version?" 22 76 2>&1 >/dev/tty; then
			#change to mpcore folder
			cd "$md_inst"
			#mpcore base installer
			header-inst_mpcore
			#SBC Dedection
			sbc_mpcore
			#change the User and SSH Access
   			sshaccess_mpcore
			useraccess_mpcore
			#Set retropie folder permission
			defaccess_mpcore
			#install motd logo
			motd_mpcore
			#install bootloader
			bootloader_mpcore
			#set FTP-Hostname
			hostname_mpcore	
			#install Screensaver
			screensaver_mpcore
			#platformcfg folders
			platformcfg_mpcore
			
            iniSet "MPCORESTATUS" "Installed"
            printMsgs "dialog" "MPCORE Base changed status to [$mpcorestatus]"
            fi
            ;;
        MPU)
			uninstall_mpcore
            iniSet "AUTOSTART" "not-installed"
            printMsgs "dialog" "MPCORE Base changed status to [$mpcorestatus]"
            ;;
    esac
}				

function header-inst_mpcore() {
	echo "install & update mpcore-nxt base"
	echo "v2.08 - 2023-11"
	echo "#################################"
	echo "*check the packages"
	echo "*starting the installation"
	echo "#################################"
	sleep 3
	echo "activate mpcore modules"
}


function gui_mpcore() {
    while true; do

    local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
		
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "MPCORESTATUS"
        local mpcorestatus=${ini_value}
		iniGet "MPCOREOSUPD"
		local mpcoreosupd=${ini_value}
		iniGet "MPCOREHOST"
		local mpcorehost=${ini_value}
		iniGet "MPBOARD"
		local mpboard=${ini_value}
		iniGet "RPIMSG"
		local rpimsg=${ini_value}
		iniGet "RPI4OC"
		local rpi4oc=${ini_value}
			
		local options=(
		)
		options+=(
			AM "MPCORE Base [$mpcorestatus]"
			CD "set default Controller config"
			EF "ES-Systems show full list"
			UP "OS Update and Upgrade ($mpcoreosupd)"
			HN "Edit Hostname (FTP/SSH: $mpcorehost)"
			PR "Set retropie folder permissions back"
			ZZ "Reboot System Now"
            TEK "### Script by Liontek1985 ###"
            SBC "--- SBC-Auto-Config: $mpboard ---"
		)
		
		if isPlatform "rpi"; then
		options+=(
			RPI "*[ Raspberry-PI - Options ]*"
			PQ "*RPI - config boot message ($rpimsg)"
			PX "*RPI - Edit /boot/config.txt"
			PY "*RPI - Edit /boot/cmdline.txt"
		)
		fi
		
		if isPlatform "rpi4"; then
		options+=(
			P4C "*RPI4 - Overclocking ($rpi4oc)"
		)
		fi
		
		if isPlatform "rpi"; then
		options+=(

		)
		fi

		
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "MPCORESTATUS"
        local mpcorestatus=${ini_value}
		iniGet "MPCOREOSUPD"
		local mpcoreosupd=${ini_value}
		iniGet "MPCOREHOST"
		local mpcorehost=${ini_value}
		iniGet "MPBOARD"
		local mpboard=${ini_value}
		iniGet "RPIMSG"
		local rpimsg=${ini_value}
		iniGet "RPI4OC"
		local rpi4oc=${ini_value}
		
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            AM)
			#Install MPCORE
				configmp_mpcore
				changestatus_mpcore
                ;;
            CD)
			#set default Controller config
				defcontrol_mpcore
				;;
            EF)
			#ES-Systems show full list
				esfull_mpcore
				;;
            UP)
			#OS UPDATE AND UPGRADE
				osupdate_mpcore
    			fwupdate_mpcore
				;;
            HN)
			#Edit Hostname
				editFile "/etc/hostname"
				configmp_mpcore
				hostupdate_mpcore
				;;
            PR)
			#Set retropie folder permissions back
				defaccess_mpcore
				printMsgs "dialog" "original RetroPie rights restored"
				;;
            PQ)
			#RPI - config boot message
				configmp_mpcore
				rpibootmsg_mpcore
				;;
            PX)
			#RPI - edit config
				editFile "/boot/config.txt"
				;;
            PY)
			#RPI - edit cmdline
				editFile "/boot/cmdline.txt"
				;;
            P4C)
			#RPI4 - overclocking
				configmp_mpcore
				rpi4oc_mpcore
				;;
            ZZ)
			#Reboot System Now
				echo "...Rebooting System"
				/usr/bin/sudo /sbin/reboot
				;;
        esac
    done
}
