# FixedWingGG-Power

A quasi-steady model simulating the reel-out and reel-in phases of fixed-wing ground-generation airborne wind energy systems. The model is formulated as an optimisation problem where the net electrical cycle power of a system is maximised for given wind conditions.

1. The model accounts for the effects of pattern elevation, mass (gravity), vertical wind shear, and drivetrain losses.
2. It is suitable for sensitivity and scalability studies, making it a valuable tool for evaluating design and innovation trade-offs.
3. It is suitable for integration with cost models and systems engineering tools. This enhances the applicability of the proposed model in exploring the potential of airborne wind energy in the energy system.


## How to cite

If you use the model then please cite:

1. [GitHub release]
1. [Paper]


## Dependencies

The model is built and tested in MATLAB R2021b (without additional add-ons). Try installing this version if your version of MATLAB does not execute the code successfully.


## Installation and execution 

Please Clone or Download the repository to start using the model.



## Overview of the Repository

The Repository consists of 3 Folders:

1. `Src`: Contains the source code of the model.
2. `InputSheets`: Contains some pre-defined input files.
3. `OutputFiles`: Contains some generated output files using the pre-defined input files.


## Pre-defined Example Simulation

A pre-defined input file named `inputSheet_Example.m` is stored in the folder `InputSheets`. This input file simulates a system with rated electrical power of 150 kW.
1. Execute `runSimulation.m` to generate and save model outputs. The outputs will be stored in the folder `OutputFiles`. Name of every output file is prefixed with the respective input sheet name.
2. Execute `runplotResults.m` to visualize relevant outputs.


## To Run with User-defined Inputs

1. A data structure named 'inputs' needs to be created with all necessary inputs as defined in `inputSheet_Example.m` from the `InputSheets` folder.
2. Results can be generated by executing the script `runSimulation.m`. Within the script, ensure to pass as an argument, the name of your newly defined input sheet.
3. Results can be visualized by executing the script `runplotResults.m`. Within the script, ensure to pass as an argument, the name of your newly defined input sheet.

### Generated Output Files

1. `optimDetails` has the details regarding the optimization.
2. `outputs` has all the raw outputs.
3. `processedOutputs` has post-processed relevant outputs for better visualization.


## LICENSE

MIT License


## Author Details

Name: Rishikesh Joshi  
Email: [r.joshi@tudelft.nl](mailto:r.joshi@tudelft.nl), [rishikeshsjoshi@gmail.com](mailto:rishikeshsjoshi@gmail.com)  
Affiliation: Wind Energy Section, Delft University of Technology





