Manually install  
nano /lib/systemd/system/filebrowser.service  
<pre>
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
</pre>







nano /etc/filebrowser/filebrowser.json  
<pre>
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
</pre>















download filebrowser to /usr/bin/  
cd /usr
cd bin  
wget https://github.com/vpslinuxinstall/Filebrowser/blob/master/filebrowser
  
systemctl enable filebrowser    
systemctl start filebrowser  








<br>








</br>








Automatically install                  
wget https://github.com/vpslinuxinstall/Filebrowser/blob/master/filebrowser.sh
  
chmod +x filebrowser.sh  
./filebrowser.sh




































