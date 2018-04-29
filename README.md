# filebrowser
nano /lib/systemd/system/filebrowser.service

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
