#!/usr/bin/env bash
VERSION='v0.93'
# @author Daniel Lagacé
# @license GNE GPLv2


# To add a zone,
# 1) use "timedatectl list-timezones" to find a timezone.
# 2) add a name entry in the "NAME" array. (Can be anything)
# 3) add the Unix city or timezone code you found in step 1 into the "TIMEZONE" array.
# (The NAME and TIMEZONE arrays have to be in the same order)

# Local Variables
CURRENT_CITY='Montréal'                           # Any Name
CURRENT_TIMEZONE[0]='America/Toronto'             # ET  / Local / Unix Timezone
CURRENT_TIMEZONE[1]='EST'                         # EST / Unix Timezone
CURRENT_TIMEZONE[2]='EDT4'                        # EDT / Unix Timezone


# Colors
#### 8-bit ANSI color codes reference:
#### https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#color-codes
T='\e[1;0m'   # Title
D='\e[0;33m'  # Daylight
S='\e[0;34m'  # Standard
M='\e[0;31m'  # Montreal (or Main city)
C='\e[0;36m'  # commands
P='\e[0;35m'  # Purple
X='\e[0m'     # default terminal color.
BAR='\e[0m---------------------------------------------------------------------------------------\n'


# World Time Variables
NAME=( \
"${D}""Sydney, Australia  [Spring=Sept 21]" \
"${S}"'UTC+9    Japan' \
"${S}"'UTC+8:   China/HK, Singapore, Philipines' \
"${S}"'UTC+5.5: India  (no DST)' \
"${D}"'Israel' \
"${D}"'Paris, Barcelona' \
"${D}"'London' \
"${S}"'UTC' \
"${S}"'UTC-3    Sao Paolo [Brasilia Time]' \
"${M}"'New York, Montréal, Toronto' \
"${D}"'Manitoba' \
"${D}"'Alberta' \
"${D}"'California, British Columbia' \
"${S}"'UTC-10   Hawaii' \
)

TIMEZONE=( \
'Australia/Sydney' \
'Japan' \
'Singapore' \
'Asia/Calcutta' \
'Israel' \
'Europe/Paris' \
'Europe/London' \
'UTC' \
'America/Sao_Paulo' \
'America/New_York' \
'America/Winnipeg' \
'America/Edmonton' \
'America/Los_Angeles' \
'Pacific/Honolulu' \
)


KEY_AMAJOR='G1swOzMybVdoZW4gSSB3YXMgeW91bmdlciBzbyBtdWNoIHlvdW5nZXIgdGhhbiB0b2RheQpJIG5l
dmVyIG5lZWRlZCBhbnlib2R5J3MgaGVscCBpbiBhbnkgd2F5CkJ1dCBub3cgdGhlc2UgZGF5cyBh
cmUgZ29uZSwgSSdtIG5vdCBzbyBzZWxmIGFzc3VyZWQKTm93IEkgZmluZCBJJ3ZlIGNoYW5nZWQg
bXkgbWluZCBhbmQgb3BlbmVkIHVwIHRoZSBkb29ycwobWzM1bXVzYWdlIGV4YW1wbGVzOiBbLXVd
G1swOzBtCg=='


## FUNCTIONS
usage(){
  echo -e "Usage [-h]:"
  printf "%-35b %b\n" "${T}- Mini [-m]:" "${C}${0} -m${X}"
  printf "%-35b %b\n" "${T}- Extended [-x]:" "${C}${0} -x${X}"
  printf "%-35b %b\n" "${T}- Refresh once a minute:"  "${C}watch -c -n 60 \"${0} -m\"${X}"
  printf "%-35b %b\n" "${T}- Local date:"     "${C}date${X}"
  printf "%-35b %b\n" "${T}- list timezones:"   "${C}timedatectl list-timezones | more${X}"
}

