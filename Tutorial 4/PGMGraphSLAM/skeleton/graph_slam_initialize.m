function [mu] = graph_slam_initialize(simSteps, mu0, odo)
% Graph SLAM initialize: compute the initial guess of the robot poses
%           simSteps: list (cell array in Matlab speak) of 'SimStep' objects 
%                       (see Aux\SimStep.m) one for each iteration.  
%           mu0: (essentially just (0,0,0) unless you want
%                   to start somewhere else
%           odo:    2xN ds and dtheta

    % Pre-allocate
    mu = zeros(3, size(simSteps,2));
    
    mu(:, 1) = mu0;
    
    for t = 2:size(simSteps,2)
      deltaT = simSteps{t}.t - simSteps{t-1}.t;
      denc = simSteps{t}.encoder - simSteps{t-1}.encoder;
      
      % Compute odom u=(dx,dy,dtheta) from change in encoder readings.  
      u = calculate_odometry(odo(:,t-1),mu(:,t-1));
      
      % Add to vector of robot poses
      mu(:, t) = mu(:, t-1) + u;
      % Important to wrap the angles to (-pi, pi)
      mu(3, t) = mod(mu(3, t) + pi, 2*pi) - pi;
      end
end