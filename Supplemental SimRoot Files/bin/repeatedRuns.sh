
#!/bin/bash

#this script will run simroot with different parameter sets. It simply replaces input files. 

executable="SimRoot"
path2inputfiles="../InputFiles"
inputfile="main-testing.xml"
#note be carefull with parallel processing - you could run out of memory very easily
maxnumberofprocesses=0
path2output="../Output"
path2bin="../bin"
count=0

#support for 3 factors
path2replacementfiles1="../Replacements/SecondaryGrowth"
replacefile1="SecondaryGrowth.xml"
path2replacementfiles2="../Replacements/Phosphorus"
replacefile2="Phosphorus.xml"
#path2replacementfiles3="../Replacements/growthrates"
#replacefile3="plantParameters/Barley/variationMultipliersGrowthRates.xml"

function stripExtension(){
   echo ${1%.*}
}

#check output folder exists
if [ -d $path2output ]; then
   #folder exists check if path2Output is empty
   if [ "$(ls -A $path2output)" ]; then
        echo "Take action $path2output is not Empty"
        echo "Press any key to continue, data will be erased. Use ctrl+C to abort"
        read answer
        rm -drf $path2output/*
   fi
else
   mkdir $path2output
fi


for rep in "rep0" "rep1" "rep3" "rep4" ; do # "rep1" "rep2" "rep3" "rep4" "rep5" "rep6" "rep7" "rep8" "rep9" "rep10" "rep11"

for i in $(ls $path2replacementfiles1/*.xml); do
for j in $(ls $path2replacementfiles2/*.xml); do
#for k in $(ls $path2replacementfiles3/*.xml); do
   #strip folder
   ib=$(basename $i)
   jb=$(basename $j)
   #kb=$(basename $k)
   #strip extension 
   is=$(echo ${ib%.*})   #stripExtension $i
   js=$(echo ${jb%.*})
   #ks=$(echo ${kb%.*})
   c="${is}_${js}_${rep}" #c is the folder name and needs to be unique
   #c="${is}_${rep}"
  	ndir=$path2output/$c
	echo "preparing $c"

 	mkdir $ndir;
	mkdir $ndir/InputFiles;
	cp -lr $path2inputfiles/* $ndir/InputFiles ;

	rm -f $ndir/InputFiles/$replacefile1;
	rm -f $ndir/InputFiles/$replacefile2;
	#rm -f $ndir/InputFiles/$replacefile3;
	cp $path2replacementfiles1/$ib $ndir/InputFiles/$replacefile1;
	cp $path2replacementfiles2/$jb $ndir/InputFiles/$replacefile2;
	#cp $path2replacementfiles3/$kb $ndir/InputFiles/$replacefile3;

	cd $ndir;
	cp -l ../$path2bin/$executable ./
	cp ../$path2bin/job.sh ./

	qsub -N Etiolation_nonstratified ./job.sh & 
	
	cd ../$path2bin;

done;
done;
done;
#done;


