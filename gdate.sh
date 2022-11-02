#!/usr/bin/env bash
# v0.90

# To add a zone,
# 1) use "timedatectl list-timezones" to find a timezone.
# 2) add a name entry in the "NAME" array. (Can be anything)
# 3) add the Unix city or timezone code you found in step 1 into the "TIMEZONE" array.
# (The NAME and TIMEZONE arrays have to be in the same order))



CURRENT_CITY='Montréal'                           # Any Name
CURRENT_TIMEZONE[0]='America/New_York'            # ET  / Unix Timezone
CURRENT_TIMEZONE[1]='EST'                         # EST / Unix Timezone
CURRENT_TIMEZONE[2]='EDT4'                        # EDT / Unix Timezone
NEXT_TZ_CHANGE[0]="Next Local Time change: [EDT(UTC-4) -> EST(UTC-5)]"      # This message does not automatically change
NEXT_TZ_CHANGE[1]='Sun Nov  6, 02:00:00 AM EDT'                             # This message does not automatically change

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


# Variables
NAME=( \
"${D}""Sydney, Australia" \
"${S}"'UTC+9    Japan (no DST)' \
"${S}"'UTC+8:   China/HK, Singapore, Philipines (no DST)' \
"${S}"'UTC+5.5: India  (no DST)' \
"${D}"'Israel' \
"${D}"'Paris, Barcelona' \
"${D}"'London' \
"${S}"'UTC' \
"${S}"'UTC-3    Sao Paolo [Brasilia Time] (no DST)' \
"${M}"'New York, Montréal, Toronto' \
"${D}"'Manitoba' \
"${D}"'Alberta' \
"${D}"'California, British Columbia' \
"${S}"'UTC-10   Hawaii (no DST)' \
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



# Start program
# Show or hide calculations
PRINT_CALC='1'               # Show Calculations
while getopts ":nm" opt; do
   case "${opt}" in
     n) PRINT_CALC='0';;     # Hide calculations with "-n" option
     m) clear; PRINT_CALC='2';;     # extra info with "-m" option
     *) ;;
   esac
done


# Header

printf "%-60b %-10b\n"  "${T}Location:"                               "${T}$CURRENT_CITY"
printf "%-60b %-10b\n"  "${M}Current time:"                           "$(TZ=${CURRENT_TIMEZONE[0]} date)"
#echo
printf "%-60b %-10b\n"  "${P}${NEXT_TZ_CHANGE[0]}" "${P}${NEXT_TZ_CHANGE[1]}"
#printf "%-20b %-38b %-20b %b\n" "${S}DAYLIGHT TIME:" "$(TZ=${CURRENT_TIMEZONE[2]} date +'%r %Z')" "${S}STANDARD TIME:" "$(TZ=${CURRENT_TIMEZONE[1]} date +'%r %Z')"
printf "%-20b %b\n" "${S}DAYLIGHT TIME:" "$(TZ=${CURRENT_TIMEZONE[2]} date +'%r %Z')"
printf "%-20b %b\n" "${S}STANDARD TIME:" "$(TZ=${CURRENT_TIMEZONE[1]} date +'%r %Z')"


echo -e "${BAR}"



# Timezones display
printf "%-65b %-20s %s\n"  "${T}Name" "(Unix location)" "TIME"
i=0
while [ $i -lt "${#NAME[@]}" ]; do
    printf "%-65b %-20s %s\n"  "${NAME[$i]}" "${TIMEZONE[$i]}" "$(TZ=${TIMEZONE[$i]} date)"
    i=$(( $i+1 ))
done
echo -e "${BAR}"



# Date Calculation examples
print_calculation_function(){
    printf "%-35b %b\n\n" "${T}Time and date commands:"     "${P}  <<  Only change what is in the quotes >>${C}"
    echo -e "${T}# It is 2pm EST (or EDT) in Montreal, what time is it in India? (IST)${C}"
    printf "%-60s %s\n" 'TZ=Asia/Calcutta date -d "14:00 EST"'             "# EST to IST"
    printf "%-60s %s\n" 'TZ=Asia/Calcutta date -d "1 Aug 2022 14:00 EST"'  "# EST (and optional date) to IST"
    printf "%-60s %s\n" 'TZ=Asia/Calcutta date -d "14:00 EDT"'             "# EDT to IST"

    echo
    echo -e "${T}# It is 2pm in India, what time is it in Montreal?${C}"
    printf "%-60s %s\n" 'TZ=EST date -d "14:00 IST"'                          "# IST to EST"
    printf "%-60s %s\n" 'TZ=EDT4 date -d "2:00 pm IST"'                       "# IST to EDT"
    printf "%-60s %s\n" 'TZ=America/New_York date -d "1 Aug 2022 14:00 IST"'  "# IST to local Montreal time, (and optional date)"

}

print_extrainfo_function(){
  echo
  printf "%-35b %b\n" "${T}Hide commands (-n option):" "${C}${0} -n${X}"
  printf "%-35b %b\n" "${T}To refresh once a minute:"  "${C}watch -c -n 60 \"${0} -n\"${X}"
  printf "%-35b %b\n" "${T}To see the local date:"     "${C}date${X}"
  

  echo "This script is easy to adjust:"
  echo "1) Simply add or remove names of cities from the \"TIMEZONE\" varible"
  printf "%-35b %b\n" "${T}To see a list of cities:"   "${C}timedatectl list-timezones | more${X}"
  echo "2) and add or remove the corresponding entry in the \"NAME\" array."
  echo "The \"NAME\" entry can be any name."
  
}


[ "${PRINT_CALC}" -ge '1' ] && print_calculation_function
[ "${PRINT_CALC}" == '1' ] && echo -e "${P}|==> No time/date commands (-n option)   |==>   more information (-m option)${C}"
[ "${PRINT_CALC}" == '2' ] && print_extrainfo_function
