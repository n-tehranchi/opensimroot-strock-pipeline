#!/bin/bash
SG=$1
P=$2
REP=${3:-1}
BINARY=~/OpenSimRoot/OpenSimRoot/StaticBuild/OpenSimRoot
TEMPLATE=~/opensimroot-strock-pipeline/InputFiles_strock_modern
OUTDIR=~/opensimroot-strock-pipeline/results_modern

declare -A SG_VALS
SG_VALS["Present"]=1.0
SG_VALS["Reduced0.5"]=0.5
SG_VALS["Absent"]=0.0

RUNNAME="SG_${SG}__P_${P}um__rep${REP}"
RUNDIR="$OUTDIR/$RUNNAME"
echo "Starting $RUNNAME..."

cp -r $TEMPLATE $RUNDIR

MULT=${SG_VALS[$SG]}
sed -i "s|^\t\t\t1\.0$|\t\t\t${MULT}|g" $RUNDIR/SecondaryGrowth.xml

P_VAL=$(python3 -c "import re; v=f'{float($P)*1e-3:.2e}'; print(re.sub(r'e-0(\d)', r'e-\1', v))")
sed -i "s|4\.00e-3|$P_VAL|g" $RUNDIR/Phosphorus.xml

cd $RUNDIR
$BINARY runBean.xml > $OUTDIR/${RUNNAME}.log 2>&1
echo "Done: $RUNNAME — exit $?"
