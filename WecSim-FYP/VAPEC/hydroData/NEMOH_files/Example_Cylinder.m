%%%% Example - Cylinder
% 
% This script demonstrates the use of NEMOH for on a Cylindrical buoy. The
% process is divided into sections the emphasize the modular approach that
% may be taken e.g. the meshing process could be replaced by loading a
% pre-existing mesh and converting to the same formate etc.
% 
% This script could be considered a basic template for NEMOH processes. It
% should be run within it's current directory 
% 
% Author: Benjamin Schubert
% Date: 07/06/2018

close all
clear
clc

%% Mesh
% This step forms a cylinder through a custom function (createCylinder),
% and remeshes it 

% Add path to functions
addpath(fullfile('.','Functions'))

% Cylinder
nBodies = 1; % Number of bodies
cylinder.a = 2.5; % m, radius of cylinder
cylinder.H = 8; % m, height of cylinder
cylinder.nUnits = 12; % Influences resolution of cylinder, higher = larger computational time

[nodes, nPanels] = createCylinder(cylinder); % get panels describing geometry

% Note: for different geometries, change the mesh function such as:
% [nodes, nPanels] = createSphere(sphere); % get panels describing geometry
% And then change the names from 'Cylinder' to 'Sphere' for consistency

subDepth =  1; % m, submergence depth from water surface buoy centre

% translations
x_trans = 0;
y_trans = 0; % Sway, nobody likes sway...
z_trans = -subDepth;
nodes(1,:,:,1) = nodes(1,:,:,1) + x_trans;
nodes(1,:,:,2) = nodes(1,:,:,2) + y_trans;
nodes(1,:,:,3) = nodes(1,:,:,3) + z_trans;

n = nPanels; % Number of panels provided
tX = 0; % translations (inter-body)
CG = [x_trans,y_trans,z_trans]; % center of gravity (used as center of rotation)
nfobj = 100; % Target number of panels for new meshing algorithm
ShapeName = ['Cylinder' datestr(date,'_dd_mm_yyyy')]; % Name of the file created

% Creates various files used by Nemoh and runs Mesh.exe
[Mass,Inertia,KH,XB,YB,ZB]=Mesh(nBodies,n,nodes,tX,CG,nfobj,ShapeName);
outputName = 'mesh1.dat'; % Default output name

% Read in number of points and faces
oldDir = pwd;
cd(fullfile('.', ShapeName, 'mesh'))
fid = fopen('mesh1.tec','r');
[numbers, ~] = fscanf(fid, '%s');
nMesh=sscanf(numbers, 'ZONEN=%d,E=%d,');
fclose(fid);
cd(oldDir)

nx = nMesh(1); % Number of points
nf = nMesh(2); % Number of faces


% % Optional MeshMagick step (comment out if not installed)
% InputMesh = 'mesh1.tec';
% outputNameTemp = ['Output' '.mar']; % specify output name
% 
% % Run MeshMagick
% oldDir = pwd;
% cd(fullfile('.', ShapeName, 'mesh'))
% command = ['meshmagick ' InputMesh ' -sym ' ' --show ' ' -o ' outputNameTemp]; % Many more options available such as flip normals, translate/rotate, heal etc.
% unix(command)
% 
% % Assign new mesh for NEMOH
% outputName = outputNameTemp;
% cd(oldDir)
% 
% % .mar file should have a 2, and a 0 at the top, may require manual
% % changiner


%% Input files

% Physical Properties
rho=1025; % kg/m^3, density of water
g=9.81; % m/s^2, accerleration of gravity

% Construct Nemoh.cal file with various inputs
writeNemoh(rho,g,nBodies,ShapeName,nx,nf,CG,outputName);

%% Run Nemoh

% Wave conditions
w = linspace(0.1,5,50); % rad/s, frequencies sampled
depth = 50; % depth of water, 0 for deep
dir = 0; % Wave direction, 0 for straight along x axis

addpath(fullfile('.','Nemoh'))
[A,B,Fe,Famp,Fphi,Ainf] = runNemoh(w, dir, depth);
rmpath(fullfile('.','Nemoh'))

% remove path to functions
rmpath(fullfile('.','Functions'))

%% Save results

% Create structure for results
results.a = cylinder.a;
results.H = cylinder.H;
results.d = depth;
results.subDepth = subDepth;
results.Ainf = Ainf;
results.A = A;
results.B = B;
results.Famp = Famp;
results.Fphi = Fphi;
results.Fe = Fe;

% save in results directory
oldDir = pwd;
cd(fullfile('.', ShapeName, 'results'))
save('results','results')
cd(oldDir)

% To load, simply have "load('results')" in the correct directory