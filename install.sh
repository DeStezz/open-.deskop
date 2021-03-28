#!/bin/bash
while true; do
    read -p "Do you want to do a Local or Global install(L/G): " LG
    case $LG in
        [Ll] | Local* | local*)
            ./Install/local-install.sh
        ;;
        [Gg] | Global* | global*)
            echo
            echo Sorry Global instals arent a feture yet.s
            echo
        ;;

    esac
done
