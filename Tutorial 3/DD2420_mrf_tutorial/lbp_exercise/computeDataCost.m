function [ dataCost ] = computeDataCost( I, tau )
%   dataCost(m, n, i) is the cost for assignning label i to pixel (m, n) 

[h, w, ~] = size(I);
nLevels = max(I(:));
dataCost = zeros([h, w, nLevels+1]);

for i=0:nLevels
   dataCost(:, :, i+1) = tau * abs(i - I); 
end

end

