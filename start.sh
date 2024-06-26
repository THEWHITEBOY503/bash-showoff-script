#!/bin/bash
# Hello :) Welcome to my cool showoff script
# Revision: 7

## --- Username Selection ---
## Grabs your username from Bash $USER variable
## Example UNIX username: conner
## Select 1 to capitalize the first letter. Output: Conner
## Select 2 to keep the username as it is. Output: conner
## Add quotation marks to manually specify a name. Output: HamBurger
USERGRAB=1
if [ $USERGRAB = 1 ]; then
    USER="$(tr '[:lower:]' '[:upper:]' <<< ${USER:0:1})${USER:1}"
elif [ $USERGRAB = 2 ]; then
    user=$USER
else
    USER=$USERGRAB
fi

# Configure your options here. These are the options I used on my laptop, provided as an example/placeholder.
DEVICE="Laptop"
DISTRO="Ubuntu Linux"
MODEL="Dell Latitude 7490"
WTROPTIONS="2FnQ"
MOONOPTIONS="F"
# If your distro doesn't support the `command` comand, enable this option to skip the curl check. Remember to install curl manually!
skip_curl_check=false
WTRSIDE=true
# Automatically grab the amount of megabytes of RAM. If you'd like to lie-- I mean manually specify the amount of RAM, comment this line and uncomment the one below it.
RAM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))"M"
#RAM="32036M"
CITY="Dallas"
ANIMATE=true
SLEEP=0.05

# Path to where you want to keep the wtr and moon files
wtr_path="/home/conner/.scripts/wtr"
moon_path="/home/conner/.scripts/moon"

# This part creates the color bars. Feel free to change the numbers for the colors, this is your software now :)
# If ANIMATE is true, this part animates. If not, it just displays the logo. You can also change the sleep time with $SLEEP.
clear
if [ "$ANIMATE" = true ] ; then
    echo -e "\e[101m          \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    echo -e "\e[106m    \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m"
    echo -e "\e[103m        \e[0m"
    echo -e "\e[102m      \e[0m"
    echo -e "\e[106m    \e[0m"
    echo -e "\e[105m  \e[0m"
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $USER's $DEVICE"
    echo -e "\e[103m        \e[0m   "
    echo -e "\e[102m      \e[0m   "
    echo -e "\e[106m    \e[0m   "
    echo -e "\e[105m  \e[0m   "
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $USER's $DEVICE"
    echo -e "\e[103m        \e[0m     $DISTRO"
    echo -e "\e[102m      \e[0m   "
    echo -e "\e[106m    \e[0m   "
    echo -e "\e[105m  \e[0m   "
    sleep $SLEEP
    clear
    echo -e "\e[101m          \e[0m   $USER's $DEVICE"
    echo -e "\e[103m        \e[0m     $DISTRO"
    echo -e "\e[102m      \e[0m       "
    echo -e "\e[106m    \e[0m         $MODEL"
    echo -e "\e[105m  \e[0m           $RAM OK"
else
    clear
    echo -e "\e[101m          \e[0m   $USER's $DEVICE"
    echo -e "\e[103m        \e[0m     $DISTRO"
    echo -e "\e[102m      \e[0m       "
    echo -e "\e[106m    \e[0m         $MODEL"
    echo -e "\e[105m  \e[0m           $RAM OK"
fi

echo "Hello, $USER."
echo
TODAY=$(date +"Today's date is %A, %B %d %Y.")
TIMENOW=$(date +"The local time is %r")
echo $TODAY
echo $TIMENOW
echo
# Function to check if the computer is online so it doesn't waste time trying to redownload the weather file
check_online() {
    if ping -c 1 $1 &> /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}
host="google.com"
if check_online $host; then
    online=true
else
    online=false
fi

check_curl() {
    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing..."
        # Determine the package manager based on the distribution
        if command -v apt-get &> /dev/null; then
            sudo apt-get install curl
        elif command -v yum &> /dev/null; then
            sudo yum install curl
        elif command -v dnf &> /dev/null; then
            sudo dnf install curl
        elif command -v pacman &> /dev/null; then
            sudo pacman -S curl
        elif command -v brew &> /dev/null; then
            sudo brew install curl
        else
            echo "Unable to determine the package manager. Please install curl manually, or set skip_curl_check to false at the top section of the file."
            return 1
        fi
    else
        echo "curl is already installed." &> /dev/null
    fi
}
if [ $skip_curl_check = true ]; then
    CC=true
else
    check_curl
fi
if [ $? -eq 0 ]; then
    CC=true
else
    CC=false
fi
# Skips past the weather part if curl is still not installed after the above script (Only likely if running for the first time and you dont have one of the package managers above)
if [ "$CC" = true ]; then
    # Checking if the wtr and moon files exist
    if [ -e "$wtr_path" ]; then
        # Get the wtr file's modification time in seconds
        modification_time=$(date -r "$wtr_path" "+%s")

        # Get the current time in second
        current_time=$(date "+%s")

        # Calculate the time difference in seconds
        time_difference=$((current_time - modification_time))

        # Check if the file is older than 12 hours (43200 seconds)
        if [ "$time_difference" -gt 43200 ]; then
            # If the time is different, download a new copy of the file
            curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
            curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
            # Easter egg-- Hello from the dev! Thanks for taking a look at my (shitty) software. <3 -CS
        else
            # The file's already new enough, so we don't need to download an updated version.
            # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
            echo "File is already new." &>/dev/null
        fi
    else
        # File not found, so downloading the file.
        # Remove the &>/dev/null if you want it to log on the splash screen (for whatever reason)
        echo "Downloading new moon and wtr files" &>/dev/null
        if [ "$online" = true ]; then
            curl -s wttr.in/$CITY?$WTROPTIONS > $wtr_path
            curl -s wttr.in/moon?$MOONOPTIONS > $moon_path
        fi
    fi
    echo
    if [ -e "$wtr_path" ]; then
        # Calculate the time since last update in hours
        hours=$(( (current_time - modification_time) / 60 / 60))
        # This statement decides whether to say 'hour' or 'hours'
        if [ $hours = 1 ]; then
            LAST="(As of $hours hour ago)"
        else
            LAST="(As of $hours hours ago)"
        fi
        echo "Here's the weather in $CITY $LAST:"
        # Display the content of the files side by side
        # If you'd rather they display on top of each other, change $WTRSIDE at the top of the file to false
        if [ "$WTRSIDE" = true ]; then
            paste $wtr_path $moon_path | column -s $'\t' -t
        else
            cat $wtr_path
            cat $moon_path
        fi
    fi
fi
# Put whatever other commands you want to run here.
# neofetch
fastfetch 
