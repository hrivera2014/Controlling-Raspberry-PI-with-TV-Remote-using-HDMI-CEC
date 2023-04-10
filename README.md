#Original work of:

https://ubuntu-mate.community/t/controlling-raspberry-pi-with-tv-remote-using-hdmi-cec/4250

Hello everyone.

#Description:

I wrote a script that connects to HDMI CEC ( cec-client needed ) and listens for TV Remote key presses. Based on the keys pressed / released (or auto-released; holding down certain keys for too long makes them auto-release) different actions are executed. Some examples:

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

