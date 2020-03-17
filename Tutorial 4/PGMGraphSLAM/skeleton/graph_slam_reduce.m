function [OmegaRed, XiRed] = graph_slam_reduce(Omega, Xi, tau, mapIds)
    
    OmegaRed = Omega{1};
    XiRed = Xi{1};
    
    numLandmarks = size(mapIds,2);
    numPoses = size(OmegaRed,3);% - numLandmarks;
    for j = 1:numLandmarks
        tauJ = tau{j};
        %mj = numPoses + j;
        numTauPoses = size(tauJ,2);
        if (numTauPoses>0) %skip columns of 0's
            OmageTauSize = size(OmegaRed(:,:, tauJ, tauJ)); % Big speedup
            %omega_taui_j ends up as the 'the block of columns from landmark j with rows that
             %   involve landmark j
            omega_taui_j = permute(Omega{2}(:,:, tauJ, j), [1 3 2]);
            omega_taui_j = reshape(omega_taui_j, numTauPoses * size(OmegaRed, 1), size(Omega{2}, 2));
            % we take advantage of diagonal map map part
            tempXi = omega_taui_j * (Omega{3}(:,:, j, j) \ Xi{2}(:, j));
            tempXi = reshape(tempXi, size(XiRed(:, tauJ)));
        
            tempOmega = omega_taui_j * (Omega{3}(:,:, j, j) \ transpose(omega_taui_j));
            
            tempOmega = reshape(tempOmega, OmageTauSize(1), OmageTauSize(3), OmageTauSize(2), OmageTauSize(4));
            tempOmega = permute(tempOmega, [1 3 2 4]);
           XiRed(:, tauJ) = XiRed(:, tauJ) - tempXi;
            OmegaRed(:,:, tauJ, tauJ) = OmegaRed(:,:, tauJ, tauJ) - tempOmega;
        end    
    end
    % Remove landmarks from Omega. The landmarks are in the end
   % OmegaRed = OmegaRed(:,:, 1:numPoses, 1:numPoses);
    % Remove landmarks from Xi. The landmarks are in the end
    %XiRed = XiRed(:, 1:numPoses);
end



