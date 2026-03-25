import pandas as pd
import os
import re

outputs_dir = "/pipeline/outputs"
frames = []

for fname in sorted(os.listdir(outputs_dir)):
    if not fname.endswith(".tab"):
        continue

    # Parse treatment labels from filename: SG_Present__P_4um.tab
    m = re.match(r"SG_(.+)__P_(.+)\.tab", fname)
    if not m:
        continue
    sg, p = m.group(1), m.group(2)

    try:
        df = pd.read_csv(os.path.join(outputs_dir, fname), sep="\t")
    except Exception as e:
        print(f"WARNING: could not read {fname}: {e}")
        continue

    df["secondary_growth"] = sg
    df["phosphorus_um"] = p
    frames.append(df)

if not frames:
    print("ERROR: no .tab files found in outputs dir")
    exit(1)

summary = pd.concat(frames, ignore_index=True)
out_path = os.path.join(outputs_dir, "results_summary.csv")
summary.to_csv(out_path, index=False)
print(f"Wrote {len(summary)} rows across {len(frames)} runs to {out_path}")
