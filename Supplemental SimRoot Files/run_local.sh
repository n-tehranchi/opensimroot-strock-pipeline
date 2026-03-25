'''
repeatedRuns.sh conceptually
for each SecondaryGrowth condition (Present, Reduced0.5, Absent):
    for each Phosphorus level (1um, 4um, ... 30um):
        1. make a fresh output folder
        2. copy all input files into it
        3. swap in the two replacement files
        4. run SimRoot from that folder

some_folder/
├── InputFiles/
│   ├── SecondaryGrowth.xml   ← contains multiplier=1.0
│   ├── Phosphorus.xml        ← contains 4e-3 concentration
│   └── ... (all other input files)
└── SimRoot                   ← the binary
which is why we create a separate foldr per combo each time

runBean.xml:
<SimulaIncludeFile fileName="simulationControlParameters.xml"/>
<SimulaIncludeFile fileName="templates/plantTemplateFullModel.xml"/>
'''