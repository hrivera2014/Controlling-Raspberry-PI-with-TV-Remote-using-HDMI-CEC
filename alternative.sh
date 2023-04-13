#!/bin/bash
function keychar {
    parin1=$1 #first param; abc1
    parin2=$2 #second param; 0=a, 1=b, 2=c, 3=1, 4=a, ...
    parin2=$((parin2)) #convert to numeric
    parin1len=${#parin1} #length of parin1
    parin2pos=$((parin2 % parin1len)) #position mod
    char=${parin1:parin2pos:1} #char key to simulate
    if [ "$parin2" -gt 0 ]; then #if same key pressed multiple times, delete previous char; write a, delete a write b, delete b write c, ...
        xdotool key "BackSpace"
    fi
    #special cases for xdotool ( X Keysyms )
    if [ "$char" = " " ]; then char="space"; fi
    if [ "$char" = "." ]; then char="period"; fi
    if [ "$char" = "-" ]; then char="minus"; fi
    xdotool key $char
}
datlastkey=$(date +%s%N)
strlastkey=""
intkeychar=0
intmsbetweenkeys=500 #two presses of a key sooner that this makes it delete previous key and write the next one (a->b->c->1->a->...)
intmousestartspeed=15 #mouse starts moving at this speed (pixels per key press)
intmouseacc=0 #added to the mouse speed for each key press (while holding down key, more key presses are sent from the remote)
intmousespeed=15
switch=0
browser=/etc/alternatives/x-www-browser
test -e /usr/bin/firefox && browser=firefox
test -e /usr/bin/chromium-browser && browser=chromium-browser


while read oneline
do
    keyline=$(echo $oneline | grep " key ")
    #echo $keyline --- debugAllLines
    if [ -n "$keyline" ]; then
        datnow=$(date +%s%N)
        datdiff=$((($datnow - $datlastkey) / 1000000)) #bla bla key pressed: previous channel (123)
        strkey=$(grep -oP '(?<=sed: ).*?(?= \()' <<< "$keyline") #bla bla key pres-->sed: >>previous channel<< (<--123)
        strstat=$(grep -oP '(?<=key ).*?(?=:)' <<< "$keyline") #bla bla -->key >>pressed<<:<-- previous channel (123)
        strpressed=$(echo $strstat | grep "pressed")
        strreleased=$(echo $strstat | grep "released")
        if [ -n "$strpressed" ]; then
            #echo $keyline --- debug
            if [ "$strkey" = "$strlastkey" ] && [ "$datdiff" -lt "$intmsbetweenkeys" ]; then
                intkeychar=$((intkeychar + 1)) #same key pressed for a different char
                intmousespeed=100
            else
                intkeychar=0 #different key / too far apart
            fi
            datlastkey=$datnow
            strlastkey=$strkey
            case "$strkey" in
                "1")
                    xdotool mousemove 270 154
                    ;;
                "2")
                    xdotool mousemove 679 154
                    ;;
                "3")
                    xdotool mousemove 1090 154
                    ;;
                "4")
                    xdotool mousemove 270 382
                    ;;
                "5")
                    xdotool mousemove 679 382
                    ;;
                "6")
                    xdotool mousemove 1090 382 
                    ;;
                "7")
                    xdotool mousemove 270 604 
                    ;;
                "8")
                    xdotool mousemove 679 604
                    ;;
                "9")
                    xdotool mousemove 1090 604 
                    ;;
                "0")
                    xdotool key Prior
                    ;;
                "previous channel")
                    xdotool key Space #Enter
                    ;;
                "channel up")
                    xdotool click 4 #mouse scroll up
                    ;;
                "channel down")
                    xdotool click 5 #mouse scroll down
                    ;;
                "channels list")
                    xdotool click 3 #right mouse button click"
                    ;;
                "up")
                    xgm=$(xdotool getmouselocation   --shell | grep Y | sed -e s/^..// ) 
                    intpixels=$((-1 * intmousespeed * 2))
                    test $switch -eq 1 && xdotool key Up || xdotool mousemove_relative -- 0 $intpixels #move mouse up
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    test $xgm$(xdotool getmouselocation   --shell | grep Y | sed -e 's/^..//' ) -eq 00 && xdotool mousemove_relative -- 0 768
                    ;;
                "down")
                    xgm=$(xdotool getmouselocation   --shell | grep Y | sed -e s/^..// ) 
                    intpixels=$(( 1 * intmousespeed))
                    test $switch -eq 1 && xdotool key Down || xdotool mousemove_relative -- 0 $intpixels #move mouse down
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    test $xgm$(xdotool getmouselocation   --shell | grep Y | sed -e 's/^..//' ) -eq 767767 &&  xdotool mousemove_relative -- 0 -768
                    ;;
                "left")
                    xgm=$(xdotool getmouselocation   --shell | grep X | sed -e s/^..// ) 
                    intpixels=$((-1 * intmousespeed * 2 ))
                    test $switch -eq     1 && xdotool key Left || xdotool mousemove_relative -- $intpixels 0 #move mouse left
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    test $xgm$(xdotool getmouselocation   --shell | grep X | sed -e 's/^..//' ) -eq 00 &&  xdotool mousemove_relative -- 1359 0
                    ;;
                "right")
                    xgm=$(xdotool getmouselocation   --shell | grep X | sed -e s/^..// ) 
                    intpixels=$(( 1 * intmousespeed))
                    test $switch -eq 1 &&  xdotool key Right || xdotool mousemove_relative -- $intpixels 0 #move mouse right
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    test $xgm$(xdotool getmouselocation   --shell | grep X | sed -e 's/^..//' ) -eq 13591359 && xdotool mousemove_relative -- -1359 0
                    ;;
                "select")
                    test $switch -eq 1 && xdotool key Return ||  xdotool click 1 #left mouse button click
                    ;;
                "return")
                    #xdotool key "Alt_L+Left" #WWW-Back
                    ((switch++))
                    test $switch -eq 2 && switch=0 
                    ;;
                "exit")
                    ((switch++))
                    test $switch -eq 2 && switch=0
                    ;;
                "F2")
                    ((menu++))
                    xdotool key  Escape
                    test $menu -eq 1 &&  xdotool click 3 || xdotool key Super_L
                    test $menu -eq 2 && menu=0
                    switch=1
                    ;;
                "F3")
                    $browser &
                    ;;
                "F4")
                    ((xvkbd++))
                    switch=0
                    xdotool mousemove 1100 750 
                    xvkbd -no-keypad  -geometry +905+560  &
                    test $xvkbd -eq 2 && killall xvkbd && xvkbd=0 
                    ;;
                "F1")
                    #chromium-browser --incognito "https://www.google.com" &
                    /etc/alternatives/x-terminal-emulator & 
                    ((xvkbd++))
                    switch=0
                    xdotool mousemove 1170 760 
                    xvkbd -no-keypad  -geometry +905+560  &
                    test $xvkbd -eq 2 && killall xvkbd && xvkbd=0

                    ;;
                "rewind")
                    $browser &
                    ;;
                "pause")
                    ((menu++))
                    xdotool key  Escape
                    test $menu -eq 1 &&  xdotool click 3 || xdotool key Super_L
                    test $menu -eq 2 && menu=0
                    switch=1
                    ;;
                "Fast forward")
                    /etc/alternatives/x-terminal-emulator & 
                    ((xvkbd++))
                    switch=0
                    xdotool mousemove 1170 660 
                    xvkbd -no-keypad  -geometry +905+560  &
                    test $xvkbd -eq 2 && killall xvkbd && xvkbd=0
                    ;;
                "play")
                    ((xvkbd++))
                    switch=0
                    xdotool mousemove 1100 750 
                    xvkbd -no-keypad  -geometry +905+560  &
                    test $xvkbd -eq 2 && killall xvkbd && xvkbd=0 

                    ;;
                "stop")
                    ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                    echo Key Pressed: STOP
                    ;;
                *)
                    echo Unrecognized Key Pressed: $strkey ; CEC Line: $keyline
                    ;;
                    
            esac
        fi
        if [ -n "$strreleased" ]; then
            #echo $keyline --- debug
            case "$strkey" in
                "stop")
                    xdotool key q
                    xdotool key Control_L+Next
                    ;;
                "up")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "down")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "left")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "right")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
            esac
        fi
    fi
done
