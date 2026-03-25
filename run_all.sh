#!/bin/bash
set -e

PIPELINE=/pipeline
OUTPUTS=$PIPELINE/outputs
mkdir -p "$OUTPUTS"

SG_LEVELS="Present Reduced0.5 Absent"
P_LEVELS="1um 4um 7um 10um 13um 16um 19um 25um 30um"

for sg in $SG_LEVELS; do
  for p in $P_LEVELS; do
    echo "=== Running SG=$sg  P=$p ==="

    # Fresh working directory for each run
    WORKDIR=$(mktemp -d)
    cp -r $PIPELINE/InputFiles/. "$WORKDIR/"

    # Copy replacement XMLs into position (overwrite the defaults)
    cp "$PIPELINE/Replacements/SecondaryGrowth/${sg}.xml" "$WORKDIR/SecondaryGrowth.xml"
    cp "$PIPELINE/Replacements/Phosphorus/${p}.xml"       "$WORKDIR/Phosphorus.xml"

    # Run simulation from the working directory
    cd "$WORKDIR"
    $PIPELINE/SimRoot -f runBean.xml

    # Collect tabled_output.tab and name it by treatment
    OUTPUT_NAME="SG_${sg}__P_${p}.tab"
    cp "$WORKDIR/tabled_output.tab" "$OUTPUTS/$OUTPUT_NAME"

    cd "$PIPELINE"
    rm -rf "$WORKDIR"

    echo "    Saved: $OUTPUT_NAME"
  done
done

echo "=== All 27 runs complete. Running summarize.py ==="
python3 $PIPELINE/summarize.py

echo "=== Pushing results to GitHub ==="
cd "$OUTPUTS"
git config --global user.email "pipeline@runai"
git config --global user.name "RunAI Pipeline"
git add .
git commit -m "Strock Option B results: 27 runs (3 SG x 9 P)"
git push

echo "=== Done ==="
