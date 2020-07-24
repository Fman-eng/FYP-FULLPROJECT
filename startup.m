% If you have not chosen to set the matlab startup folder to the Wecsim
% root folder (the folder this script is contained in) then you must edit
% the startup.m file in your chosen matlab startup folder to add the wecSim
% source files to the path. To do this add the commented code to below to
% your startup.m file, replacing the string in the angle brackets with the
% full path to the wecsim source folder.

% wecSimPath = '<wecSim Source folder Path>';
% addpath(genpath(wecSimPath));

addpath(fullfile(pwd,source));

