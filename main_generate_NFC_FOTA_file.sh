#!/bin/bash

#################
## Source files##
#################
AUXFUNCTFILE="aux_functions.sh"

source $AUXFUNCTFILE


#################
## Main Script ##
#################

## Check user input
if [ "$#" -ne 1 ]; then
    echo -e "${_RED}${_TBLD}E!${_TNT}: Please provide FW_FILE_NAME"
    exit 1
fi

## Initialize File and Filename Variables
FILE=$1
FILENAME=$(basename -- "$FILE")
FILENAME="${FILENAME%.*}"
EXTENSION="${FILE##*.}"
#HEADERNAME=$2
FILETYPE="bin"
#FILE="$FILENAME$FILETYPE"

if [ $FILETYPE != $EXTENSION ]; then
    echo -e "${_RED}${_TBLD}E!${_TNT}: Please provide binary file (extension: .bin)"
    exit 1
fi

## Initialize auxiliary variables
SHOULDPAD=true
SHOULDNOTPAD=false
## Required file size multiple
ALIGNB=8

## Print script title
echo -ne "${_TBLD}${_BRN}\n### NFC FOTA file generator ###\n\n${_TNT}"

## Check if provided file exist
file_exists $FILE

## Calculate  FW file size
FILESIZE=$(stat -c%s "$FILE")

## Check if firmware is multiple of 8 bytes
check_multiple $FILE $FILESIZE $ALIGNB $SHOULDPAD

## Call Python script to generate header file
HEADER=$(/usr/bin/python3 header_generator.py $FILENAME)
## Check if Python script exited successfully
if [ $? -ne 0 ]; then
    echo -e "${_RED}${_TBLD}E!${_TNT}: Please provide FW_FILE_NAME (no extension, should be .bin)"
fi

## Check if header file exist
file_exists $HEADER

## Calculate header file size
HEADERSIZE=$(stat -c%s "$HEADER")

## Check if header is multiple of 8 bytes
check_multiple $HEADER $HEADERSIZE $ALIGNB $SHOULDNOTPAD

## Generate NFC FOTA file
NFC_FOTA_FILE=""$FILENAME"_NFC_FOTA."$FILETYPE""
cat $HEADER $FILE | tee $NFC_FOTA_FILE &>/dev/null

## Final file size should be multiple of 8 bytes
## Uncomment the following lines to verify previous proceedings were correct
NFCFILESIZE=$(stat -c%s "$NFC_FOTA_FILE")
check_multiple $NFC_FOTA_FILE $NFCFILESIZE $ALIGNB $SHOULDNOTPAD

## NFC update file successfully generated
echo -e "${_GRN}${_TBLD}I!${_TNT}: NFC FOTA file \"${_LGN}${_TBLD}$NFC_FOTA_FILE${_TNT}\" generated successfully\n"

exit 0