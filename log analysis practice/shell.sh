st=$(date +%s)
find . -regex '.*pro_inter_daily_[0-9]+.log' | while read file; do
# a=0
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
if(length($5)!=0){
  sum+=$3;sumProc+=$5;
  if($3>maxTime){maxTime=$3;}
  if($5>maxProc){maxProc=$5;}
  i++;
}
}
END{sum=sum/i;sumProc=sumProc/i;printf("Average Time : %s\nMax Time : %s\nAverage Proc : %s\nMax Proc : %s\n", sum, maxTime, sumProc, maxProc);}' > result.log
fin=$(date +%s)
dif=$(( fin-st ))
h=$(( dif/3600 ))
m=$(( (dif-h*3600)/60 ))
s=$(( dif-h*3600-m*60 ))
echo "It took $h hours, $m minutes, $s seconds"
