function [muMap] = graph_slam_solve_map(muRob, Omega, Xi, tau, mapIds)    
    % Calculate muMap    
    numLandmarks = size(mapIds,2);
    numPoses = size(Omega{1},3);% - numLandmarks;
    muMap = zeros(2, numLandmarks);
    for j = 1:numLandmarks
        
        tauJ = tau{j};
         numTauPoses = size(tauJ,2);
        if (numTauPoses>0) %skip columns of 0's
            tempOmega = permute(Omega{2}(:,:,tauJ,j), [1 3 2]);
            tempOmega = reshape(tempOmega, size(tempOmega, 2) * size(tempOmega, 1), size(tempOmega, 3));
            tempOmega = permute(tempOmega, [2 1]);
            muMap(:, j) = Omega{3}(:,:, j, j) \ (Xi{2}(:, j) - (tempOmega * reshape(muRob(:, tauJ), [], 1)));
        else
           muMap(:, j) = zeros(2,1);  
        end

    %%
%     dim = size(Omega(:,:,end-16:end,end-16:end),1)*size(Omega(:,:,end-16:end,end-16:end),3);
%     formatedOmega = permute(Omega(:,:,end-16:end,end-16:end), [1 3 2 4]);
%     formatedOmega = reshape(formatedOmega, dim, dim);
%     
%     % Recontruct original information vector from subvectors
%     newXi = reshape(Xi(:,end-16:end), size(Xi(:,end-16:end),1) * size(Xi(:,end-16:end),2), 1);
%     
%     % Solve linear system
%     testMuMap = formatedOmega \ newXi;
%     
%     % Fix the format of muRob
%     testMuMap = reshape(testMuMap, 3, []);
%     
%     % Remove muRob from muMap
%     %muMap = muMap(:,size(OmegaRed,3)+1:end);
%     
%     muMap == testMuMap;
 end