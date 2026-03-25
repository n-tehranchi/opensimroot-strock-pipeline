#!/bin/bash

#this script will create a dataset and graph from repeated runs

path2output="../Output"
path2bin="../bin"
searchString=$1   #"leafArea"
filter=$2   # ma\"
filter2=$3   # ma\"

echo "processing ${0} ${1} ${2} ${3}"

#go to wd dir
cd $path2output
#check output file already exists.
if [ -a ${searchString}.Rates.tab ]; then
  echo "Warning ${searchString}.tab already exists."
  exit 1
fi

#loop through folder with output
count=0
for i in $(ls ); do
 #check if this is folder with data
 datafile=$i/tabled_output.tab;
 if [ -f $datafile ]; then

   #collect the data column
   if [ "$filter" == "-v" ] ; then
	   cat "${datafile}" | grep "$searchString" | grep -v "$filter2" | cut -f4 > dat.tmp
	else
	   cat "${datafile}" | grep "$searchString" | grep "$filter" | cut -f4 > dat.tmp
	fi
	
	#add the column header
	echo ${i} | cat - dat.tmp > hdat.tmp
	
	#add the the column to to the file
	if [ -a ${searchString}.Rates.tab ]; then
	   #check length, and if necessary pad the lenth
	   lfile=`cat $searchString.Rates.tab | wc -l`
	   ldata=`cat hdat.tmp | wc -l`
	   nrword=`head -n 1 $searchString.Rates.tab | wc -w`
	   while [ $lfile -lt $ldata ]; do
	      #add a line to file
         echo -n "NA"	>>  $searchString.Rates.tab        
         count=1;
	      while [ $count -lt $nrword ]; do
            echo -en "\tNA"	>>  $searchString.Rates.tab        
            count=$(expr $count + 1)
	      done	      
         echo -en "\n"	>>  $searchString.Rates.tab        
   	   lfile=$(expr $lfile + 1)
	   done
	   lfile=`cat $searchString.Rates.tab | wc -l`
	   ldata=`cat hdat.tmp | wc -l`
	   while [ $lfile -gt $ldata ]; do
	      #add a line to file
         echo "NA"	>>  hdat.tmp
   	   ldata=$(expr $ldata + 1)
	   done
	   #file exists just add the column to it
      paste $searchString.Rates.tab hdat.tmp > r.tmp
      rm -f $searchString.Rates.tab
      mv r.tmp $searchString.Rates.tab
   else
      #file does not exist, create it with x column listing the times than add the data column
      #time column
      if [ "$filter" == "-v" ] ; then
        	cat "$datafile" | grep "$searchString" | grep -v "$filter2" | cut -f2 > time.tmp
	   else
      	cat "$datafile" | grep "$searchString" | grep "$filter" | cut -f2 > time.tmp
	   fi
	   #add column header to time column
   	echo "time(day)" | cat - $path2output/time.tmp > htime.tmp
   	#paste time and column into file 
      paste $path2output/htime.tmp $path2output/hdat.tmp > $searchString.Rates.tab
   fi
   #read answer
   
   #clean up temporary files
   #read answer
   rm -f *.tmp

 fi 
done;

#return from wd dir
cd $path2bin

