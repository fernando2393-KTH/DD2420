function [ labels ] = computeLabeling( beliefs )
%   Compute most likely labeling given the computed beliefs given the
%   selected message update algorithm
[~, labels] = max(beliefs, [], 3)
labels = labels-1;

end

