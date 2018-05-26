#!/bin/bash

awk -F';' '/Begin/ {print $7}' pro_inter_daily_20180507000000.log | awk -F'=' '{print $2}' | awk -F'/' '{print $NF}' | while read line; do
egrep "$line" pro_inter_daily_20180507000000.log | sed -e 1b -e '$!d' | sed -E 's/process nums=([[:digit:]]+)/;\1;/g'

# finds begin and extracts time/file name

# rm input.txt
# awk -F';' '/Begin/ {print $1, $7}' pro_inter_daily_20180507000000.log | awk '{print $1, $2, $7}' | sed -E 's|([0-9\s\:-]+)\sfile=(.*)|\1 \2|g' >> input.txt
# awk -F";" '/Output/ {print $1, $7}' pro_inter_daily_20180507000000.log | awk '{print $1, $2, $6}' | sed -E 's|([0-9\s\:-]+)\sFileName=(.*),Original|\1 \2|g' >> input.txt


# ([0-9\s\:-]+)\sFileName=(.*),Original
# | grep -oP ''
# sed -E 's/([[[:digit:]][[:space:]][[:punct:]]]+).*file=[[:punct:]]([[:alnum:]])$/\1\2/g'
# egrep -F 'file=\/(.*)$'
# ([0-9- ]+).*file=\(/.*)$

# egrep -o /home/prminter/cdr/src/inter/orig_cdr/hw_msc/sms/20180506/AZF_MSSBHQH_2AZFHUA1_b00125479 pro_inter_daily_20180507000000.log

a=0
awk -F';' '/Begin/ {print $7}' pro_inter_daily_20180507000000.log | awk -F'=' '{print $2}' | awk -F'/' '{print $NF}' | while read line; do
egrep "$line" pro_inter_daily_20180507000000.log | sed -e 1b -e '$!d' | awk -F';' -v line="$line" 'BEGIN{i=0;}{if(i==1){second=$1;}else{first=$1}i++;}
END{
print first, second, line;
}' | awk '{
time1=$2;time2=$4;
gsub( /-/, " ", time1 ); gsub( /:/, " ", time1 );
t2 = mktime($1" "time1);
gsub( /-/, " ", time2 ); gsub( /:/, " ", time2 );
t4 = mktime($3" "time2);
diff=t4-t2;
printf("%-19s\t%-19s\t%8s\t%s\n", $1" "$2, $3" "$4, diff , $5)
}'
a=$(( a+1 ))
if [ $a -eq 5 ]
then
  break
fi
done | awk 'BEGIN{printf("%-19s\t%-19s\t%8s\t%s\n", "Start", "End", "Duration" ,"Filename");sum=0}{print $0;sum+=$5}END{sum=sum/NR;print "Average : "sum;}'

# awk -F';' '/Begin/ {print $7}' pro_inter_daily_20180507000000.log | awk -F'=' '{print $2}' | awk -F'/' '{print $NF}' | while read line; do
# egrep "$line" pro_inter_daily_20180507000000.log | awk 'NR==1; END{print}' | awk -F';' -v line="$line" 'BEGIN{i=0;}{if(i==1){second=$1;}else{first=$1}i++;}
# END{
# print first, second, line;
# }' | awk '{
# gsub( /-/, " ", $2 ); gsub( /:/, " ", $2 );
# t2 = mktime($1" "$2);
# gsub( /-/, " ", $4 ); gsub( /:/, " ", $4 );
# t4 = mktime($3" "$4);
# diff=t4-t2;
# print diff
# }'
# break
# done

# gsub( /-/, " ", $2 ); gsub( /:/, " ", $2 );
# t2 = mktime($2);
# gsub( /-/, " ", $4 ); gsub( /:/, " ", $4 );
# t4 = mktime($4);
# print t2, t4





 # | awk 'NR==1; END{print}'

# | awk -F';' 'BEGIN{i=0;}{initTime=$1;if(i==1){secTime=$1;}i++;path=$7}END{printf("%s %s", secTime, path);}'


#egrep AZF_MSSBHQH_2AZFHUA1_b00125514.dat_DECODED_2942_HW_MSC_SMS_IDD_ROAMIN pro_inter_daily_20180507000000.log | awk -F';' 'BEGIN{i=0;}{initTime=$1;if(i==1){secTime=$1;}i++;path=$7}END{printf("%s %s\n", secTime, path);}'

