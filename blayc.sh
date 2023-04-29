#! /bin/bash

#stty intr $'\e'

music=""

red="\e[0;91m"
blue="\e[0;94m"
uline="\e[4m"
reset="\e[0m"
# expand_bg="\e[K"
# blue_bg="\e[0;104m${expand_bg}"
# red_bg="\e[0;101m${expand_bg}"
# green_bg="\e[0;102m${expand_bg}"
# green="\e[0;92m"
# white="\e[0;97m"
# bold="\e[1m"

query_and_process () {
    read -rp ":: Play: " song_to_play
    song=${song_to_play//\ /?}
}

find_audio () {
    # if music location variable specified, search through it
    # if not, search in the default music directory
    if [[ -n "$music" ]]; then
        play=$(find "$music" -type f -iname "*$song*")
    else
        play=$(find "$HOME/Music" -type f -iname "*$song*")
    fi
}

audio_not_found () {
    sleep 0.2
    echo -e "${red}:: Error:${reset}"	   
    echo "    Audio not found"	   
    sleep 0.2
    echo "==> Please refer to the README.md for more info."
    sleep 2
}

play_audio () {
    echo "=> Audio found!"
    sleep 0.2
    echo "Playing..."
    sleep 0.3
    cmus-remote -C "player-play $play"
}

start_cmus () {
    # WEEE WEEE WEE WEEE (SIREN)
    # -e for escape so we can use colors :)
    # you can read the rest, can't you?
    echo -e "${red}:: Error:${reset}"	   
    echo -e "    cmus is ${uline}NOT${reset} running."
    sleep 0.3

    # In the while-loop below, [Yy] means "Y" or "y". Same goes for [Nn].
    while [[ "$run_cmus" != [Yy] ]] && [[ "$run_cmus" != [Nn] ]]; do
        read -rp "=> Do you want to run it? [y/n] " run_cmus
    done

    case "$run_cmus" in
        # if the user answers Y or y, they will be asked for their terminal's binary
        Y|y|"") read -rp "Please enter the binary of the terminal you use (keep empty if you don't know) " terminal

        # WHAT TERMINAL EMULATOR DO YOU USE?????
            if [[ -n "$terminal" ]]; then

                # Kitty terminal is weird when it comes to disowning processes
                if [[ "$terminal" == "kitty" ]]; then
                    nohup "$terminal" -e cmus >/dev/null 2>&1 & disown
                else
                    # Ah yes, normal terminals
                    "$terminal" -e cmus & disown > /dev/null
                fi

                # some dramatic effects
                sleep 2
                # new line (i should find a better way to do this)
                echo
            else
                # you don't know the terminal emulator you're using? good lord.
                echo "Open a terminal window, start cmus and try again."
                # give the user some time to read (if they can read that is)
                sleep 5s
                # bye
                exit
            fi
            ;;

            # how dare you
        N|n) echo "Okay. See you soon."
        # dramatic effects AGAIN
            sleep 3s
            # bye
            exit
            ;;
    esac
}

install_cmus_debian () {
    echo -en "Do you want to install it? [${blue}Y${reset}/${red}n${reset}] "
    read -r installAnswer

    if [[ -d /etc/apt ]]; then

        case $installAnswer in
            Y|y|"") echo -e "Please enter your password to install CMUS."
                sudo apt update && sudo apt install cmus -y
                ;;
            N|n) echo -e "${red}Aborting.${reset}"
                ;;
            *) echo -e "${red}Unknown entry. Aborting.${reset}"
                ;;
        esac

    fi
}

install_cmus_arch () {
    if [[ -d /etc/pacman.d ]]; then

        case $installAnswer in
            Y|y|"") echo -e "Please enter your sudo password to install CMUS."
                sudo pacman -S cmus
                ;;
            N|n) echo -e "${red}Aborting.${reset}"
                ;;
            *) echo -e "${red}Unknown entry. Aborting.${reset}"
                ;;
        esac

    fi
}

install_cmus () {
    echo -e "\n${red}:: Error:${reset}\n       CMUS is ${uline}NOT${reset} installed."
    if [[ -d /etc/apt ]] || [[ -d /etc/pacman.d ]]; then
        install_cmus_debian # or if not a debian system,
        install_cmus_arch
    else
        echo "Please install it and retry. For more info, please refer to the README.md"
    fi
}

############################################################################
############################ SCRIPT ########################################
############################################################################

while [[ -z "$song_to_play" ]]; do
    if command -v cmus > /dev/null && command -v cmus-remote > /dev/null; then
        if [[ -n $(pidof cmus) ]]; then
            query_and_process
            find_audio
            case $play in
                "")
                    audio_not_found
                    ;;

                *)
                    play_audio
                    ;;
            esac
        else
            start_cmus
        fi
    else
        install_cmus
    fi
done
