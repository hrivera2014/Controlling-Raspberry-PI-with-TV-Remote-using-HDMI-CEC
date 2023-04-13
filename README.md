#Original work of:

https://ubuntu-mate.community/t/controlling-raspberry-pi-with-tv-remote-using-hdmi-cec/4250

Hello everyone.

#Description:

I wrote a script that connects to HDMI CEC ( cec-client needed ) and listens for TV Remote key presses. Based on the keys pressed / released (or auto-released; holding down certain keys for too long makes them auto-release) different actions are executed. Some examples:
![remotecontrol](https://user-images.githubusercontent.com/12376668/231612995-ae14a26a-67d7-41bc-a6d3-4ceef471c747.png)

    write letters and numbers using 0-9 keys (simulating 3x4 keypad phones - key "2" switches between a-b-c-2, key 9 switches between w-x-y-z-9) ( xdotool needed )
    move mouse cursor using up/down/left/right (the longer you hold the key down, the faster it goes) and click (enter = left click; channels list = right click) ( xdotool needed )
    opening web sites in chomium (red key for YouTube, green for Google, blue for incognito window)

If you want to use firefox instead of chromium, replace "chromium" with "firefox" in the script below.
Alternatively, you can just install chromium:

`sudo apt-get install chromium-browser`

These are the keys supported by my TV Remote. You can modify the script for your TV Remote, see Modification below.

#Installation:
First you need to install cec-client and xdotool; using terminal:

`sudo apt-get install cec-client xdotool`

Test if you can receive TV Remote button presses with cec-client; using terminal:

cec-client

You should see some diagnostic messages. Press numeric keys (as they are most likely to be supported) on your TV Remote. Watch out for new lines, especially of this form:

something something **key pressed: 8** something something

If you see this kind of messages, then this should work for you.
If not, make sure you've got CEC enabled on your TV (see this WIKI 162 for more info).
For my TV, pressing the Source button a couple of times helped (so it kind-of flips trough all the sources and circles back to the Raspberry Pi, detects CEC and connects to it).

So, on to the script / installation:
Create the file cecremote.sh and mark it as executable; using terminal:

´touch cecremote.sh´
´chmod +x cecremote.sh´
Finally, save it; using nano in terminal:
press "Ctrl+X" to close the file, then "Y" to confirm saving, then "Enter" to save the file under the right file name

Try executing it, using terminal:

cec-client | ./cecremote.sh

At this point it should be working.
Point the TV Remote at the TV, press up/down/left/right and check if the mouse pointer is moving.
Press 9 44 2 8 7777 0 88 7 and it should write "whats up".

The script doesn't output anything, except when it encounters a button press that it doesn't recognize, or it doesn't have a function set up for that button yet (play button being one of them).
If you want it to output all the messages it receives, find the line and uncomment it by deleting the # : #echo $keyline --- debugAllLines

So, if everything works, exit the script in terminal: Press Ctrl+C

Run at startup:
If you want to start this script every time the Raspberry starts, create a new file called cecremotestart.sh and mark it as executable; using terminal:

touch cecremotestart.sh
chmod +x cecremotestart.sh

Then open it; using terminal:

nano cecremotestart.sh

Copy - paste this in the file:

#!/bin/bash
cec-client | /home/raspberry/cecremote.sh #<-- change this according to your username / path to the script

Finally, save it; using nano in terminal:
press "Ctrl+X" to close the file, then "Y" to confirm saving, then "Enter" to save the file under the right file name

Then add this in the Startup Programs (Menu - System - Control Center - Startup Programs; Add; Give it a name, and enter the path (or press Browse) of the script in the filesystem).

Restart, try, report :slightly_smiling:

Modification:
If you want, you can edit the script to change or add the commands executed on certain button presses.
You can detect the additional buttons that CEC on your TV supports. Kill the running cec-client, run the cec-client in the terminal, and watch for the output while you're pressing all the keys on your TV Remote; using terminal:

killall cec-client
cec-client
Ctrl+C when you're ready to stop

Edit the script, then execute the modified script by manually executing cecremotestart.sh; using terminal:

./cecremotescript.sh
Ctrl+C to stop

When you're satisfied, just restart your Raspberry PI.

That's it from me - a simple and crude way to control your Raspberry PI with the TV Remote, for when you don't have the keyboard/mouse connected and VNC-ing is too much of a bother.

Try it and report :slightly_smiling:
