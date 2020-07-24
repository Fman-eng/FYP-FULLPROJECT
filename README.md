# Setup guide for Wave Energy Converter Final Year Project
This repository includes preinstalled versions of WEC-Sim, Moordyn and Nemoh. WEC-Sim is still under active development and updates can be found on the [WEC-Sim GitHub repository](https://github.com/WEC-Sim/wec-sim).
## WEC-Sim Setup
WEC-Sim requires these add ons be installed on MATLAB:
* Simulink
* Simscape
* Simscape Multibody

Please use the latest version of MATLAB or atleast version R2019b.

WEC-Sim adds additional functions and simscape blocks stored in the source folder which need to be added to the matlab path on startup. This can be done using the startup.m file contained in the root project folder. To have matlab run this script on startup the default startup folder can be set to the root project folder. This can be done by going to the MATLAB home tab -> enviroment -> preferences -> MATLAB -> general, and changing the intial working folder to the project root folder. If you already use a startup.m script and don't want to change the intial working dirrectory you may instead follow the instructions in the incuded startup.m script to add the source folder to the path from a different startup.m script.

Visit the [WEC-Sim website](http://wec-sim.github.io/WEC-Sim) for more information on WEC-SIMs features and usage.
## MOORDYN
MoorDyn is used to simulate the WECs mooring line system. MoorDyn requires a c++ compiler for MATLAB, I recommend the MinGW-w64 C/C++ Compiler by MathWorks Supported Compilers Team. This can be installed though the add on browser or from the [MathWorks website](https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler).
More information about MoorDyn can be found at its creator Matt Halls [website](http://www.matt-hall.ca/moordyn.html).
# NEMOH
Nemoh is an open source Boundry Element Method solver used to generate the hydrodynamic data for WECs which is used by WEC-Sim to compute the time domain response of the WEC. Currently only support for simple cylindrical shapes is implimented. Configuring and running the Run_Cylinder.m script in the WecSim-FYP/NEMOH_files folder will generate the required hydrodynamic data. This will be saved in the specified folder defined in the Run_Cylinder.m script. This folder must then be placed in the hydroData folder in WEC-Sim