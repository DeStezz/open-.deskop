#!/bin/bash
DEBUG=false
FILE=$1

debug () { #all debug messages are sent to here.
   if [[ $DEBUG == "true" ]] ; then
       echo $1
   fi
}

replace_vars () { #See https://developer.gnome.org/integration-guide/stable/desktop-files.html.en#commandline for more info
   local text=$@ #look for things that match with $replace_match and replace them with $replace_convert
   declare -a replace_match 
   declare -a replace_convert
   replace_match=("%k" "%U" "%u")
   replace_convert=("$FILE" "" "")
   i=0
   for item in ${replace_match[@]}; do
       #echo "${replace_match[$i]}"
       #echo "${replace_convert[$i]}"
       text=${text//${replace_match[$i]}/${replace_convert[$i]}}
       let i=i+1
   done

   echo "$text"
}



#Checks
if [ ! -f "$FILE" ]; then
    debug "\`$FILE\` does not exist, asking user to select file"
    NewFile=`zenity --file-selection --title="Select a file"`
    case $? in
        0)
               #echo "\"$FILE\" selected."
               "$0" "$NewFile"
               exit
               ;;
        1)
               #echo "No file selected."
               exit
               ;;
       -1)
               #echo "An unexpected error has occurred."
               exit 1
               ;;
    esac 
fi
#if [ ! -x "$FILE" ]; then
#    zenity --error --text="\`$FILE\` is not executable." --title="Warning!" --width 300
#    echo "\`$FILE\` is not executable."
#    exit 1
#fi

if [[ $FILE != *.desktop ]]; then
    zenity --error --text="\`$FILE\` is not a .desktop file." --title="Warning!" --width 500
    echo "\`$FILE\` is not a .desktop file."
    exit 1
fi

#Get file Contents and check for `[Desktop Entry]` in the .desktop file.

fileContents=`cat "$FILE"`
if `echo "$fileContents" | grep -Fxq "[Desktop Entry]"`
then
    echo invisible text >/dev/null #Prevent errors from coming up due to having an emtpy if statment
else
    echo "Error, cannot find the line with \"[Desktop Entry]\" (Aka invalid desktop file)"
    zenity --error --text="Error, cannot find the line with \"[Desktop Entry]\" (Aka invalid desktop file)" --title="Warning!" --width 500
    exit
fi

#Parse $fileContents to get usefull info

desktopExec=`echo "$fileContents" | grep -m1 "^Exec"`
desktopExec=`echo "${desktopExec##Exec=}"`
desktopExec=`replace_vars $desktopExec`


TerminalFlag=`echo "$fileContents" | grep "Terminal=true"`
echo "executing command \`${desktopExec}\`"
if [ -z `echo "$fileContents" | grep "Terminal=true"` ] ; then
    eval "${desktopExec}"
else

    echo Terminal
    gnome-terminal -- bash -c "${desktopExec[@]}"
fi
