function writeNemoh(rho,g,nBodies,nomrep,nx,nf,CG,meshFile)
% Write Nemoh input file
%
% Adapted by: Benjamin Schubert
% Date: 4/04/2018

c = 1; % constant allowing for multiple bodies if needed later

fid=fopen([nomrep,filesep,'Nemoh.cal'],'w');
fprintf(fid,'--- Environment ------------------------------------------------------------------------------------------------------------------ \n');
fprintf(fid,'%f				! RHO 			! KG/M**3 	! Fluid specific volume \n',rho);
fprintf(fid,'%f				! G			! M/S**2	! Gravity \n',g);
fprintf(fid,'0.                 ! DEPTH			! M		! Water depth\n');
fprintf(fid,'0.	0.              ! XEFF YEFF		! M		! Wave measurement point\n');
fprintf(fid,'--- Description of floating bodies -----------------------------------------------------------------------------------------------\n',c);
fprintf(fid,'%g				! Number of bodies\n',nBodies);
for c=1:nBodies
    fprintf(fid,'--- Body %g -----------------------------------------------------------------------------------------------------------------------\n',c);
    if isunix 
        fprintf(fid,['''',nomrep,filesep,'mesh',filesep,'mesh',int2str(c),'.dat''		! Name of mesh file\n']);
    else
        fprintf(fid,[nomrep,'\\mesh\\' meshFile '      ! Name of mesh file\n']);
    end;
    fprintf(fid,'%i %i			! Number of points and number of panels 	\n',nx,nf);
    fprintf(fid,'6				! Number of degrees of freedom\n');
    fprintf(fid,'1 1. 0.	0. 0. 0. 0.		! Surge\n');
    fprintf(fid,'1 0. 1.	0. 0. 0. 0.		! Sway\n');
    fprintf(fid,'1 0. 0. 1. 0. 0. 0.		! Heave\n');
    fprintf(fid,'2 1. 0. 0. %f %f %f		! Roll about a point\n',CG(c,:));
    fprintf(fid,'2 0. 1. 0. %f %f %f		! Pitch about a point\n',CG(c,:));
    fprintf(fid,'2 0. 0. 1. %f %f %f		! Yaw about a point\n',CG(c,:));
    fprintf(fid,'6				! Number of resulting generalised forces\n');
    fprintf(fid,'1 1. 0.	0. 0. 0. 0.		! Force in x direction\n');
    fprintf(fid,'1 0. 1.	0. 0. 0. 0.		! Force in y direction\n');
    fprintf(fid,'1 0. 0. 1. 0. 0. 0.		! Force in z direction\n');
    fprintf(fid,'2 1. 0. 0. %f %f %f		! Moment force in x direction about a point\n',CG(c,:));
    fprintf(fid,'2 0. 1. 0. %f %f %f		! Moment force in y direction about a point\n',CG(c,:));
    fprintf(fid,'2 0. 0. 1. %f %f %f		! Moment force in z direction about a point\n',CG(c,:));
    fprintf(fid,'0				! Number of lines of additional information \n');
end
fprintf(fid,'--- Load cases to be solved -------------------------------------------------------------------------------------------------------\n');
fprintf(fid,'1	0.8	0.8		! Number of wave frequencies, Min, and Max (rad/s)\n');
fprintf(fid,'1	0.	0.		! Number of wave directions, Min and Max (degrees)\n');
fprintf(fid,'--- Post processing ---------------------------------------------------------------------------------------------------------------\n');
fprintf(fid,'1	0.1	10.		! IRF 				! IRF calculation (0 for no calculation), time step and duration\n');
fprintf(fid,'0				! Show pressure\n');
fprintf(fid,'0	0.	180.		! Kochin function 		! Number of directions of calculation (0 for no calculations), Min and Max (degrees)\n');
fprintf(fid,'0	50	400.	400.	! Free surface elevation 	! Number of points in x direction (0 for no calcutions) and y direction and dimensions of domain in x and y direction\n');	
fprintf(fid,'---')
status=fclose(fid);
fclose('all');