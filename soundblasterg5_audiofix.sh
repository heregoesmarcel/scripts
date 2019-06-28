#! /bin/sh

# Wait for pulseaudio to boot up
sleep 10
for i in 'seq 1 3';
do
  # su -c "/usr/bin/pulseaudio --check" <username> # This won't work if pulseaudio isn't deamonized (e.g. in Manjaro on default)
  ps -A | grep pulseaudio > /dev/null
  if [ $? -eq 0 ]; then
    echo "Pulseaudio found, restoring alsactl configuration..."
    # Restore pre-saved alsactl configuration (Note: Try manually storing your config at this location if the script won't work)
    /usr/bin/alsactl restore -f /etc/asound.state
    exit 0
  elif [ $i -eq 3 ]
  then
    #printf "Could not find an active pulseaudio session, aborting script..." | tee -a $LOGFILE
    echo "Could not find an active pulseaudio session, aborting script..."
    exit 1
  else
    echo "Pulseaudio not ready yet, trying again..."
    sleep 10
  fi
done
