#!/bin/bash

#################
## Source files##
#################
COLORSFILE="aux_text.sh"

source $COLORSFILE


#################
## Functions   ##
#################

## Function that checks if file size is multiple of given parameter
check_multiple() {
  if [ "$#" -ne 4 ]; then
    echo -e "${_RED}${_TBLD}E!${_TNT}: check_multiple() function call should carry 4 arguments"
    exit 1
  fi

  local FILE=$1
  local FILESIZE=$2
  local ALIGNB=$3
  local SHOULDPAD=$4
  local PAD_SIZE
  local PAD_FILE
  local ISMULT

  ISMULT=$(( $FILESIZE % $ALIGNB ))
  if [ $ISMULT -eq 0 ]; then
    echo -e "${_GRN}${_TBLD}I!${_TNT}: File ${_TITL}$FILE${_TNT} is multiple of $ALIGNB bytes"

  elif [ $SHOULDPAD == true ]; then
    echo -e "${_GRN}${_YLW}W!${_TNT}: File ${_TITL}$FILE${_TNT} is NOT multiple of $ALIGNB bytes"
    PAD_SIZE=$(( ($ALIGNB - ($FILESIZE % $ALIGNB)) % $ALIGNB ))
    echo -e "${_GRN}${_TBLD}I!${_TNT}: Will pad file with $PAD_SIZE bytes"
    PAD_FILE="pad.bin"
    dd if=/dev/zero of=$PAD_FILE bs=$PAD_SIZE count=1 &>/dev/null
    cat $FILE $PAD_FILE | tee $FILE &>/dev/null
    rm $PAD_FILE
    echo -e "${_GRN}${_TBLD}I!${_TNT}: Padding file OK"

  else 
    echo -e "${_RED}${_TBLD}E!${_TNT}: File ${_TITL}$FILE${_TNT} is NOT multiple of $ALIGNB bytes"
    exit 1

  fi
}

## Function to check if file exists
file_exists() {
  if [ ! -f $1 ]; then
    echo -e "${_RED}${_TBLD}E!${_TNT}: File not found: out/$1"
    exit 1
  fi
}