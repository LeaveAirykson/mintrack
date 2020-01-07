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
dim="\033[2m"
bold="\033[1m"

task=$1
today=$(date '+%Y-%m-%d');
trackingdir="$HOME/.mintrack";
bincommand="$HOME/bin/track";
stamp=$(date +"%s");
gitrepo="https://raw.githubusercontent.com/LeaveAirykson/mintrack/master/mintrack.sh?nocache=${stamp}"

# make sure we create the tracking dir if
# it does not exist yet
if [[ ! -d "$trackingdir" ]]; then
    mkdir -p "$trackingdir"
fi

# ask for a task if nothing is given
if [ ! "$task" ]; then
    echo -e "${bold}Put in a task${normal}"
    echo -e "Use -h to show help."
    read -r -e -p $'\033[33m>\033[0m ' task
fi

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

function showLastTracking() {
    filename=$(ls -rt $trackingdir | tail -1);
    echo -e "${yellow}$filename:${normal}"
    cat "$trackingdir/$filename"
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
        echo -e "${bold}Put in a date ${normal}(MM-DD-YYYY)"
        read -r -e -p $'\033[33m>\033[0m ' date
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

function update {
    echo -e "\ntrying to update from: ${gitrepo}\n"
    if curl -LJ -H 'Cache-Control: no-cache' "${gitrepo}" > "$bincommand"; then
        echo -e "${green}Mintrack successfully updated!${normal}\n"
    fi
}

function showHelp {
    echo -e "\n${yellow}Mintrack Help${normal}"
    echo -e "Mintrack is a minimal file based work tracker.\n"
    echo -e "${yellow}Available options${normal}"
    echo -e "${bold}-i\n  ${normal}Installs mintrack as a terminal command\n"
    echo -e "${bold}-r\n  ${normal}Uninstalls mintrack\n"
    echo -e "${bold}-u\n  ${normal}Updates mintrack\n"
    echo -e "${bold}-l\n  ${normal}List trackings\n"
    echo -e "${bold}-d ${normal}[MM-DD-YYYY] [task]\n  Use different date than today"
    echo -e "  Example: track -d 02-30-2019 \"Waldhof Release v1.16.0\"\n"
    echo -e "${bold}-e${normal}\n  Empty all trackings\n"
    echo -e "${bold}-h${normal}\n  Show this help\n"
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
    '-a')
        listTrackings
        ;;
    # show current tracking
    '-l')
        showLastTracking
        ;;

    # empty tracking dir
    '-e')
        emptyTrackingDir
        ;;

    '-h')
        showHelp
        ;;

    '-u')
        update
        ;;

    * )
        writeTracking "$today" "$task"
        ;;
esac

