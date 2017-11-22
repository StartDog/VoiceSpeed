#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

function mye {
	echo $1 | festival --tts
	echo $1 >/dev/console
}

cd /root

if [ -f /root/BADOBDDATA ] ;
then
mv /home/root/pyobd-pi/log/*.log /home/root/pyobd-pi/log/oldlog/
rm -f /root/BADOBDDATA
rfcomm bind 0 00:06:71:00:00:06
fi

rfcomm bind 0 00:06:71:00:00:06


while (true)
do


if [ -f /root/IAMHOME ] ;
then

if [ -f /root/BADOBDDATA ] ;
then
mv /home/root/pyobd-pi/log/*.log /home/root/pyobd-pi/log/oldlog/
rm -f /root/BADOBDDATA
rfcomm bind 0 00:06:71:00:00:06
sync
sleep 30
fi

sleep 69

else

python /root/pyobd-pi/obd_recorder.py

sleep 60

fi

done

