#!/bin/bash


VERSION="v0.1.0"


function help {
    echo "Usage: internsctl [OPTIONS] <COMMAND>"
    echo ""
    echo "Available commands:"
    echo "  cpu getinfo      Get CPU information"
    echo "  memory getinfo   Get memory information"
    echo "  user create     Create a new user"
    echo "  user list       List all regular users"
    echo "  user list --sudo-only    List all users with sudo permissions"
    echo "  file getinfo    Get information about a file"
    echo "  file getinfo --size <file-name>     Get the size of a file"
    echo "  file getinfo --permissions <file-name>   Get the permissions of a file"
    echo "  file getinfo --owner <file-name>      Get the owner of a file"
    echo "  file getinfo --last-modified <file-name> Get the last modified time of a file"
    exit 0
}


if [ $# -eq 0 ]; then
    help
fi


COMMAND=$1
shift


if [ "$COMMAND" == "cpu" ] && [ "<span class="math-inline">1" \=\= "getinfo" \]; then
echo "CPU information\:"
echo "</span>(lscpu)"
    exit 0
fi


if [ "$COMMAND" == "memory" ] && [ "<span class="math-inline">1" \=\= "getinfo" \]; then
echo "Memory information\:"
echo "</span>(free -h)"
    exit 0
fi


if [ "$COMMAND" == "user" ] && [ "$1" == "create" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: internsctl user create <username>"
        exit 1
    fi

    USERNAME=$2
    useradd -m -s /bin/bash $USERNAME
    echo "User $USERNAME created successfully."
    exit 0
fi


if [ "$COMMAND" == "user" ] && [ "$1" == "list" ]; then
    echo "Regular users:"
    for user in $(cut -d ':' -f 1 /etc/passwd); do
        if [ $user != "root" ]; then
            echo $user
        fi
    done
    exit 0
fi


if [ "$COMMAND" == "user" ] && [ "$1" == "list" ] && [ "$2" == "--sudo-only" ]; then
    echo "Users with sudo permissions:"
    for user in $(cat /etc/sudoers); do
        if [ $(echo $user | grep -Ec '^#') -eq 0 ]; then
            echo $user
        fi
    done
    exit 0
fi


if [ "$COMMAND" == "file" ] && [ "$1" == "getinfo" ]; then
    if [ $# -ne 2 ]; then
        echo "Usage: internsctl file getinfo <file-name>"
        exit 1
    fi

    FILENAME=$2

    if [ $# -eq 3 ]; then
        OPTION=$3
        if [ "$OPTION" == "--size" ] || [ "<span class="math-inline">OPTION" \=\= "\-s" \]; then
echo "</span>(stat -c %s $FILENAME)"
            exit 0
        elif [ "$OPTION" == "--permissions" ] || [ "<span class="math-inline">OPTION" \=\= "\-p" \]; then
echo "</span>(stat -c %a $FILENAME)"
            exit 0
        elif [ "$OPTION" == "--owner" ] || [ "<span class="math-inline">OPTION" \=\= "\-o" \]; then
echo "</span>(stat -c %U $FILENAME)"
            exit 0
        elif [ "$OPTION" == "--last-modified" ] || [ "<span class="math-inline">OPTION" \=\= "\-m" \]; then
echo "</span>(stat -c %Y $FILENAME)"
            exit 0
        else
            echo "Invalid option: $OPTION"
            exit 1
        fi
    fi

    echo "File: $FILENAME"
    echo "Access
