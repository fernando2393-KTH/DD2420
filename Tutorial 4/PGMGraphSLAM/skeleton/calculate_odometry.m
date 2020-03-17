% function u = calculate_odometry(odo,mu)
% This function should calculate the odometry information
% Inputs:
%           odo:            2x1 ds and dangle
%           mu(t-1):        3X1 Pose of the robot in the last time step
% Outputs:
%           u(t):           3X1 Odometry at current time step (i.e. the
%                               change in x, y and theta).
function u = calculate_odometry(odo,mu)

% a = mod((omega_t*delta_t) + pi, 2*pi)-pi;
% mu(3) = mod(mu(3) + pi, 2*pi)-pi;

u = [odo(1)*cos(mu(3,1));
    odo(1)*sin(mu(3,1));
    odo(2)];

% FILL IN HERE
end