#!/bin/bash

#this script will merge all last lines from all .tab files in the output folder
path2output="../Output"
path2bin="../bin"

#go to wd dir
cd $path2output
#check output file already exists.
if [ -a lastLines.dat ]; then
  echo "Warning lastLines.dat already exists. Press any key to continue or ctrl+c to abort"
  read answer
  rm lastLines.dat
fi

for i in $(ls *.tab); do
   #create header
	if [ ! -e lastLines.dat ]; then
   	head -n 1 $i  > h.tmp
   	echo -ne data\\t | cat - h.tmp > lastLines.dat
   fi
   #extract line
   if [ ! -n $1 ]; then
      sed -n ${1}p $i  > o.tmp
   else
    	tail -n 1 $i  > o.tmp
   fi
   #add line lastLines.dat
 	echo -ne ${i}\\t | cat - o.tmp | cat lastLines.dat - > p.tmp
   rm -f lastLines.dat
   mv p.tmp lastLines.dat
   #clean up
   rm -f *.tmp
done;

#return from wd dir
cd $path2bin


