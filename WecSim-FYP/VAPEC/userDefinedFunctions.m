%Example of user input MATLAB file for post processing

%Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,4);

%Plot heave response for body 2
output.plotResponse(1,5);

%Plot heave forces for body 1
output.plotResponse(1,6);

%Plot heave response for body 1
output.plotResponse(2,4);

%Plot heave response for body 2
output.plotResponse(2,5);

%Plot heave forces for body 1
output.plotResponse(2,6);

% Plot Instantanous power output of WEC
figure;
plot(simu.startTime:simu.dtOut:simu.endTime,output.ptos.powerInternalMechanics(:,5));
title('Instantanous power output of WEC')
ylabel('Instantanous power output of WEC (Watts)')
xlabel('Time (Seconds)')

% Plot Cumulative power output of WEC
figure;
plot(simu.startTime:simu.dtOut:simu.endTime,cumsum(output.ptos.powerInternalMechanics(:,5)));
title('Cumulative power output of WEC')
ylabel('Cumulative power output of WEC (Joules)')
xlabel('Time (Seconds)')

% Calculate average poweroutput over last half of simulation
x = output.ptos.powerInternalMechanics(ceil(numel(output.ptos.powerInternalMechanics(:,5))/2),5);
fprintf('Average power output (Watts) over last half of simulation: %s.\n', mean(x));

% Plot Cumulative power output of WEC
figure;
plot(simu.startTime:simu.dtOut:simu.endTime,output.ptos.velocity(:,5));
title('Velocity of pendulum WEC')
ylabel('Velocity of pendulum (rad/s)')
xlabel('Time (Seconds)')
fprintf('Average velocity of PTO (rad/s) over last half of simulation: %s.\n', mean(abs(output.ptos.velocity(ceil(numel(output.ptos.velocity(:,5))/2),5))));
