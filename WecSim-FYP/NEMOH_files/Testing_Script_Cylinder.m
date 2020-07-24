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
cylinder.a = 10; % m, radius of cylinder
cylinder.H = 5.5; % m, height of cylinder
cylinder.nUnits = 20; % Influences resolution of cylinder, higher = larger computational time

[nodes, nPanels] = createCylinder(cylinder); % get panels describing geometry

% Note: for different geometries, change the mesh function such as:
% [nodes, nPanels] = createSphere(sphere); % get panels describing geometry
% And then change the names from 'Cylinder' to 'Sphere' for consistency

subDepth = cylinder.H/2 + 1; % m, submergence depth from water surface buoy centre

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

%% Graph Results

% Setup nice graphics
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultAxesFontWeight','normal');
set(0,'DefaultTextFontSize',14);
set(0,'DefaultTextFontWeight','normal');
set(0,'DefaultUicontrolFontSize',16);
set(0,'DefaultUicontrolFontWeight','normal');
set(0,'DefaultAxesTickLength',[0.025 0.015]);
set(0,'DefaultAxesLineWidth', 1.0);
set(0,'DefaultLineLineWidth', 2.0);

% Note convention here is 
% 1 - surge
% 2 - sway
% 3 - heave
% 4 - roll
% 5 - pitch
% 6 - yaw

% Added Mass
figure
subplot(3,3,1)
plot(w,squeeze(A(1,1,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(1,1)}  kg')
subplot(3,3,2)
plot(w,squeeze(A(1,3,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(1,3)}  kg')
subplot(3,3,3)
plot(w,squeeze(A(1,5,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(1,5)}  kg')
subplot(3,3,4)
plot(w,squeeze(A(3,1,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(3,1)}  kg')
subplot(3,3,5)
plot(w,squeeze(A(3,3,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(3,3)}  kg')
subplot(3,3,6)
plot(w,squeeze(A(3,5,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(3,5)}  kg')
subplot(3,3,7)
plot(w,squeeze(A(5,1,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(5,1)}  kg')
subplot(3,3,8)
plot(w,squeeze(A(5,3,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(5,3)}  kg')
subplot(3,3,9)
plot(w,squeeze(A(5,5,:)))
xlabel('\omega (rad/s)')
ylabel('A_{(5,5)}  kg')

% Radiation Damping
figure
subplot(3,3,1)
plot(w,squeeze(B(1,1,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(1,1)}  Ns/m')
subplot(3,3,2)
plot(w,squeeze(B(1,3,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(1,3)}  Ns/m')
subplot(3,3,3)
plot(w,squeeze(B(1,5,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(1,5)}  Ns/m')
subplot(3,3,4)
plot(w,squeeze(B(3,1,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(3,1)}  Ns/m')
subplot(3,3,5)
plot(w,squeeze(B(3,3,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(3,3)}  Ns/m')
subplot(3,3,6)
plot(w,squeeze(B(3,5,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(3,5)}  Ns/m')
subplot(3,3,7)
plot(w,squeeze(B(5,1,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(5,1)}  Ns/m')
subplot(3,3,8)
plot(w,squeeze(B(5,3,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(5,3)}  Ns/m')
subplot(3,3,9)
plot(w,squeeze(B(5,5,:)))
xlabel('\omega (rad/s)')
ylabel('B_{(5,5)}  Ns/m')

% Excitation Force - Amplitude
figure
subplot(3,1,1)
plot(w,squeeze(Famp(:,1)))
xlabel('\omega (rad/s)')
ylabel('F_{amp,1}  N')
subplot(3,1,2)
plot(w,squeeze(Famp(:,3)))
xlabel('\omega (rad/s)')
ylabel('F_{amp,3}  N')
subplot(3,1,3)
plot(w,squeeze(Famp(:,5)))
xlabel('\omega (rad/s)')
ylabel('F_{amp,5}  N')

% Excitation Force - Phase
figure
subplot(3,1,1)
plot(w,squeeze(Fphi(:,1)))
xlabel('\omega (rad/s)')
ylabel('F_{phase,1}  rad')
subplot(3,1,2)
plot(w,squeeze(Fphi(:,3)))
xlabel('\omega (rad/s)')
ylabel('F_{phase,3}  rad')
subplot(3,1,3)
plot(w,squeeze(Fphi(:,5)))
xlabel('\omega (rad/s)')
ylabel('F_{phase,5}  rad')

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

%% Quick comparison

% This section allows the user to do a quick comparison with previously
% established WAMIT results. 
% 
% Wamit parameters
% cylinder radius = 5.5m
% cylinder height = 5.5m
% submergence depth (from top of buoy) = 1m
% water depth = 50m
%
% Use these parameters and then use this tool to compare NEMOH and WAMIT

ComparisonFlag = 1;

if ComparisonFlag
    
    % Read in preivous data
    addpath(fullfile('.','ComparisonWamit'))
    load('WamitResults.mat');
    rmpath(fullfile('.','ComparisonWamit'))
    
    % Select data
    A_Wamit_whole = squeeze(WamitResults.A(1,1,1:250));
    w_Wamit = WamitResults.w(1:250);
    
    % Plot
    figure
    hold on
    plot(w_Wamit, A_Wamit_whole)
    plot(w, squeeze(A(1,1,:)))
    xlabel('\omega (rad/s)')
    ylabel('Added Mass - Surge, kg')
    title('Comparison between WAMIT and NEMOH')
    legend('WAMIT','NEMOH')
    
end