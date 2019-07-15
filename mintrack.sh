#!/bin/bash
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

if [ ! "$task" ]; then
    read -rp $'\033[33mTask:\033[0m ' task
fi

case "$task" in

    '' )
        echo -e "${red}task description is missing!${normal}"
        exit 1
        ;;

    '-i')
        echo -e "Install mintrack as ${yellow}'track'${normal} in ${yellow}$HOME/bin${normal}\n"

        read -p "Proceed? (Y/n) " installAnswer

        if [ "$installAnswer" == 'Y' ]; then
            cp -v ./mintrack.sh "$HOME/bin/track"
            chmod +x "$HOME/bin/track"
        else
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

