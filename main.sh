#!/bin/bash

shopt -s nocasematch

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' #No Color
bold=$(tput bold)
normal=$(tput sgr0)
bind -x '"\C-l": clear; printf ">> "' #so we can use ctrl+L to clear the screen
tput cuu1
tput ed
currentDB=""

printf "${YELLOW}${bold}Hi There, take a look at our documentation by typing 'help'\n${normal}${NC}"

if [ ! -d "DATA" ]
    then
    mkdir DATA
fi


function connect2DB {
    tput el1
    if [[ $2 =~ ^(to)$ && ! -z $3 ]]
        then
            if [[ ! -d DATA/$3 || ! -z $4 ]]
            then
                printf "${RED}${bold}There is NO database with that name!${normal}${NC}\n"
            else
                if [[ ! -z $currentDB ]]
                then
                    if [[ $currentDB =~ $3 ]]
                    then
                        printf "${RED}${bold}You're already connected to $3!${normal}${NC}\n"
                    else
                        printf "\t${YELLOW}${bold}Switched to $3!${normal}${NC}\n"
                    fi
                else
                    printf "\t${YELLOW}${bold}You're now connected to $3!${normal}${NC}\n"
                fi
                currentDB=$3
            fi
        printf ">> "
    else
        printf "${RED}${bold}Bad syntax! For more details check the documentation by typing 'help'${NC}${normal}\n>> "
    fi
}

function disconnect {
    tput el1
    if [[ -z $2 ]]
        then
            if [[ -z $currentDB ]]
            then
                printf "${RED}${bold}You're already not connected to any databases!${normal}${NC}\n"
            else
                printf "\t${YELLOW}${bold}Disconnected successfully from $currentDB!${normal}${NC}\n"
                currentDB=""
            fi
        printf ">> "
    else
        printf "${RED}${bold}Bad syntax! For more details check the documentation by typing 'help'${NC}${normal}\n>> "
    fi
}

function showDB {
    tput el1
    if [[ -z $currentDB ]]
    then
        printf "${RED}${bold}You're already not connected to any databases!${normal}${NC}\n"
    else
        printf "\t${YELLOW}${bold}You're connected to $currentDB!${normal}${NC}\n"
    fi
    printf ">> "
}

function dropDB {
    tput el1
    if [[ $2 =~ ^(database)$ && ! -z $3 ]]
        then
            if [[ ! -d DATA/$3 ]] 
                then
                printf "${RED}${bold}There is NO database with that name!${normal}${NC}\n"
            else
                if [[ $currentDB == $3 ]]
                then
                    disconnect
                    tput el1
                fi
                rm -r DATA/$3
                if [[ $? -eq 0 ]]
                then
                    printf "\t${YELLOW}${bold}Deleted Successfully!${normal}${NC}\n"
                fi
            fi
        printf ">> "
    else
        printf "${RED}${bold}Bad Syntax! For more details check the documentation by typing 'help'${NC}${normal}\n>> "
    fi
}

printf ">> ";
export bold NC normal BLUE RED YELLOW currentDB

while read -e input
do
    array=($input)
    printf ">> ";
    if [[ ${array[0]} =~ ^(create)$ && ${array[1]} =~ ^(database)$ ]]
    then
        ./createDB.sh "${array[@]}"

    elif [[ ${array[0]} =~ ^(list)$ && ${array[1]} =~ ^(databases)$ ]]
    then 
        ./listDBs.sh "${array[@]}"
    
    elif [[ ${array[0]} =~ ^(list)$ && ${array[1]} =~ ^(tables)$ ]]
    then 
        ./listTable.sh "${array[@]}"

    elif [[ ${array[0]} =~ ^(drop)$ && ${array[1]} =~ ^(database)$ ]]
    then 
        ./dropDB.sh "${array[@]}"

    elif [[ ${array[0]} =~ ^(drop)$ && ${array[1]} =~ ^(table)$ ]]
    then
	./dropTable.sh "${array[@]}"

    elif [[ ${array[0]} =~ ^(select)$ ]]
    then 
        ./select.sh "${array[@]}"

    elif [[ ${array[0]} =~ ^(disconnect)$ ]]
        then
        disconnect "${array[@]}"

    elif [[ ${array[0]} =~ ^(connect)$ ]]
    then
        connect2DB "${array[@]}"
    
    elif [[ ${array[0]} =~ ^(db)$ && -z ${array[1]} ]]
    then
        showDB
    
    elif [[ ${array[0]} =~ ^(create)$ && ${array[1]} =~ ^(table)$ ]]
    then
        ./createTable.sh "${array[@]}"
    
    elif [[ ${array[0]} =~ ^(help)$ ]]
    then
        ./help.sh

    elif [[ ${array[0]} =~ ^(exit)$ ]]
    then
        break 2
        
    # for Enter button
    elif [[ -z $input ]]
    then
        continue

    else
        tput el1
        printf "${RED}${bold}Bad Syntax! For more details check the documentation by typing 'help'${NC}${normal}\n>> "        
    fi
done


##for erasing unwanted line at the closing
tput cuu1

printf "\n${YELLOW}hope to see you soon!${NC}\n"
