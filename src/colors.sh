#!/bin/bash

# Reset
NC='\033[0m' # No Color

# Regular colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold colors
B_BLACK='\033[1;30m'
B_RED='\033[1;31m'
B_GREEN='\033[1;32m'
B_YELLOW='\033[1;33m'
B_BLUE='\033[1;34m'
B_PURPLE='\033[1;35m'
B_CYAN='\033[1;36m'
B_WHITE='\033[1;37m'

# Underline output
U_BLACK='\033[4;30m'
U_RED='\033[4;31m'
U_GREEN='\033[4;32m'
U_YELLOW='\033[4;33m'
U_BLUE='\033[4;34m'
U_PURPLE='\033[4;35m'
U_CYAN='\033[4;36m'
U_WHITE='\033[4;37m'

# Background
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

#if [[ ! -t 1 ]]; then
#   NC=''
#    BLACK=''; RED=''; GREEN=''; YELLOW=''; BLUE=''; PURPLE=''; CYAN=''; WHITE=''
#    B_BLACK=''; B_RED=''; B_GREEN=''; B_YELLOW=''; B_BLUE=''; B_PURPLE=''; B_CYAN=''; B_WHITE=''
#    # ...і так далі для всіх змінних
#fi
