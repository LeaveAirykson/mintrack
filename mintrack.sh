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
normal="\033[0m"

task=$1
today=$(date '+%d-%m-%Y');
trackingfile="$HOME/.mintrack";
bincommand="$HOME/bin/track";

if [ ! "$task" ]; then
    read -rp $'\033[33m>\033[0m ' task
fi

function installMinTrack() {
        echo -e "This will install mintrack as ${yellow}$bincommand${normal}\n"

        read -p "Proceed? (Y/n) " installAnswer

        if [ "$installAnswer" == 'Y' ]; then
            cp -v ./mintrack.sh "$bincommand"
            chmod +x "$bincommand"
            touch "$trackingfile"
        else
            exit 1
        fi
}

function uninstallMinTrack() {
    rm -v "$trackingfile" "$bincommand"
}

case "$task" in

    '' )
        echo -e "${red}task description is missing!${normal}"
        exit 1
        ;;

    '-r')
        echo -e "${red}This will remove mintrack${normal}\n"
        read -p "Proceed? (Y/n) " uninstallAnswer

        if [ "$uninstallAnswer" == 'Y' ]; then
            if uninstallMinTrack; then
                echo -e "${green}Mintrack successfully removed!${normal}"
            fi
        fi

        ;;

    '-i')
        if [ ! -f "$bincommand" ]; then
            if installMinTrack; then
                echo -e "${green}Mintrack successfully installed!${normal}\n"
            fi
        else
            echo "Mintrack is already installed."
            exit 1
        fi
        ;;

    '-l')
        cat "$trackingfile"
        ;;

    '-e' )
        echo '' > "$trackingfile"
        echo -e "${green}emptied $trackingfile${normal}"
        ;;

    * )
        echo -e "$today : $task" >> "$trackingfile"
        echo -e "${green}tracked task${normal}"
        ;;
esac

