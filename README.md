Desmond-scripts
===============

A number of scripts that are helpfull with a Desmond MD CLI-workflow.

# st2gen
Generates a st2-control file for use in distance analyses based on a simple data-file containing atom-numbers from a model.
The data-file is structured as: <name> <pair of atoms> <another pair of atoms>
Which resultings in a pair-wise distance analysis of the ligand trajectory.

# st2csv
Converts the resulting trajectory analysis -out.st2 to a csv file for easier processing.
Note that the TimeStep of 4.8ns is hardcoded in the script.
