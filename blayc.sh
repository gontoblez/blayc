#! /bin/bash

#stty intr $'\e'

music=""

red="\e[0;91m"
blue="\e[0;94m"
uline="\e[4m"
reset="\e[0m"

err_msg() {
    echo -e "${red}:: Error:${reset}"
    echo -e "    $1"
    echo "==> Please refer to the README.md for more info."
    read -n 1 -r -s -p "Press any key to continue..."
}

run_cmus(){
    read -rp "Please enter the binary of the terminal you use (keep empty if you don't know) " terminal

    # WHAT TERMINAL EMULATOR DO YOU USE?????
    if [[ -n "$terminal" ]]; then

        # Kitty terminal is weird when it comes to disowning processes
        if [[ "$terminal" == "kitty" ]]; then
            nohup "$terminal" -e cmus >/dev/null 2>&1 & disown
        else
            # Ah yes, normal terminals
            "$terminal" -e cmus & disown > /dev/null
        fi
        # new line (i should find a better way to do this)
        echo
    else
        # you don't know the terminal emulator you're using? good lord.
        echo "Open a terminal window, start cmus and try again."
        # give the user some time to read (if they can read that is)
        read -n 1 -s -r -p "Press any key to continue..."
        # bye
        exit
    fi

}

play_song(){
    # get user input and store it in song_to_play
    read -rp ":: Play: " song_to_play
    # ${var//search/replace}, searching for the string " " and
    # replacing it with the wildcard "?" and storing it in $song
    song=${song_to_play//\ /?}

    # if music location variable specified, search through it
    # if not, search in the default music directory
    if [[ -n "$music" ]]; then
        song_path=$(find "$music" -type f -iname "*$song*")
    else
        song_path=$(find "$HOME/Music" -type f -iname "*$song*")
    fi

    if [[ -n $song_path ]]; then
        echo "=> Audio found!"
        sleep 0.2
        echo "Playing..."
        sleep 0.3
        cmus-remote -C "player-play $song_path"
    else
        err_msg "Audio NOT found."
    fi
}

while [[ -z "$song_to_play" ]]; do
    if command -v cmus > /dev/null && command -v cmus-remote > /dev/null; then
        if [[ -n $(pidof cmus) ]]; then
            play_song
        else
            # WEEE WEEE WEE WEEE (SIREN)
            # -e for escape so we can use colors :)
            # you can read the rest, can't you?
            err_msg "    cmus is ${uline}NOT${reset} running."
            # In the while-loop below, [Yy] means "Y" or "y". Same goes for [Nn].
            read -rp "=> Do you want to run it? [y/N] " run_cmus
            if [[ $run_cmus == [Yy] ]]; then
                run_cmus
            else
                echo "Okay. See you soon."
                sleep 0.5
                exit
            fi
        fi
    else
        err_msg "CMUS is ${uline}NOT${reset} installed."
        if [[ -d /etc/apt ]] || [[ -d /etc/pacman.d ]]; then
            echo -en "Do you want to install it? [${blue}y${reset}/${red}n${reset}] "
            read -r installAnswer
            # DEBIAN LINUX INSTALLATION
            if [[ -d /etc/apt ]]; then

                case $installAnswer in
                    [Yy]) echo -e "Please enter your password to install CMUS."
                        sudo apt update && sudo apt install cmus -y
                        ;;
                    [Nn]) echo -e "${red}Aborting.${reset}"
                        ;;
                    *) echo -e "${red}Unknown entry. Aborting.${reset}"
                        sleep 2
                        exit
                        ;;
                esac

            fi
            # ARCH LINUX INSTALLATION
            if [[ -d /etc/pacman.d ]]; then

                case $installAnswer in
                    [Yy]) echo -e "Please enter your sudo password to install CMUS."
                        sudo pacman -S cmus
                        ;;
                    [Nn]) echo -e "${red}Aborting.${reset}"
                        ;;
                    *) echo -e "${red}Unknown entry. Aborting.${reset}"
                        sleep 2
                        exit
                        ;;
                esac

            fi
        else
            echo "Please install it and retry. For more info, please refer to the README.md"
        fi
    fi
done
