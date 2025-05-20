# CPU TEMP PROMETHEUS EXPORTER

You can utilize this on any machine that is able to execute the `sensors` command with the help of the `lm-sensors` apt package

- `apt install lm-sensors`

## Installation

- Clone this repository onto the target machine
- Create a systemd service as root that will run the `cpu-exporter` file at system startup `nano /etc/systemd/system/prometheus-cpu-temperature-exporter.service`

```
[Unit]
Description=Exports CPU temps to port 9080 which is then scrapable by prometheus
After=network.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash /path/to/prometheus-cpu-temperature-exporter/prometheus-cpu-temperature-exporter.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
- Reload the systemctl daemon `systemctl daemon-reload`
- Then start the service `systemctl start prometheus-cpu-temperature-exporter.service`
- Check that the service is in active state `systemctl status prometheus-cpu-temperature-exporter.service`
- Now enable the service to run on startup `systemctl enable prometheus-cpu-temperature-exporter.service`
