close all
addpath('maxflow')

% Read original image
I = double(imread('a.png'));
[h,w] = size(I);
imshow(I, 'InitialMagnification', 'fit')

% Read image with white noise
I1 = double(imread('a2.png'));
imshow(I1, 'InitialMagnification', 'fit')

% Set unary weights
unary_terms = compute_unary_terms(I1);
lambda = 1;
pairwise_terms = compute_pairwise_terms(I1, lambda);
[best_flow, best_labels] = maxflow(pairwise_terms, unary_terms);
best_sim = Inf;
for lambda=2:200
    pairwise_terms = compute_pairwise_terms(I1, lambda);
    % Run maxflow
    [flow, labels] = maxflow(pairwise_terms, unary_terms);
    imageRest = reshape(double(labels), h, w);
    sim = sum(sum(abs(I - imageRest)));
    if sim < best_sim
        best_sim = sim;
        best_labels = labels;
    end
end
Ir = reshape(double(best_labels), h, w);
imshow(Ir)
imwrite(Ir, 'restored_a.png')
