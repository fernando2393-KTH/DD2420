function [Omega, Xi] = graph_slam_linearize(mu, simSteps, map, R, Q, mapIds, odo, finish)
    numPoses = size(simSteps,2);
    if finish<numPoses
        numPoses=finish;
    end
    numLandmarks = size(map,2);
% We form the information matrix Omega as three parts to make taking
% advantage of its structure easier later
    Omega = {};
    Omega= {Omega{:} zeros(3,3, numPoses, numPoses)};
    Omega= {Omega{:} zeros(3,2, numPoses, numLandmarks)};
    Omega= {Omega{:} zeros(2,2, numLandmarks, numLandmarks)};
 %   Omega = zeros(3, 3, numPoses + numLandmarks, numPoses + numLandmarks);
    Xi={};
    Xi={Xi{:} zeros(3,numPoses)};
    Xi={Xi{:} zeros(2,numLandmarks)};
    %Xi = zeros(3, numPoses + numLandmarks);
    %Anchor the first pose by giving it a singlton factor with large
    %information matrix
    Omega{1}(:,:,1,1) = eye(3,3) * 100000000000;

    % For all controls
    for t = 2:numPoses
      % Compute odom
      u = calculate_odometry(odo(:,t-1),mu(:,t-1));

      xHat = mu(:,t-1) + u;
     
      % Jacobian of transition model  ie 
      % x_t =x_{t-1} +v dt cos(theta_{t-1})...
      G = [1,  0, -1*u(2);
           0,  1,    u(1);
           0,  0,      1];

      % 6x6 
      GT_Ri_G = [-transpose(G);eye(3)] * (R \ [-G eye(3)]); 

      % Basicaly we say the factor is for the motion noise that is 
      %  Gaussian:  
      %   N(x_t-x_{t-1}-u(x_{t-1}),R)
      % x is the new estimate  (mu is the old) 
      % Linearize the u around mu and we find the factor is:
      % N(x_t-G*x_{t-1} + G* mu_{t-1} - xHat, R)
      % Which is sort of a wierd result of the G and xHat definitions 
      % add ht information into this giant information matrix  as four  
      % 3 x 3 blocks
      Omega{1}(:,:, t-1,   t-1)    = Omega{1}(:,:, t-1,   t-1)    + GT_Ri_G(1:3, 1:3);
      Omega{1}(:,:, t, t)          = Omega{1}(:,:, t, t)          + GT_Ri_G(4:6, 4:6);
      Omega{1}(:,:, t-1,   t)      = Omega{1}(:,:, t-1,   t)      + GT_Ri_G(1:3, 4:6);
      Omega{1}(:,:, t, t-1)        = Omega{1}(:,:, t, t-1)        + GT_Ri_G(4:6, 1:3);

      % 6x1
      %GT_Ri_xGmu 
      temp = [-transpose(G);eye(3)] * (R \ (xHat - (G * mu(:,t-1))));
      %temp = [-transpose(G);eye(3)] * (R \ (mu(:,t)-xHat));
      %temp = [-transpose(G);eye(3)] * (R \ (G * mu(:,t-1)-u));
      Xi{1}(:, t-1)   = Xi{1}(:, t-1) + temp(1:3);
      Xi{1}(:, t)     = Xi{1}(:, t)   + temp(4:6);
        
      
    end
    
%     dim = size(Omega,1)*size(Omega,3);
%     formatedOmega = permute(Omega, [1 3 2 4]);
%     formatedOmega = reshape(formatedOmega, dim, dim);
% 
%     if sum(sum(formatedOmega~=formatedOmega'))
%         display('warning, formatedOmega is not symmetric');
%     end
    
    % For all measurements
    for t = 1:numPoses
      numLandmarks = simSteps{t}.getNumLandmark();
      % For all observed landmarks
      for l = 1:numLandmarks
        j = find(simSteps{t}.getLandmarkID(l) == mapIds);
        %mj = numPoses + j;
       
        z = simSteps{t}.getLandmark(l);
        z=z(1:2);
        %What do we expect to measure for this landmark from mu
        zBar = observation_model(mu(:,t), map, j);
        % Compute innovation
        innovation = z - zBar;
        innovation(2,1) = mod(innovation(2,1) + pi, 2*pi) - pi;   
        % Keep values of yaw within limits

        
        % create a 2x5 (or 3x6) jacobian with [pose map] coordinates
        H = jacobian_observation_model(mu(:,t), map, j); 
        % So the factor is 
        % N(innovation +H * [mu; map]  - H*[newmu: newmap],Q)  
        % 6x6
        HT_Qi_H = transpose(H) * (Q \ H);
        
        Omega{1}(:,:, t,  t)  = Omega{1}(:,:, t,  t)  + HT_Qi_H(1:3, 1:3);
        Omega{3}(:,:, j, j) = Omega{3}(:,:, j, j) + HT_Qi_H(4:5, 4:5);
        Omega{2}(:,:, t,  j) = Omega{2}(:,:, t,  j) + HT_Qi_H(1:3, 4:5);
        %Omega(:,:, mj, t)  = Omega(:,:, mj, t)  + HT_Qi_H(4:6, 1:3);
        
      
        % 5x1
      
        HT_Qi_zzhH = transpose(H) * (Q \ (innovation + (H * [mu(:,t);map(:,j)])));
        %HT_Qi_zzhH = transpose(H) * (Q \ (innovation));
        % TODO: Are the indices correct?
        Xi{1}(:, t)  = Xi{1}(:, t)  + HT_Qi_zzhH(1:3);
        Xi{2}(:, j) = Xi{2}(:, j) + HT_Qi_zzhH(4:5);
      end
    end
end
