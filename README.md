## SNESspy
This is a series of scripts to allow recording of Super Nintendo controller inputs.

These scripts are designed to be used along side a Teensy controller signal intercept/player.

Scripts are written in Python 2.7


![Alt text](https://dl.dropboxusercontent.com/u/4289891/snesspy.png "Overview of Programs (red indicates work in progress)")

#Background
This controller intercept works by tapping into the LATCH, CLOCK, and DATA pins of the controller. 
The SNES controller works by having the latch pin drop to begin a controller status check ever 50/60Hz or so. 
The SNES then checks the DATA pin to determine the status of the first button (B). High (1) indicates not 
pressed and Low (0) indicates it is currently pressed The CLOCK pin raises and the DATA pin is checked for 
the next button. This process is repeated 16 times (even though there are only 12 buttons on a SNES controller) 
before the LATCH rises and the process starts again.

The order of the buttons is as follows:  

1 B  
2 Y  
3 Select  
4 Start  
5 Up  
6 Down  
7 Left  
8 Right  
9 A  
10 X  
11 L  
12 R  
13 NA  
14 NA  
15 NA  
16 NA  


The intercept works to follow the LATCH, CLOCK, and DATA pins and dump the DATA value into a 16 bit integer:

1111111111111111   (no buttons are being pressed this cycle)
NA            …             B

This integer is passed through the USB serial connection for visualization / logging

A video demo of Super Mario World can be found here: https://www.youtube.com/watch?v=tM1_7EJFPM4
#Controller intercept
