#!/bin/bash

SMART_ATRIBUTE=("4" "5" "7" "9" "10" "12" "183" "184" "187" "188" "195" "196" "197" "198" "201")
SMART_ATRUBUTE_NAME=("Start_Stop_Count" "Reallocated_Sector_Ct" "Seek_Error_Rate" "Power_On_Hours" "Spin_Retry_Count" "Power_Cycle_Count" "Runtime_Bad_Block" "End-to-End_Error" "Reported_Uncorrect" "Command_Timeout" "Hardware_ECC_Recovered" "Reallocated_Event_Count" "Current_Pending_Sector" "Offline_Uncorrectable" "Soft_Read_Error_Rate")
FEED=("41963" "41964" "41965" "41966" "41967" "41968" "41969" "41970" "41971" "41972" "41973" "41974" "41975" "41976" "41977")
n=${#FEED[@]} # number of elemenets in array, used for loops
APIKEY="ENTER YOUR API KEY HERE"

smartctl -a /dev/sdb > smart.tmp

for (( i=0; i<6; i++ ));
do
  SA[i]=`grep ${SMART_ATRUBUTE_NAME[i]} smart.tmp|tr -s ' ' | cut -d ' ' -f 11`
done

for (( i=6; i<15; i++ ));
do
  SA[i]=`grep ${SMART_ATRUBUTE_NAME[i]} smart.tmp|tr -s ' ' | cut -d ' ' -f 10`
done

for (( i=0; i<n; i++ ));
do
  echo ${SMART_ATRIBUTE[$i]} ${SMART_ATRUBUTE_NAME[$i]} ${SA[$i]}
  curl 'http://api.sen.se/events/?sense_key='$APIKEY -X POST -H "Content-type: application/json" -d '[{"feed_id": '${FEED[$i]}',"value": '${SA[$i]}'}]' && sleep 0
done
echo -e "\n"

rm smart.tmp
