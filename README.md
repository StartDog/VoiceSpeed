# VoiceSpeed
(Not all files have been placed on github yet)
Connects to GPS and OBDII and announces your speed and direction of heading.
While at home (or when you get home) it uploads all the Wifi it has scanned 
and all your gps locactions up to a server. It does not announce when it
thinks it is home. It determines it is home by the wifi.  If is sees your SSID
it connects to it and starts pinging ipv4 ips.  When it sees the server it
connects via sftp and uploads its data.  It decides you are not longer at your
home location by losing pings. WHen it does that it begins to scan wifi and
gps and announces again. The heading is from the GPS data and is only valid 
if you are moving. Still in experimental/test mode.  I downloaded the female
voice for festival as it is more pleasant. Personal preference I guess. The 
default festival voice is a male. The ODBII and GPS speeds are not always the
same and there is a bit of a delay in the announce. Maybe an xy accelerometer
could be incorporated too.

Requirements
1. pyobd  https://github.com/Pbartek/pyobd-pihttps://github.com/Pbartek/pyobd-pi
This gets the OBDII data from the dongle connected to the car's bus

2. OBDII bluetooth device
This is the dongle

3. festival Text to speech software great stuff to me
http://festvox.org/festival/  Might be available with raspbian through apt install

4. GPS daughterboard for RPI

5. wifi USB dongle - not sure of later RPI have this built in

6. bluetooth USB dongle - not sure if late RPI have this built in I know RPI zero W has wifi

7. Raspberry Pi

misc other stuff
rpi case, powersupply, battery, battery charger and speakers with rpi compatible plug
I use a battery of sufficient power to keep the RPI and associated hardware running for
about 30 hours.  The RPI and dongles and GPS daughter board suck up a lot of power.

The below might work for OBDII interface:
Car WIFI OBD 2 OBD2 OBDII Scan Tool Foseal Scanner Adapter Check Engine Light Diagnostic Tool for iOS & Android 



