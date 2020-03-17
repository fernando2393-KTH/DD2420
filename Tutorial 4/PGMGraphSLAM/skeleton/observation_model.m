% function h = observation_model(x,M,j)
% This function is the implementation of the h function.
% The bearing should lie in the interval [-pi,pi)
% Inputs:
%           x(t)        3X1
%           M           2XN
%           j           1X1
% Outputs:  
%           h           2X1
function h = observation_model(x,M,j)
    delta = [M(1,j) - x(1);
             M(2,j) - x(2)];
         
    q = transpose(delta) * delta;
    
    a = mod((atan2(delta(2,1), delta(1,1)) - x(3,1)) + pi, 2*pi)-pi;
    h = [sqrt(q);
         a];
%        M(3,j)];
end