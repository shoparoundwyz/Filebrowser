#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

[[ $(id -u) != 0 ]] && echo -e " \nuse ${red}root ${none}to run the script ${yellow}${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

# check ubuntu centos 
if [[ -f /usr/bin/apt-get || -f /usr/bin/yum ]] && [[ -f /bin/systemctl ]]; then

	if [[ -f /usr/bin/yum ]]; then

		cmd="yum"

	fi

else

	echo -e " \n ${red}The script${none} supports linux ${yellow} ${none}\n" && exit 1

fi

if [[ $sys_bit == "i386" || $sys_bit == "i686" ]]; then
	filebrowser="linux-386-filebrowser.tar.gz"
elif [[ $sys_bit == "x86_64" ]]; then
	filebrowser="linux-amd64-filebrowser.tar.gz"
else
	echo -e " \n$redThe script supports linux $none\n" && exit 1
fi

install() {
	$cmd install wget -y
	ver=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep 'tag_name' | cut -d\" -f4)
	Filebrowser_download_link="https://github.com/filebrowser/filebrowser/releases/download/$ver/$filebrowser"
	mkdir -p /tmp/Filebrowser
	if ! wget --no-check-certificate --no-cache -O "/tmp/Filebrowser.tar.gz" $Filebrowser_download_link; then
		echo -e "$redFilebrowser downlaoding failed！$none" && exit 1
	fi
	tar zxf /tmp/Filebrowser.tar.gz -C /tmp/Filebrowser
	cp -f /tmp/Filebrowser/filebrowser /usr/bin/filebrowser
	chmod +x /usr/bin/filebrowser
	if [[ -f /usr/bin/filebrowser ]]; then
		cat >/lib/systemd/system/filebrowser.service <<-EOF
[Unit]
Description=Filebrowser Service
After=network.target
Wants=network.target

[Service]
Type=simple
PIDFile=/var/run/filebrowser.pid
ExecStart=/usr/bin/filebrowser -c /etc/filebrowser/filebrowser.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
		EOF

		mkdir -p /etc/filebrowser
		cat >/etc/filebrowser/filebrowser.json <<-EOF
{
  "port": 8300,
  "baseURL": "/admin",
  "address": "0.0.0.0",
  "reCaptchaKey": "",
  "reCaptchaSecret": "",
  "database": "/etc/filebrowser/database.db",
  "log": "stdout",
  "plugin": "",
  "scope": "/",
  "allowCommands": true,
  "allowEdit": true,
  "allowNew": true,
  "commands": [
    "git",
    "svn"
  ]
}
		EOF

		get_ip
		systemctl enable filebrowser
		systemctl start filebrowser

		clear
		echo -e "
		The installation was successful  

		url: ${yellow}http://${ip}:8300/admin$none

		user: ${green}admin$none

		password: ${green}admin$none


		
		"
	else
		echo -e " \n$redThe installation failed...$none\n"
	fi
	rm -rf /tmp/Filebrowser
	rm -rf /tmp/Filebrowser.tar.gz
}
uninstall() {
	if [[ -f /usr/bin/filebrowser && -f /etc/filebrowser/filebrowser.json ]]; then
		Filebrowser_pid=$(pgrep "filebrowser")
		[ $Filebrowser_pid ] && systemctl stop filebrowser
		systemctl disable filebrowser >/dev/null 2>&1
		rm -rf /usr/bin/filebrowser
		rm -rf /etc/filebrowser
		rm -rf /lib/systemd/system/filebrowser.service
		echo -e " \n$greenuninstallation completed...$none\n" && exit 1
	else
		echo -e " \n$redyou did not install filebrowser$none\n" && exit 1
	fi
}
get_ip() {
	ip=$(curl -s ipinfo.io/ip)
}
error() {

	echo -e "\n$red input error！$none\n"

}
while :; do
	echo
	echo "Filebrowser one click installation"
	echo
	echo
	echo " 1. install"
	echo
	echo " 2. uninstall"
	echo
	read -p "choose[1-2]:" choose
	case $choose in
	1)
		install
		break
		;;
	2)
		uninstall
		break
		;;
	*)
		error
		;;
	esac
done




