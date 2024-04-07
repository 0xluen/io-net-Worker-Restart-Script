#!/bin/bash


echo "░▒▓█▓▒░░▒▓██████▓▒░       ░▒▓███████▓▒░░▒▓████████▓▒░▒▓████████▓▒░ "
echo "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     "
echo "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     "
echo "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░    ░▒▓█▓▒░     "
echo "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     "
echo "░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓██▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     "
echo "░▒▓█▓▒░░▒▓██████▓▒░░▒▓██▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░  ░▒▓█▓▒░     "
                                                                 


OS=$(uname)

rm -rf runCommand.txt

if [ "$OS" = "Darwin" ]; then
    echo "Operating System: macOS."
    
    rm -rf launch_binary_mac

    curl -L https://github.com/ionet-official/io_launch_binaries/raw/main/launch_binary_mac -o launch_binary_mac

    chmod +x launch_binary_mac
    
elif [ "$OS" = "Linux" ]; then
    echo "Operating System: Linux."

    rm -rf ionet-setup.sh

    curl -L https://github.com/ionet-official/io-net-official-setup-script/raw/main/ionet-setup.sh -o ionet-setup.sh

    chmod +x ionet-setup.sh

    chmod +x ionet-setup.sh && ./ionet-setup.sh

    sudo apt install curl

    rm -rf launch_binary_linux

    curl -L https://github.com/ionet-official/io_launch_binaries/raw/main/launch_binary_linux -o launch_binary_linux

    chmod +x launch_binary_linux

else
    echo "Unsupported OS: $OS"
    break
fi

configFile="runCommand.txt"

if [ ! -f "$configFile" ]; then
    echo "Please enter your docker run command:"
    read userCommand
    echo $userCommand > $configFile
fi

if ! docker version > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker."
    # sudo systemctl start docker
    exit 1
fi

userCommand=$(cat $configFile)

running_containers=$(docker ps -q | wc -l)

echo "Please select an option:"
echo "1 - One-time reset"
echo "2 - Periodic reset with condition check"
echo "3 - Periodic reset at specified intervals"
read -p "Enter your choice (1/2/3): " choice

delay=60

case $choice in
    1)
        echo "One-time reset selected."
        docker ps -a -q | xargs -r docker stop
        docker ps -a -q | xargs -r docker rm
        docker images -a -q | xargs -r docker rmi -f
        eval $userCommand
    ;;
    2|3)
        read -p "Enter delay in seconds (default is 60): " input_delay
        if [[ ! -z "$input_delay" ]] && [[ "$input_delay" =~ ^[0-9]+$ ]]; then
            delay=$input_delay
        fi
        if [ $choice -eq 2 ]; then
            echo "Periodic reset with condition check selected. Operating every $delay seconds."
            while true; do
                sleep $delay
                running_containers=$(docker ps -q | wc -l)
                if [ "$running_containers" -gt 1 ]; then
                    echo "All containers are running."
                else
                    docker ps -a -q | xargs -r docker stop
                    docker ps -a -q | xargs -r docker rm
                    docker images -a -q | xargs -r docker rmi -f
                    eval $userCommand
                fi
            done
        else
            echo "Periodic reset at specified intervals selected. Operating every $delay seconds."
            while true; do
                sleep $delay
                docker ps -a -q | xargs -r docker stop
                docker ps -a -q | xargs -r docker rm
                docker images -a -q | xargs -r docker rmi -f
                eval $userCommand
            done
        fi
    ;;
    *)
        echo "Invalid option. Script terminating."
        exit 1
    ;;
esac
