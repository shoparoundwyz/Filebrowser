#!/bin/bash
wget -P /usr/bin/ https://github.com/vpslinuxinstall/Filebrowser/releases/download/v2.0/filebrowser
chmod +x /usr/bin/filebrowser
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

systemctl enable filebrowser
systemctl start filebrowser



