# Local Time
local_time(){
    printf "%-57b %-10b\n"  "${T}Location:"                               "${T}${CURRENT_CITY}"   # 1 character offset due to color
    printf "%-58b %-10b\n"  "${M}Current time:  ------> ------->"      "$(TZ=${CURRENT_TIMEZONE[0]} date)"
    if [ "${DISPLAY_PANELS}" -ge '1' ]; then
        NEXT_TIME_CHANGE_IN_UTC=$(curl -s "http://worldtimeapi.org/api/timezone/America/Toronto" | cut -d ',' -f9 | cut -d '"' -f4)
        if [ -n "${NEXT_TIME_CHANGE_IN_UTC}" ]; then
	    NEXT_TZ_CHANGE[0]="Next Local Time change:"
            NEXT_TZ_CHANGE[1]=$(TZ="${CURRENT_TIMEZONE[0]}" date -d "${NEXT_TIME_CHANGE_IN_UTC}")
            printf "%-58b %-10b\n"  "${P}${NEXT_TZ_CHANGE[0]}" "${P}${NEXT_TZ_CHANGE[1]}"
            printf "%-20b %b\n" "${S}STANDARD TIME:" "$(TZ=${CURRENT_TIMEZONE[1]} date +'%r %Z')"
            printf "%-20b %b\n" "${S}DAYLIGHT TIME:" "$(TZ=${CURRENT_TIMEZONE[2]} date +'%r %Z')"
	else
            printf "%-20b %b\n" "${S}STANDARD TIME:" "$(TZ=${CURRENT_TIMEZONE[1]} date +'%r %Z')"
            printf "%-20b %b\n" "${P}DAYLIGHT TIME:" "$(TZ=${CURRENT_TIMEZONE[2]} date +'%r %Z')"
	fi
    else	
        printf "%-20b %b\n" "${S}STANDARD TIME:" "$(TZ=${CURRENT_TIMEZONE[1]} date +'%r %Z')"
        printf "%-20b %b\n" "${P}DAYLIGHT TIME:" "$(TZ=${CURRENT_TIMEZONE[2]} date +'%r %Z')"
    fi
    echo -e "${BAR}"
}

# World Timezones display
world_time(){
    printf "%-64b %-40b %b\n"  "${T}Name          ${P}(Yellow+Red = DST in summer)"  "${T}(Unix location)"  "TIME"
    i=0
    while [ $i -lt "${#NAME[@]}" ]; do
        printf "%-58b %-20s %s\n"  "${NAME[$i]}" "${TIMEZONE[$i]}" "$(TZ=${TIMEZONE[$i]} date)"
        i=$(( $i+1 ))
    done
    echo -e "${BAR}"
}

# Default features:
print_calculation_syntax(){
    printf "%-35b %b\n\n" "${T}Time and date commands:"     "${P}  <<  Only change what is in the quotes >>${C}"
    echo -e "${T}# It is 2pm in Montreal, what time is it in India? (IST)${C}"
    printf "%-58s %s\n" 'TZ=Asia/Calcutta date -d "14:00 EST"'              "# EST ---------> IST"
    printf "%-58s %s\n" 'TZ=Asia/Calcutta date -d "1 Aug 2022 2:00 pm EST"' "# EST & date --> IST"
    printf "%-58s %s\n" 'TZ=Asia/Calcutta date -d "14:00 EDT"'              "# EDT ---------> IST"
    echo
    echo -e "${T}# It is 2pm in India, what time is it in Montreal?${C}"
    printf "%-58s %s\n" 'TZ=EST date -d "14:00 IST"'                        "# IST ---------> EST"
    printf "%-58s %s\n" 'TZ=EDT4 date -d "2:00 pm IST"'                     "# IST ---------> EDT"
    printf "%-58s %s\n" 'TZ=America/Toronto date -d "1 Aug 2022 14:00 IST"' "# IST & date --> ET (local time)"
}

# Extended features:
how_to_adjust(){
    echo -e "\nThis script is easy to adjust:"
    echo "1) Add or remove names of timzones from the \"TIMEZONE\" varible"
    echo "2) And add or remove the corresponding entry in the \"NAME\" array."
    echo "   - The \"NAME\" entry can be any name."
}

#------------------------------
## Start program
#[ 0 = time only, 1 = calculation syntax, 2 = extended]
DISPLAY_PANELS='1'               # default

# Getops
while getopts ":vuhmx" opt; do
    case "${opt}" in
        v) echo "gdate version: ${VERSION}" && exit 0;;      # version
        u) usage && exit 0;;                                 # usage
        h) echo -e "${KEY_AMAJOR}" | base64 -d && exit 0;;   # help
        m) DISPLAY_PANELS='0';;                              # minimal
        x) clear; DISPLAY_PANELS='2';;                       # extended
        *) ;;
    esac
done

local_time
world_time
[ "${DISPLAY_PANELS}" -ge '1' ] && print_calculation_syntax
[ "${DISPLAY_PANELS}" == '1' ] && echo -e "${P}|==> Mini [-m]       |==> Extended [-x]      |==> Usage [-h]${C}"
[ "${DISPLAY_PANELS}" == '2' ] && echo -e "${BAR}" && usage && how_to_adjust
