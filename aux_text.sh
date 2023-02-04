#!/bin/bash

#################
## Variables   ##
#################

## Colors
## NOTE: \e[ -> \033[ 
_BLC='\e[0;30m' # Black - Regular
_RED='\e[0;31m' # Red
_GRN='\e[0;32m' # Green
_BRN='\e[0;33m' # Brown - Orange
_BLU='\e[0;34m' # Blue
_PUR='\e[0;35m' # Purple
_CYN='\e[0;36m' # Cyan
_LGR='\e[0;37m' # Light Gray
_DGR='\e[1;30m' # Dark Gray
_LRD='\e[1;31m' # Light Red
_LGN='\e[1;32m' # Light Green
_YLW='\e[1;33m' # Yellow
_LBU='\e[1;34m' # Light Blue
_LPR='\e[1;35m' # Light Purple
_LCN='\e[1;36m' # Light Cyan
_WHT='\e[1;37m' # White
_NC='\e[0m'     # No Color

## Formatting
_TBLD='\e[1m' # Bold
_TITL='\e[3m' # Italic
_TUDL='\e[4m' # Underline
_TNT='\e[0m'  # No Format
