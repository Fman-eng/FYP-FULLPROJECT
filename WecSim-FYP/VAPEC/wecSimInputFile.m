%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'VAPEC.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 0;                   	% Wave Ramp Time [s]
simu.endTime=200;                       % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 							% Simulation time-step [s]
simu.dtOut = 0.1;
simu.dtCITime = 0.05;
simu.paraview = 0;
% simu.StartTimeParaview = 100;
% simu.EndTimeParaview = 400;
simu.pathParaviewVideo = 'test';

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.H = 4.5;                          % Wave Height [m]
waves.T = 13;                            % Wave Period [s]

% % Regular Waves with CIC
% waves = waveClass('regularCIC');           % Initialize Wave Class and Specify Type                                 
% waves.H = 2.5;                          % Wave Height [m]
% waves.T = 8;                            % Wave Period [s]

% % Irregular Waves using PM Spectrum 
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
% waves.H = 2.5;                          % Significant Wave Height [m]
% waves.T = 8;                            % Peak Period [s]
% waves.spectrumType = 'PM';              % Specify Wave Spectrum Type

% % Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
% waves.H = 2.5;                          % Significant Wave Height [m]
% waves.T = 8;                            % Peak Period [s]
% waves.spectrumType = 'JS';              % Specify Wave Spectrum Type
% waves.freqDisc = 'EqualEnergy';         % Uses 'EqualEnergy' bins (default) 
% waves.phaseSeed = 1;                    % Phase is seeded so eta is the same

% % Irregular Waves using BS Spectrum with Traditional and State Space 
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
% waves.H = 2.5;                          % Significant Wave Height [m]
% waves.T = 8;                            % Peak Period [s]
% waves.spectrumType = 'BS';              % Specify Wave Spectrum Type
% simu.ssCalc = 1;                        % Turn on State Space
% waves.freqDisc = 'Traditional';         % Uses 1000 frequnecies

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');        % Create the Wave Variable and Specify Type
% waves.spectrumDataFile = 'spectrumData.mat';  %Name of User-Defined Spectrum File [:,2] = [f, Sf]

% % Waves with imported wave elevation time-history  
% waves = waveClass('etaImport');         % Create the Wave Variable and Specify Type
% waves.etaDataFile = 'etaData.mat'; % Name of User-Defined Time-Series File [:,2] = [time, eta]

%% Body Data
% Float
body(1) = bodyClass('hydroData/VAPEC.h5');      
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    %and Body Number Within this File.   
body(1).geometryFile = 'geometry/BasicBuoy.stl';    % Location of Geomtry File
body(1).mass = 76617;                   
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    %Weight.
body(1).momOfInertia = [1382255 1382255 1779942];  %Moment of Inertia [kg*m^2]
body(1).initDisp.initLinDisp = [0 0 3];

% Pendulum
body(2) = bodyClass(''); 
body(2).geometryFile = 'geometry/pendulumSimple.stl';
body(2).mass = 1011.289;                   
body(2).momOfInertia = [842.688 29.144 842.624];
body(2).nhBody = 1;
body(2).cg = [0 0 0];
body(2).dispVol = 0.129;
body(2).initDisp.initLinDisp = [0 3.96 -1.15];
body(2).viz.color = [1 0 1];

%body(2).volume = 1.4 %m^3
% body(2).mass = 1075;                   
% body(2).momOfInertia = [158.180 440.555 598.288];
% body(2).nhBody = 1;
%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).loc = [0 0 0];                    % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).k = 0;                                   % PTO Stiffness [N/m]
pto(1).c = 1000:250:8000;                             % PTO Damping [N/(m/s)]
pto(1).loc = [0 0 0];                           % PTO Location [m]
pto(1).orientation.z = [1 0 0];
pto(1).orientation.y = [0 0 1];

%% Mooring
% Moordyn
mooring(1) = mooringClass('mooring');       % Initialize mooringClass
mooring(1).moorDynLines = 6;                % Specify number of lines
mooring(1).moorDynNodes(1:3) = 16;          % Specify number of nodes per line
mooring(1).moorDynNodes(4:6) = 6;           % Specify number of nodes per line
mooring(1).initDisp.initLinDisp = [0 0 -0.21];      % Initial Displacement
