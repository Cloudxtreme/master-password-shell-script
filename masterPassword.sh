#!/bin/sh

# USAGE:
# execute script ./masterPassword.sh "user" "[domain]"
# the second argument (domain) is optional
# example ./masterPassword.sh "[hello@Gmail.com]" "[Gmail]"

USER="$1"
DOMAIN=${2:-none}

domains="passwordDomains"

printf "\n\e[31m*************************************\n"
printf "*    WELCOME TO PASSWORD CREATOR    *\n"
printf "*************************************\n"
printf "\n\e[32m"

if [ $DOMAIN = "none" ]; then
    echo "Select a domain from list or create new one"
    printf "\n"

    options=($(cat passwordDomains | sed -e 's/^/"/g' -e 's/$/"/g' | tr '\n' ' '))

    echo "*************************************"
    echo "*         Choose an option:         *"
    echo "*************************************"

    select opt in "${options[@]}" "*NEW DOMAIN*"; do

        if [ "$opt" = "" ]; then
            echo "No option selected. Bye bye"
            exit
        fi
        
        temp="${opt%\"}"
        temp="${temp#\"}"
        DOMAIN=$temp
        printf "\n\e[31m"
        echo $DOMAIN selected...
        printf "\n\e[32m"
        break
    done

fi

grep -i "$DOMAIN" "$domains" > /dev/null

if [ $? != 0 ] ; then

    echo "This domain does not exist on domains list. Do you want to create new domain? [Y/N]"
    read create
    
    if [ "$create" == "y" ] || [ "$create" == "Y" ] ; then

        if [ "$DOMAIN" == "*NEW DOMAIN*" ] ; then
            echo "Enter domain name, followed by [ENTER]"
            read NEWD
            echo $NEWD
            DOMAIN=$NEWD
        fi

        grep -i "$DOMAIN" "$domains" > /dev/null
        if [ $? != 0 ] ; then
            echo "$DOMAIN" >> "$domains"
            echo "Domain [$DOMAIN] added!"
        else
            echo "This domain exist in the list."
        fi
    fi

fi

echo "Type the master password for user [$USER] domain [$DOMAIN], followed by [ENTER]"
read -s MASTER
pw=$(echo "$USER" "$DOMAIN" "$MASTER" | md5 | fold -w 16 | head -n 1 | pbcopy)

printf "\n\e[31m"
echo "Password generated and copied to clipboard!"
printf "\n\e[32m"