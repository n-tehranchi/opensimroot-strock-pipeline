#!/bin/bash
 ./compartiveGraph.sh "grep rootRespiration" 'rootRespiration' 3
 ./compartiveGraph.sh "grep rootLength | grep bean | grep  -v Density" 'rootLength' 3
 ./compartiveGraph.sh "grep shootDryWeight" 'shootBiomass' 3
 ./compartiveGraph.sh "grep plantNutrientUptake | grep phosphorus" 'Phosphorousuptake' 3
./compartiveGraph.sh "grep plantDryWeight" 'plantbiomass' 3
./compartiveGraph.sh "grep rootDryWeight" 'rootBiomass' 3
./compartiveGraph.sh "grep rootVolume" 'rootvolume' 3
./compartiveGraph.sh "grep carbonAllocation2Roots" 'Ctoroots' 3
./compartiveGraph.sh "grep carbonAllocation2Shoot" "Ctoshoot' 3

 
 ./lastLines.sh
 ./lastLines2.sh
# ./generatePlots.sh 

