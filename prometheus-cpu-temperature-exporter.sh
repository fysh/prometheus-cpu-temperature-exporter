#!/bin/bash

PORT=9080

while true; do
  {
    # Пытаемся получить температуру через sensors
    TEMP=$(sensors 2>/dev/null | grep "high" | grep "Core" | cut -d "+" -f2 | cut -d "." -f1 | sort -nr | sed -n 1p)

    # Если не удалось, пробуем thermal_zone0
    if [[ -z "$TEMP" ]]; then
      RAW_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
      if [[ "$RAW_TEMP" =~ ^[0-9]+$ ]]; then
        TEMP=$(echo "scale=1; $RAW_TEMP / 1000" | bc)
      else
        TEMP="0"
      fi
    fi

    RESPONSE="# HELP server_cpu_temp CPU temperature in Celsius
# TYPE server_cpu_temp gauge
server_cpu_temp ${TEMP}"

    echo -e "HTTP/1.1 200 OK\r"
    echo -e "Content-Type: text/plain; version=0.0.4\r"
    echo -e "Content-Length: ${#RESPONSE}\r"
    echo -e "\r"
    echo -e "${RESPONSE}"
  } | nc -l -p $PORT -q 1
done

