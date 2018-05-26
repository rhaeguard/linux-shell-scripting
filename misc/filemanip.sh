#!/bin/sh

#sed -E 's/[[:digit:]]+ ([[:alpha:]]+)/\1/g'

#finds and replaces
#cat file_1 | sed -E 's/([[:alnum:]]+\|)([[:alnum:]]+\|)[[:alnum:]]+(\|[[:alnum:]]+\|)([[:alnum:]]+)/\1\2\3\4/g'

mkdir out
arr=( 10 15 20 21 30 35 65 66 80 85 95 97 99)
for i in "${arr[@]}"
do
cat "file_$i" | sed -E 's/([[:alnum:]]+\|)([[:alnum:]]+\|)[[:alnum:]]+(\|[[:alnum:]]+\|)([[:alnum:]]+)/\1\2\3\4/g' > "file_$i"
done

#inplace

arr=( 10 15 20 21 30 35 65 66 80 85 95 97 99 )
for i in "${arr[@]}"
do
sed -i -E 's/([[:alnum:]]+\|)([[:alnum:]]+\|)[[:alnum:]]+(\|[[:alnum:]]+\|)([[:alnum:]]+)/\1\2\3\4/g' "file_$i"
done

####

ls | while read line; do
var=$( grep -E -c '\|\|' $line )
if [ $var -eq 1 ] 
then
sed -i -E 's/(\|)(\|)/\1STRING_REP\1/g' ${line}
fi
sed -i -E 's/([[:alnum:]]+)$/FIFTH_REP/g' ${line}
done

####
res=$( cat * | awk -F"\|" '{print $3}' )
echo "$res" | while read line; do
var=$( echo "$res" | grep -E -c $line )
echo "$line $var"
done | sort -n -r -k2 | uniq | awk 'BEGIN{printf "%16sThird Column\n"; printf "%32s - %2s \n","String", "Repetitions"}{printf "%32s - %2d \n",$1,$2}END{printf "=============================================\n"}'

res=$( cat * | awk -F"\|" '{print $5}' )
echo "$res" | while read line; do
var=$( echo "$res" | grep -E -c $line )
echo "$line $var"
done | sort -n -r -k2 | uniq | awk 'BEGIN{printf "Fifth Column\n"; printf "%32s - %2s \n","String", "Repetitions"}{printf "%32s - %2d \n",$1,$2}END{printf "=============================================\n"}'


awk -F"\|" '{print $3}' ./* | sort | uniq -c


########
