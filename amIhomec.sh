#!/bin/bash

# this is the main loop of the voicespeed
# it gets data from other running code
#
# bluetooth data
# gps data
# wifi data
#
# it requires festival and gpsd and pyobd to be installed

# raspberry pi with GPS hat
# external bluetooth OBDII plugged into the car
# wifi dongle capable of scanning

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

function mye {
	echo $1 | festival --tts
	echo $1 >/dev/console
}


mye "Starting the why Fye and GPS logging function"

# things that need to be set to your values
export home-wifi="api-of-home-sifi"
export home-pass="thisismypassword"
export odbii-add="00:06:71:00:00:06"
export SERVER="192.168.10.100"

sleep 100

counter=1;

mye "Network Manager startup"

/usr/sbin/NetworkManager

sleep 51

mye "checking for home wye fye"

nmcli --nocheck d wifi connect $home-wifi password $home-pass

sleep 5

/sbin/ifconfig wlan0 promisc

zerov=false

cd /root

# start over on a boot
rm -f /root/IAMHOME

mye "trying to connect to blue tooth"

# below is for bluetooth connection to ODBII thing
rfcomm bind 0 $odbii-add

find /home/root/pyobd-pi/log -size -39 -delete 

sleep 6

/bin/sync

# ip of a pingable server on the local network

#main loop

mye "Entering main loop"

while (true)
do

# problem below - hardwiring the ip which changes!
ping $SERVER -c 4 2>/dev/null 1>/dev/null
if [ $? -eq 0 ]  ;
then

# if the IAMHOME file exists already then do nothing
if [ -f /root/IAMHOME ] ;
then

echo already there >/dev/null

counter=$((counter+1))

if [ "$counter" -gt 20 ] ;
then
mye "I am in at home processing mode"
counter=0

fi

else

# else create it and move the wifi here file to 178

mye "I am starting the data copy"

touch /root/IAMHOME

if [ -f whatWifiIsHere ] ; then

mv whatWifiIsHere wwih_$(date +%F-%T)

/root/deleteolder.sh

/bin/sync

/root/copyfile.sh

fi

mye " I am finished with the data copy"

fi


else

if [ -f /root/IAMHOME ] ;
then

mye "We must be out of the range of home"

rm -f /root/IAMHOME

sleep 7

echo "`date` away from home now" >>whatWifiIsHere

fi


temp=`nmcli dev wifi list | grep $home-wifi | awk '{ print $1 }'`
if [ "$temp" = $home-wifi ];
then

mye "trying to connect to home wye fye"

nmcli d wifi connect $home-wifi password $home-pass

sleep 8

atemp=`nmcli general| grep connected`
if [ $? -eq 0 ]; then


mye " We may be home now, I see the home why fye "

echo "`date` may be home now" >>whatWifiIsHere

fi

else

# do the below when out of range of home and driving around

/usr/local/bin/gpspipe -r localhost:10000 | head -10 | grep GPRMC >>whatWifiIsHere
nmcli dev wifi list >>whatWifiIsHere

tempa=`tail -2 whatWifiIsHere`

tempc="Starbucks"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "There may be a Starbucks nearby!"
fi

tempc="WSU-Secure"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "We are at Wright State University now"
fi

tempc="WiFi@OSU"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "We might be near The Ohio State University now"
fi

tempc="OHIO University"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "We might be near Ohio University in Athens now"
fi

tempc="x"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "I see the Hotspot why fye"
fi

tempc="Tim Hortons"
if [[ "$tempa" == *"$tempc"* ]]; then
mye "We might be near a Tim Hortons"
fi

/bin/sync

####################################


export aa=`/usr/local/bin/gpspipe -r localhost:10000 | head -10 | grep GPRMC `

export gpspeed=`echo $aa  | grep GPRMC | awk -F, '{ print $8  }' | tail -1`
export gpsdir=`echo $aa  | grep GPRMC | awk -F, '{ print $9  }' | tail -1`

# times by 6076 and divide by 5280 knots to mph
gpspeed=`echo \($gpspeed*6076\)/5280 | bc`

# truncate float to int
export tgpspeed=${gpspeed%.*}
export tgpsdir=${gpsdir%.*}

if [ "$tgpspeed" -gt "10" ] ; then
echo "gps speed is " "$tgpspeed" | festival --tts
fi

cd /home/root/pyobd-pi/log

tempb=`ls -tr  | tail -1`

tempa=`tail -1 $tempb | awk -F, '{ print $3  }' | awk -F. '{ print $1 }'`

if [ "$tempa" != "MPH" ] && [ "$tempa" != "NODATA" ] && [ "$tempa" != ""  ] ; then

#echo $tempa >>/root/debug.out

if [ "$tempa" = "0" ] ; then
zerov=true
fi

if [ "$tempa" -gt "6" ] ; then
echo "bluetooth speed is " $tempa | festival --tts
fi

if [ "$tempa" -gt "75" ] ; then
mye "you are driving too fast"
fi

echo "your azmuth is " $tgpsdir " degrees" | festival --tts

if [ "$tgpsdir" -lt "11" ]  || [ "$tgpsdir" -gt "348" ] ; then 
mye "Heading North"
fi

if [ "$tgpsdir" -lt "191" ] ; then
if [ "$tgpsdir" -gt "168" ] ; then
mye "Heading South"
fi
fi

if [ "$tgpsdir" -lt "78" ] ; then
if [ "$tgpsdir" -gt "101" ] ; then
mye "Heading East"
fi
fi

if [ "$tgpsdir" -lt "281" ] ; then
if [ "$tgpsdir" -gt "258" ] ; then
mye "Heading West"
fi
fi

if [ "$tempa" -gt "200" ] ; then
mye "Bad data - am restarting bluetooth"
/bin/sync
rfcomm release 0
sleep 60
/bin/sync
touch /root/BADOBDDATA
/bin/sync
/bin/sync
fi

fi

cd /root

#############

fi


fi

sleep 37

done

