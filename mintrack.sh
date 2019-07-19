#!/bin/bash
# shellcheck disable=SC2162
#
# ==================================
# COLORS
# ==================================
# terminal formats
green="\033[32m"
red="\033[31m"
yellow="\033[33m"
gray="\033[90m"
normal="\033[0m"
bold="\033[1m"

task=$1
today=$(date '+%m-%d-%Y');
trackingdir="$HOME/.mintrack";
bincommand="$HOME/bin/track";

# task for an option if nothing is given
if [ ! "$task" ]; then
    echo -e "${bold}Put in a task${normal}"
    read -rp $'\033[33m>\033[0m ' task
fi

function installMinTrack() {

    function placeFiles() {
        cp -v ./mintrack.sh "$bincommand"
        chmod +x "$bincommand"
        mkdir -p "$trackingdir"
    }

    # Allow first installs and forced installs with -f
    if [ -f "$bincommand" ] && [ ! "$1" = '-f' ]; then
        echo "Mintrack is already installed. Use -f to force reinstall."
        exit 1
    fi

    # ask if user wants to proceed with install
    echo -e "\nThis will install mintrack as ${yellow}$bincommand${normal}\n"
    read -p "Proceed? (Y/n) " installAnswer

    # place files and output success
    # if user accepts
    if [ "$installAnswer" == 'Y' ]; then
        if placeFiles; then
            echo -e "${green}Mintrack successfully installed!${normal}\n"
        fi
    else
        exit 1
    fi
}

function uninstallMinTrack() {
    echo -e "${red}Warning: This will remove mintrack and ALL its data!${normal}\n"
    read -p "Proceed? (Y/n) " uninstallAnswer

    if [ "$uninstallAnswer" == 'Y' ]; then
        if rm -vr "$trackingdir" "$bincommand"; then
            echo -e "${green}Mintrack successfully removed!${normal}"
        fi
    fi
}

function listTrackings() {
    trackingfiles=$(ls "$trackingdir")

    for file in $trackingfiles
    do
        echo -e "${yellow}$(basename "$file"):${normal}"
        cat "$trackingdir/$file"
        echo ""
    done
}

function writeTracking {

    trackingfile="$trackingdir/$1"

    if [ ! -f "$trackingfile" ]; then
        touch "$trackingfile"
    fi

    if echo -e "- $2" >> "$trackingfile"; then
        echo -e "\n${green}tracked task '${normal}$2${green}' on${normal} $1\n"
    fi
}

function writeTrackingForDate() {
    # assume $1 is a date string
    date=$1
    # assume $2 is the task name
    taskname=$2

    # stop if $2 doesnt start with a number
    if [ ! "$date" ] || [[ ! "$date" =~ ^[0-31] ]]; then
        echo -e "${bold}Put in a date ${normal}${gray}(MM-DD-YYYY)${normal}"
        read -rp $'\033[33m>\033[0m ' date
        echo ""
    fi

    # stop if $2 is empty
    if [ ! "$taskname" ]; then
        echo -e "${bold}Put in a task${normal}"
        read -rp $'\033[33m>\033[0m ' taskname
    fi

    # write track if everything is fine
    writeTracking "$date" "$taskname"
}

function emptyTrackingDir {
    echo -e "${red}Warning: This will remove ALL tracked data!${normal}\n"
    read -p "Proceed? (Y/n) " emptyAnswer

    if [ "$emptyAnswer" = 'Y' ]; then
        if rm -r "$trackingdir" && mkdir "$trackingdir"; then
            echo -e "${green}emptied $trackingdir${normal}"
        fi
    fi
}

case "$task" in

    # exit if no parameter is given
    '' )
        echo -e "${red}Error: missing task!${normal}"
        exit 1
        ;;

    # uninstall
    '-r')
        uninstallMinTrack
        ;;

    # install
    '-i')

        installMinTrack "$2"
        ;;

    # use a different date
    '-d')
        writeTrackingForDate "$2" "$3"
        ;;

    # list all trackings
    '-l')
        listTrackings
        ;;

    # empty tracking dir
    '-e' )
        emptyTrackingDir
        ;;

    * )
        writeTracking "$today" "$task"
        ;;
esac