#AZF_MSSBHQH_2AZFHUA1_b00125514.dat_DECODED_2942_HW_MSC_SMS_IDD_ROAMIN
# Finds the records and writes to a file
st=$(date +%s)
find . -regex '.*pro_inter_daily_[0-9]+.log' | while read file; do
#a=0
dos2unix $file
awk -F';' '/Begin to decode a file/ {print $7}' $file | awk -F'=' '{print $2}' | awk -F'/' '{print $NF}' | while read line; do
egrep "$line" $file | sed -e 1b -e '$!d' | sed -E 's/process nums=([[:digit:]]+)/;\1;/g' | awk -F';' -v line="$line" 'BEGIN{i=0;}{if(i==1){second=$1;}else{first=$1}i++;}
END{
print first, second, line, $8;
}' | awk '{
time1=$2;time2=$4;
gsub( /-/, " ", time1 ); gsub( /:/, " ", time1 );
t2 = mktime($1" "time1);
gsub( /-/, " ", time2 ); gsub( /:/, " ", time2 );
t4 = mktime($3" "time2);
diff=t4-t2;
printf("%-19s\t%-19s\t%8s\t%-80s\t%-4s\n", $1" "$2, $3" "$4, diff , $5, $6)
}'
# a=$(( a+1 ))
# if [ $a -eq 5 ]
# then
#   break
# fi
done | awk -v filename="$file" 'BEGIN{print "\nFile : "filename}{print $0}'
done | awk -F'\t' 'BEGIN{printf("%-19s\t%-19s\t%8s\t%-80s\t%-4s\n", "Start", "End", "Duration" ,"Filename", "Procnum");sum=0;sumProc=0;maxTime=0;maxProc=0;i=0}
{
print $0;
if($5!="" && $3!="" && $3>0 && $5>0 ){
  sum+=$3;sumProc+=$5;
  if($3>maxTime && length($5)!=0){maxTime=$3;}
  if($5>maxProc && length($5)!=0){maxProc=$5;}
  i++;
}
}
END{sum=sum/i;sumProc=sumProc/i;printf("Average Time : %s\nMax Time : %s\nAverage Proc : %s\nMax Proc : %s\n", sum, maxTime, sumProc, maxProc);}' > result.log
fin=$(date +%s)
dif=$(( fin-st ))
h=$(( dif/3600 ))
m=$(( (dif-h*3600)/60 ))
s=$(( dif-h*3600-m*60 ))
echo "It took $h hours, $m minutes, $s seconds" >> result.log




























a=0
awk -F';' '/Begin/ {print $7}' pro_inter_daily_20180507014543.log | awk -F'=' '{print $2}' | awk -F'/' '{print $NF}' | while read line; do
egrep "$line" pro_inter_daily_20180507014543.log | sed -e 1b -e '$!d' | sed -E 's/process nums=([[:digit:]]+)/;\1;/g' | awk -F';' -v line="$line" 'BEGIN{i=0;}{if(i==1){second=$1;}else{first=$1}i++;}
END{
print first, second, line, $8;
}' | awk '{
time1=$2;time2=$4;
gsub( /-/, " ", time1 ); gsub( /:/, " ", time1 );
t2 = mktime($1" "time1);
gsub( /-/, " ", time2 ); gsub( /:/, " ", time2 );
t4 = mktime($3" "time2);
diff=t4-t2;
printf("%-19s\t%-19s\t%8s\t%-80s\t%-4s\n", $1" "$2, $3" "$4, diff , $5, $6)
}'
a=$(( a+1 ))
if [ $a -eq 5 ]
then
  break
fi
done | awk -F'\t' 'BEGIN{printf("%-19s\t%-19s\t%8s\t%-80s\t%-4s\n", "Start", "End", "Duration" ,"Filename", "Procnum");sum=0;sumProc=0;maxTime=0;maxProc=0;}
{print $0;sum+=$3;sumProc+=$5;if($3>maxTime){maxTime=$3;}if($5>maxProc){maxProc=$5;}}
END{sum=sum/NR;sumProc=sumProc/NR;printf("Average Time : %s\tMax Time : %s\tAverage Proc : %s\tMax Proc : %s\n", sum, maxTime, sumProc, maxProc);}'



2018-05-07 00:00:19;
LOG_INFO_MSG;
0;
pro_inter_daily;
Component.Write.StandardWriter172718;
CWriter.cpp[440];
Stdwriter process end:Output FileName=/home/prminter/cdr/src/inter/stat_cdr/AZF_MSSBHQH_1AZFHUA1_b00141056.dat_DECODED_2725_HW_MSC_SMS_IDD_ROAMIN_20180507000019_02697832,Original FileName=AZF_MSSBHQH_1AZFHUA1_b00141056.dat_DECODED_2725_HW_MSC_SMS_IDD_ROAMIN,;
258;
,right nums=258,exception nums=0
