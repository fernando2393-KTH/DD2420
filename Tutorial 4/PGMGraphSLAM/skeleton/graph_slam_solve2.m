 function [mu_rob] = graph_slam_solve2(Omega_red, Xi_red)

    % Recontruct original information matrix from submatrices
    dim = size(Omega_red,1)*size(Omega_red,3);
    New_Omega = reshape(permute(Omega_red, [1 3 2 4]), dim, dim);
    
    % Recontruct original information vector from subvectors
    New_Xi = reshape(Xi_red, size(Xi_red,1) * size(Xi_red,2), 1);

    % Solve linear system
    mu_rob = New_Omega \ New_Xi;

 end
