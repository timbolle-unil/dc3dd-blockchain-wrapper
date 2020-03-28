#NOTICE

# © 2020 The MITRE Corporation
#This software (or technical data) was produced for the U. S. Government under contract SB-1341-14-CQ-0010, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007)
#Released under MITRE PRE #18-4297.

#!/bin/bash


#==================================================
# CHECKS FOR NO ARGS
NOARGS_ERROR=85
if [ -z "$1" ]
    then
    echo "Usage: <tool> <arguments>"
    exit $NOARGS_ERROR
fi


#==================================================
# META INFO - USER INPUT
#echo "Enter your name:"
#read Prsn
#while [[ ! $Prsn =~ ^[A-Za-z]+[\ \t][A-Za-z]+$ ]]; do
#    echo "Use a space and only letters:"
#    read Prsn
#done
#echo ""
#echo "Enter evidentiary Media Manufacturer:"
#read EMan
#echo ""
#echo "Enter evidentiary Media Serial#:"
#read ESer
#while [[ ! $ESer =~ ^[0-9]+$ ]]; do
#    echo "Use only numbers:"
#    read ESer
#done
#echo ""
#echo "Enter evidentiary Media Notes:"
#read ENot
#echo ""


#==================================================
# META INFO - SYSTEM GENERATED
User=$USER

LgnM="$(last -R "$USER" | head -1 | awk 'END {print $4}')"  #Note /var/log/wtmp does not track year so current year assumed.
LgnM="$(date --date="$(printf "01 %s" "$LgnM")" +"%Y-%m")"
LgnD="$(last -R "$USER" | head -1 | awk 'END {print $5}')"
LgnT="$(last -R "$USER" | head -1 | awk 'END {print $6}')"
LgnZ="$(date | awk '{print $5}')"
LLgn="$LgnM"-"$LgnD"T"$LgnT":00.Z"$(date +%z)"              #LastLogin

BPid=$$
Tool=$1
TLoc="$(which $1)"
Args=$(($# - 1))





#==================================================
# RUN TOOL
echo "========================="
Secs=$SECONDS
STim=`date '+%Y-%m-%d %H:%M:%S'`
CmdO="$($*)"
echo "${CmdO}"

ETim=`date '+%Y-%m-%d %H:%M:%S'`
echo "========================="


#==================================================
# CALCULATE DURATION
Secs=$(($SECONDS - $Secs))
Days="$(( $Secs / $((24 * 3600)) ))"
Left="$(( $Secs % $((24 * 3600)) ))"
Hour="$(( $Left / 3600 ))"
Left="$(( $Left % 3600 ))"
Mins="$(( $Left / 60 ))"
Left="$(( $Left % 60 ))"
Time="$Days:$Hour:$Mins:$Left"


#==================================================
# OUTPUT SETTINGS
echo -e "Tool:          \t"     $Tool
echo -e "User:          \t"     $User
echo -e "Last Login:    \t"     $LLgn
echo -e "Shell PID:     \t"     $BPid
echo -e "Tool Location: \t"     $TLoc
echo -e "Number Args:   \t"     $Args
echo -e "Command run:   \t"     $*
echo -e "Start Time:    \t"     $STim
echo -e "End Time:      \t"     $ETim
echo -e "Total Duration:\t"     $Time
#echo -e "Media Serial#: \t"     $ESer
#echo -e "Manufacturer:  \t"     $EMan
#echo -e "Media Notes:   \t"     $ENot


#==================================================
# CALL PYTHON SCRIPT FOR BLOCKCHAIN INFO
python3 wrapper2blockchain.py -c $* -b blockchain.config
