#!/bin/bash

#this script will merge all last lines from all .tab files in the output folder
path2output="../Output"
path2bin="../bin"

#go to wd dir
cd $path2output
#check output file already exists.
if [ -a lastLines2.dat ]; then
  echo "Warning lastLines2.dat already exists. Press any key to continue or ctrl+c to abort"
  read answer
  rm lastLines2.dat
fi

   if [ $1  ]; then
      echo "using line $1 instead of the last line." 
   fi   


for i in $(ls *.tab); do
   #join both and add to lastLines.dat
   if [ ! -e lastLines2.dat ]; then
      #file does not exist create it using first column
      #create header
	   head -n 1 $i  > h1.tmp
      #remove first line && convert rows to columns 
      cat h1.tmp | tr -s \\t \\n | tail -n+2 - > h2.tmp
      #split the column using underscores as delimiter
      cat h2.tmp | tr -s _ \\t > h3.tmp
      #add column header TODO this could probably be done differently
      ncol=`(head -n 1 h3.tmp | awk '{ print NF}')` 
      count=1
      echo "factor${count}" > lastLines2.dat
      while [ $count -lt $ncol ] ; do
         count=`expr $count + 1`
         echo "factor${count}" | paste lastLines2.dat - > h4.tmp
         cp h4.tmp lastLines2.dat
      done
      #append row headers to column header
      cat h3.tmp >> lastLines2.dat
   fi   


   #extract line
   if [ $1  ]; then
    	sed -n ${1}p $i  > o1.tmp
   else
      tail -n 1 $i  > o1.tmp
   fi
   
   #incase of empty cells put NA which R understands
   sed -i 's/\t\t/\tNA\t/g' o1.tmp
   
   # convert rows to columns && remove first line
   cat o1.tmp  | tr -s \\t \\n | tail -n+2 - > o2.tmp   
   
   #add a column header
   echo "adding data column for ${i%.*}"
   echo ${i%.*} > o3.tmp
   cat o2.tmp >> o3.tmp
   
   #add data column to row headers
   paste lastLines2.dat o3.tmp > o4.tmp
   cp o4.tmp lastLines2.dat
   
   #read answer
done;

#remove troublesome characters
cat lastLines2.dat | tr -d \\\\ > clean.tmp
cat clean.tmp | tr -d \" > lastLines2.dat
   
#clean up
rm -f *.tmp

#return from wd dir
cd $path2bin


