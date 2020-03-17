% function [mu,sigma,R,Q,Lambda_M] = init()
% This function initializes the parameters of the filter.
% Outputs:
%			mu(0):			3X1
%			sigma(0):		3X3
%			R:				3X3
%			Q:				2X2
function [mu,sigma,R,Q,Lambda_M] = init(simOutFile)
mu = [0;0;0]; % initial estimate of state
sigma = 1e-10*diag([1 1 1]); % initial covariance matrix
simOutFile
switch simOutFile
    case 'so_o3_ie.txt'
        delta_m = 0.999;
        R = [0.01^2, 0,      0;
             0,      0.01^2, 0;
             0,      0,      deg2rad(1)^2];

        Q = [0.01^2, 0,            0;
             0,      deg2rad(1)^2, 0;
             0       0,            0.001];
    case 'so_pb_10_outlier.txt'
        delta_m = 0.999;
        R = [0.01^2, 0,      0;
             0,      0.01^2, 0;
             0,      0,      deg2rad(1)^2];

        Q = [0.25^2, 0,     0;
             0,    0.25^2, 0;
             0,    0,     0.001];
    case 'so_pb_40_no.txt'
        delta_m = 1;
        R = [1^2, 0,   0;
            0,    1^2, 0;
            0,    0,   1^2];

        Q = [0.1^1, 0,     0;
             0,     0.1^1, 0;
             0,     0,     1];
     case 'so_sym2_nk.txt'
        delta_m = 0.999;
        R = [0.01^2, 0,      0;
             0,      0.01^2, 0;
             0,      0,      deg2rad(1)^2];

        Q = [0.03^2, 0,            0;
             0,      deg2rad(1)^2, 0;
             0       0,            0.001];
    case 'so_sym3_nk.txt'
        delta_m = 0.999;
        R = [0.01^2, 0,      0;
             0,      0.01^2, 0;
             0,      0,      deg2rad(1)^2];

        Q = [0.01^2, 0,            0;
             0,      deg2rad(1)^2, 0;
             0       0,            0.001];
    otherwise
        delta_m = 0.999;
        R = [0.001, 0,     0;
             0,    0.001, 0;
             0,    0,     0.001];
        
        Q = [0.001, 0,     0;
             0,    0.001, 0;
             0,    0,     0.001];
end
Q=Q(1:2, 1:2);
Lambda_M = chi2inv(delta_m,2);
end
