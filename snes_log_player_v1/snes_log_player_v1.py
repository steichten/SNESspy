from serial import tools
from serial.tools.list_ports import grep
import time
import sys
import serial

#establish serial connection
ser = serial.Serial('/dev/tty.usbmodem31871',57600)
print ser 
print "###############################################"
print "# SNES Log Player v1"
print "# Requires: snes_player_v1 Teensy code"
print "# Log: ",sys.argv[1]
print "###############################################"

time.sleep(2)
file=open(sys.argv[1], "r")
file.readline() #dump the header line

if ser.isOpen():
    try:
        ser.flushInput() #flush input buffer, discarding all its contents
        ser.flushOutput()#flush output buffer, aborting current output 
        print "Port is open."
    except:
        print "Port is closed."
        ser.close()
        sys.exit()
print "Preparing serial connection..."    
framecount=0  
#sleep to make sure serial is good to go
time.sleep(0.5)

#read through the file line by line and send the controller status
for line in file:
    getit=0
    print 'Frame Count: ',framecount, '\r',
    try:
        ser.flushInput()
        ser.flushOutput()
    except:
        print "Error in serial connection!"
        ser.close()
    current=line.split("\t")[1]; #dump the timestamp
    current=current.rstrip(); #dump any additional line info
    #prep the controller status into two bytes to send
    #Skip the 4 fixed HIGH values (SNES clock cycles 13-16)
    tosend=bytearray([int(current[8:16],2),int(current[4:8],2)])
    ser.write(tosend) #send it over

    while getit==0: #wait to hear back from the Teensy that it wants another cycle
        if ord(ser.read())==1:
            getit=1
        
    framecount+=1 #add up framecount

print "###############################################"
print "# Logfile readout complete"
print "# Total controller queries: ", framecount
print "# Serial Connection Closed"
print "###############################################"
ser.close()