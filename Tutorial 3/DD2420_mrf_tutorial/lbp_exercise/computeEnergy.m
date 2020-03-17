function [ energy ] = computeEnergy( dataCost, labels, lambda )
%   Compute energy function based on selected message updating algorithm

% Compute smoothness cost between neighbors, i.e. \phi(x_i, x_j)
smoothnessCostU = lambda*((labels - circshift(labels, 1, 1)) ~= 0);
smoothnessCostD = lambda*((labels - circshift(labels, -1, 1)) ~= 0);
smoothnessCostL = lambda*((labels - circshift(labels, 1, 2)) ~= 0);
smoothnessCostR = lambda*((labels - circshift(labels, -1, 2)) ~= 0);

% Ignore edge costs (can probably be skipped)
smoothnessCostU(1, :) = 0;
smoothnessCostD(end, :) = 0;
smoothnessCostL(:, 1) = 0;
smoothnessCostR(:, end) = 0;



energy = sum(dataCost, 'all') + sum(smoothnessCostU, 'all') + sum(smoothnessCostD, 'all') + sum(smoothnessCostL, 'all') + sum(smoothnessCostR, 'all'); 

end

