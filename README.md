Manually install  
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







<pre>
nano /etc/filebrowser/filebrowser.json  
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
<pre>














