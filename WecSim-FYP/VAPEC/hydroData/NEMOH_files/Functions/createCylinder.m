function [nodes, nPanels] = createCylinder(Data)
%  This function is made to create a cylinder described by a series of
%  panels for use in the Mesh function to provide correct formatting.
%
% Author: Benjamin Schubert
% Date: 2/05/17
% Updated: 25/06/2018

% Define variables
a = Data.a; % m, radius
nUnits = Data.nUnits; % number of Units used to define geometry
H = Data.H; % m, height of cylinder

% Panel Units
unitSize = (2*pi*a) / (4*nUnits); % size of panel
nUnitsHor = nUnits; % number of units in the horizontal direction
nUnitsVer = round(H/unitSize); % number of units in the vertical direction
n = 1; % loop variable tracking number of panels

% Side
phi = linspace(0, pi, nUnitsHor+1); % rad, angles in the azimuthal direction of cylinder
verPos = linspace(-H/2, H/2, nUnitsVer+1); % m, vertical position of panel verticies
% Note the +1 to ensure all units have 4 verticies in following for loop

nodes = zeros(1,(nUnitsVer+1)*(nUnitsHor+1),4, 3);

for  i = 1:nUnitsHor
    for j = 1:nUnitsVer
        % verticies defined to form an anti-clockwise direction when facing
        % from the outside 
        % vertice = [X Y Z]
        nodes(1,n,1,:) = [a*cos(phi(i+1)) a*sin(phi(i+1)) verPos(j+1)];
        nodes(1,n,2,:) = [a*cos(phi(i)) a*sin(phi(i)) verPos(j+1)];
        nodes(1,n,3,:) = [a*cos(phi(i)) a*sin(phi(i)) verPos(j)];
        nodes(1,n,4,:) = [a*cos(phi(i+1)) a*sin(phi(i+1)) verPos(j)];
        
        n = n+1;
    end
end


% Top
phi = linspace(0, pi, nUnitsHor+1); % rad, angles in the azimuthal direction of cylinder
axiPos = linspace(0, a, nUnitsVer+1); % m, vertical position of panel verticies
% Note the +1 to ensure all units have 4 verticies in following for loop

for  i = 1:nUnitsHor
    for j = 1:nUnitsVer
        % verticies defined to form an anti-clockwise direction when facing
        % from the outside 
        % vertice = [X Y Z]
        nodes(1,n,1,:) = [axiPos(j+1)*cos(phi(i+1)) axiPos(j+1)*sin(phi(i+1)) H/2];
        nodes(1,n,2,:) = [axiPos(j)*cos(phi(i+1)) axiPos(j)*sin(phi(i+1)) H/2];
        nodes(1,n,3,:) = [axiPos(j)*cos(phi(i)) axiPos(j)*sin(phi(i)) H/2];
        nodes(1,n,4,:) = [axiPos(j+1)*cos(phi(i)) axiPos(j+1)*sin(phi(i)) H/2];
        
        n = n+1;
    end
end


% Bottom
phi = linspace(0, pi, nUnitsHor+1); % rad, angles in the azimuthal direction of cylinder
axiPos = linspace(0, a, nUnitsVer+1); % m, vertical position of panel verticies
% Note the +1 to ensure all units have 4 verticies in following for loop

for  i = 1:nUnitsHor
    for j = 1:nUnitsVer
        % verticies defined to form an anti-clockwise direction when facing
        % from the outside 
        % vertice = [X Y Z]
        nodes(1,n,1,:) = [axiPos(j+1)*cos(phi(i+1)) axiPos(j+1)*sin(phi(i+1)) -H/2];
        nodes(1,n,2,:) = [axiPos(j+1)*cos(phi(i)) axiPos(j+1)*sin(phi(i)) -H/2];
        nodes(1,n,3,:) = [axiPos(j)*cos(phi(i)) axiPos(j)*sin(phi(i)) -H/2];
        nodes(1,n,4,:) = [axiPos(j)*cos(phi(i+1)) axiPos(j)*sin(phi(i+1)) -H/2];
        
        n = n+1;
    end
end

% Correct for numerical error
logic = abs(nodes(:,:,:,:))<0.00001;
nodes(logic) = 0;

nPanels = n-1; % the total number of panels constituting the geometry

% Plot defined points (Optional)
Points = [squeeze(nodes(:,:,1,:)); squeeze(nodes(:,:,2,:)); squeeze(nodes(:,:,3,:)); squeeze(nodes(:,:,4,:))];
figure
plot3(Points(:,1), Points(:,2), Points(:,3), 'ob')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal