#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

[[ $(id -u) != 0 ]] && echo -e " \n请使用 ${red}root ${none}用户运行 ${yellow}${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

# 检测ubuntu centos 
if [[ -f /usr/bin/apt-get || -f /usr/bin/yum ]] && [[ -f /bin/systemctl ]]; then

	if [[ -f /usr/bin/yum ]]; then

		cmd="yum"

	fi

else

	echo -e " \n ${red}脚本${none} 支持的系统是linux ${yellow} ${none}\n" && exit 1

fi

if [[ $sys_bit == "i386" || $sys_bit == "i686" ]]; then
	filebrowser="linux-386-filebrowser.tar.gz"
elif [[ $sys_bit == "x86_64" ]]; then
	filebrowser="linux-amd64-filebrowser.tar.gz"
else
	echo -e " \n$red脚本支持的系统是linux $none\n" && exit 1
fi

install() {
	$cmd install wget -y
	ver=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep 'tag_name' | cut -d\" -f4)
	Filebrowser_download_link="https://github.com/filebrowser/filebrowser/releases/download/$ver/$filebrowser"
	mkdir -p /tmp/Filebrowser
	if ! wget --no-check-certificate --no-cache -O "/tmp/Filebrowser.tar.gz" $Filebrowser_download_link; then
		echo -e "$red 下载 Filebrowser 失败！$none" && exit 1
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
  "noAuth": false,
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
		Filebrowser 安装完成

		预览地址: ${yellow}http://${ip}:8300/admin$none

		用户名: ${green}admin$none

		密码: ${green}admin$none

		$red请修改登录信息$none

		
		"
	else
		echo -e " \n$red安装失败...$none\n"
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
		echo -e " \n$green卸载完成...$none\n" && exit 1
	else
		echo -e " \n$red你的系统没有安装filebrowser$none\n" && exit 1
	fi
}
get_ip() {
	ip=$(curl -s ipinfo.io/ip)
}
error() {

	echo -e "\n$red 输入错误！$none\n"

}
while :; do
	echo
	echo "Filebrowser one click installation"
	echo
	echo
	echo " 1. 安装"
	echo
	echo " 2. 卸载"
	echo
	read -p "请选择[1-2]:" choose
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




