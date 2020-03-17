% function H = jacobian_observation_model(mu_bar,M,j,z,i)
% This function is the implementation of the H function
% Inputs:
%           mu_bar(t)   3X1
%           M           2XN
%           j           1X1 which M column
%           z_hat       2Xn
%           i           1X1  which z column
% Outputs:  
%           H           2X5
function H = jacobian_observation_model(mu_bar,M,j)

    delta = [M(1,j) - mu_bar(1);
             M(2,j) - mu_bar(2)];
         
    q = transpose(delta) * delta;

    H_x = [-sqrt(q)*delta(1,1), -sqrt(q)*delta(2,1),    0;
                    delta(2,1),         -delta(1,1),   -q];
 %                            0,                   0,    0];
                         
    H_z = [sqrt(q)*delta(1,1), sqrt(q)*delta(2,1);%,    0;
                  -delta(2,1),         delta(1,1)];%,    0;
 %                           0,                  0,    q];
     
    H = (1/q) *cat(2,H_x, H_z);
end
