#!/usr/bin/env bash
# Rebuilds system/ from 1AKI.pdb with GROMACS (tested with 2026.0).
# Usage: bash build.sh            (needs `gmx` on PATH; set GMX=... to override)
set -euo pipefail
GMX=${GMX:-gmx}
cd "$(dirname "$0")"
grep -v HOH 1AKI.pdb > clean.pdb
$GMX pdb2gmx -f clean.pdb -o processed.gro -p topol.top -ff amber99sb-ildn -water tip3p -ignh
$GMX editconf -f processed.gro -o box.gro -c -d 1.0 -bt dodecahedron
$GMX solvate -cp box.gro -cs spc216.gro -o solv.gro -p topol.top
$GMX grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr -maxwarn 1   # net charge: neutralised by genion next
echo SOL | $GMX genion -s ions.tpr -o ions.gro -p topol.top -pname NA -nname CL -neutral -conc 0.15
$GMX grompp -f em.mdp  -c ions.gro -p topol.top -o em.tpr  && $GMX mdrun -deffnm em
$GMX grompp -f nvt.mdp -c em.gro  -r em.gro  -p topol.top -o nvt.tpr && $GMX mdrun -deffnm nvt
$GMX grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr && $GMX mdrun -deffnm npt
cp npt.gro ../system/start.gro
cp npt.cpt ../system/start.cpt
cp topol.top posre.itp ../system/
cd ../system
$GMX grompp -f md.mdp -c start.gro -t start.cpt -p topol.top -o md.tpr
