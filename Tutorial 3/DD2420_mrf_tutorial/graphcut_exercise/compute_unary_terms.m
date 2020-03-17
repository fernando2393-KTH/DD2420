function U = compute_unary_terms(I)
% Computing the unary terms in the graph.
% Args: I = Image with size HxW
% Returns: U = Sparse (H*W)x2 matrix, where column 1 represents the cost 
%           for assigning label 1 (white) for pixel i and column 2
%           represents the cost for assigning label 0 (black) to pixel
%           i, where i = 1,...,H*W

[h, w] = size(I);
y = reshape(I, h*w, 1); % All pixel values in vector

% Assign unary terms using equation for \phi(x_i, y_i)
D = zeros(h*w, 2);
D(:,1) = 255 - y; 
D(:,2) = y; 

% Build sparse matrix
U = sparse(D);

end

