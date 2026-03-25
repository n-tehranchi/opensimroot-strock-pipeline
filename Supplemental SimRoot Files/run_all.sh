#!/bin/bash
set -e

PIPELINE=/pipeline
OUTPUTS=$PIPELINE/outputs
mkdir -p "$OUTPUTS"

SG_LEVELS="Present Reduced0.5 Absent"
P_LEVELS="1um 2um 3um 4um 5um 6um 8um 16um 30um"

for sg in $SG_LEVELS; do
  for p in $P_LEVELS; do
    echo "=== Running SG=$sg  P=$p ==="

    WORKDIR=$(mktemp -d)
    cp -r $PIPELINE/InputFiles/. "$WORKDIR/"

    # Copy replacement XMLs into position
    cp "$PIPELINE/Replacements/SecondaryGrowth/${sg}.xml"  "$WORKDIR/SecondaryGrowth.xml"
    cp "$PIPELINE/Replacements/Phosphorus/${p}.xml"        "$WORKDIR/Phosphorus.xml"

    # Run simulation
    cd "$WORKDIR"
    $PIPELINE/SimRoot -f runBean.xml

    # Collect output
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
git commit -m "Add Strock Option B results: 27 runs (3 SG × 9 P)"
git push