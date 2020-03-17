 function [muRob, SigmaRob] = graph_slam_solve_rob(OmegaRed, XiRed)

    % Recontruct original information matrix from submatrices
    dim = size(OmegaRed,1)*size(OmegaRed,3);
    formatedOmegaRed = permute(OmegaRed, [1 3 2 4]);
    formatedOmegaRed = reshape(formatedOmegaRed, dim, dim);
    
    for i = 1:size(OmegaRed,3)
        indices = i*3-2:i*3;
        if all(all(OmegaRed(:,:,i,i) == formatedOmegaRed(indices,indices))) == 0
            i
            OmegaRed(:,:,i,i)
            formatedOmegaRed(indices,indices)
        end
    end
    
    SigmaRob = inv(formatedOmegaRed);
    
%     if sum(sum(SigmaRob~=SigmaRob'))
%         display('warning, sigma is not symmetric');
%     end
  
    
    % Recontruct original information vector from subvectors
    newXi = reshape(XiRed, size(XiRed,1) * size(XiRed,2), 1);

    % Solve linear system
    %muRob = formatedOmegaRed \ newXi;SigmaRob
   
    muRob=SigmaRob*newXi;
    % Fix the format of muRob
    muRob = reshape(muRob, 3, []);
      % Fix the format of SigmaRob
    SigmaRob = reshape(SigmaRob, size(OmegaRed,1), size(OmegaRed,3), size(OmegaRed,2), size(OmegaRed,4));
    SigmaRob = permute(SigmaRob, [1 3 2 4]);
    
    %muRob(3,:) = mod(muRob(3,:)+pi,2*pi)-pi;
 end