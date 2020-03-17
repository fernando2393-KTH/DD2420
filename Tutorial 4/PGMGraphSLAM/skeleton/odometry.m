% function odo = odometry(simSteps,E_T,B,delta_t)
% This function should calculate the odometry information
% Inputs:
%           dimSteps
%           E_T:            1X1 Number of encoder ticks per wheel revolution
%           B:              1X1 Wheel base (distance between the contact points of the wheels)
%           R_L:            1X1 Radius of the left wheel
%           R_R:            1X1 Radius of the right wheel
% Outputs:
%           odo:           2XN-1 Odometry at each time step (i.e. the
%                               change in s and theta.
function odo = odometry(simSteps,E_T,B,R_L, R_R)
numPoses = size(simSteps,2);
odo=zeros(2,numPoses-1);
for t = 2:numPoses
    delta_t = simSteps{t}.t - simSteps{t-1}.t;
    denc = simSteps{t}.encoder - simSteps{t-1}.encoder;
   
    % Angular changes at time step t
    d_R_t = (2*pi*denc(1))/(E_T);
    d_L_t = (2*pi*denc(2))/(E_T);
    odo(2,t-1) = (d_R_t*R_R - d_L_t*R_L)/B;
    % Translational change at time step t
    odo(1,t-1) = (d_R_t*R_R + d_L_t*R_L)/2;
end