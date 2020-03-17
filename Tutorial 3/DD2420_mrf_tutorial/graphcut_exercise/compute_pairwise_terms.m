function V = compute_pairwise_terms(I, lambda)
% Computing the pairwise terms in the graph.
% Args: I = Image
%       lambda = smoothing term
% Returns: V = Sparse matrix representing the graph structure

%%% Task 
% Make sure that you understand how the computation of the 
% pairwise terms work. 
%
% Note that all weights are set to gamma in this exercise.
%%%

I = single(I);
[height, width, ~] = size(I);

pixel_map = reshape(1:height*width, height, width);

s = zeros(2*(height-1)*width + 2*height*(width-1),1);
t = zeros(2*(height-1)*width + 2*height*(width-1),1);
weights = zeros(2*(height-1)*width + 2*height*(width-1),1);

weight = lambda; 

idx = 1;
for y = 1:height
    for x = 1:width
        if x < width
            s(idx) = pixel_map(y,x);
            t(idx) = pixel_map(y,x+1);
            weights(idx) = weight;
            idx=idx+1;
            s(idx) = pixel_map(y,x+1);
            t(idx) = pixel_map(y,x);
            weights(idx) = weight;
            idx=idx+1;
        end
        
        if y < height
            s(idx) = pixel_map(y,x);
            t(idx) = pixel_map(y+1,x);
            weights(idx) = weight;
            idx=idx+1;
            s(idx) = pixel_map(y+1,x);
            t(idx) = pixel_map(y,x);
            weights(idx) = weight;
            idx=idx+1;
        end
    end
end

V = sparse(s,t,weights);

end

