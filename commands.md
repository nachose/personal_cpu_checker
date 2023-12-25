
Service file must be copied to:
`/etc/systemd/system/cpu_monitor.service`

Reload service:
`sudo systemctl daemon-reload`

Start and enable service:
`sudo systemctl start cpu_monitor.service
sudo systemctl enable cpu_monitor.service`

Check service status.
`/etc/systemd/system/cpu_monitor.servicesudo systemctl status cpu_monitor.service`


This will start your script as a service managed by systemd, ensuring it runs in the background and automatically starts on system boot.

Remember to replace /path/to/your/cpu_monitor.sh with the actual path to your cpu_monitor.sh script. Adjust permissions accordingly to ensure the script and service files are executable by the appropriate users.


