# GROMACS first run: lysozyme in water

A small, ready-to-run GROMACS system for trying out a cluster or a workflow: hen egg-white lysozyme
([PDB 1AKI](https://www.rcsb.org/structure/1AKI)) in a water box, already minimised and equilibrated.
One production run of 1 ns takes a few minutes on one GPU.

| | |
|---|---|
| Atoms | 23,873 (1 protein, 7,287 waters, 22 Na⁺, 30 Cl⁻; 0.15 M NaCl, net charge 0) |
| Force field | AMBER99SB-ILDN, TIP3P water |
| Box | rhombic dodecahedron, 1.0 nm from protein to box edge |
| Ensemble | 300 K (V-rescale), 1 bar (C-rescale), 2 fs steps, H-bonds constrained |
| Run length | 1 ns (500,000 steps), a frame every 10 ps |
| Made with | GROMACS 2026.0 |

## Files

```text
system/
├── md.tpr      the run input: give this to gmx mdrun
├── md.mdp      the production settings md.tpr was made from
├── start.gro   equilibrated coordinates (end of 100 ps NPT)
├── start.cpt   equilibrated velocities and box (checkpoint)
├── topol.top   topology
└── posre.itp   position restraints (used only during equilibration)
build/
├── build.sh    rebuilds everything in system/ from 1AKI.pdb
├── 1AKI.pdb    the starting structure from the PDB
└── *.mdp       settings for ion placement, minimisation, NVT and NPT
```

## Run it

```bash
gmx mdrun -s md.tpr -deffnm md
```

A `.tpr` can only be read by the GROMACS version that made it, or a newer one. With an older GROMACS,
remake it first (inside `system/`):

```bash
gmx grompp -f md.mdp -c start.gro -t start.cpt -p topol.top -o md.tpr
```

## Rebuild from scratch

```bash
bash build/build.sh
```

Set `GMX=gmx_mpi` (or any other command) if your GROMACS is not called `gmx`. The build takes about
two minutes on a GPU workstation.

## Licence

Everything here is released under [CC0 1.0](LICENSE). The coordinates in `build/1AKI.pdb` come from the
Protein Data Bank (Artymiuk, Blake, Rice & Wilson, 1AKI), whose data are also free of copyright (CC0).
