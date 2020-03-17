addpath('images');
img = imread('images/mrf.png');

% Resize image, turn it into grayscale and make double-valued
h = 200;
w = 200;
imgTrue = rgb2gray(imresize(img, [h w]));
imgTrue = double(imgTrue > 0.5);

% Add noise to image by flipping pixel value
% with probability theta
imgNoisy = imgTrue;
theta = 0.1;
for i=1:h
    for j=1:w
        u = rand;
        if u <= theta
            if imgNoisy(i,j) == 1
                imgNoisy(i,j) = 0;
            else
                imgNoisy(i,j) = 1;
            end
        end
    end
end

% Set parameters
tau = 100.0;
lambda = 100.0;
nIter = 100;

% Run LBP
[labels, energy,labels_all] = binaryImageDenoising(imgNoisy, lambda, tau, nIter);

% Plot and save results
figure()
plot(energy, '-o')
xlabel('Iterations'); ylabel('Energy')
figure()
imshow(labels, [0 1])
figure()
imshow(imgNoisy,[0 1])
