function [ msgU, msgD, msgL, msgR ] = updateMessages( msgUPrev, msgDPrev, msgLPrev, msgRPrev, dataCost, lambda )
% Update messages with selected updating algorithm

msgU = zeros(size(dataCost));
msgD = zeros(size(dataCost));
msgL = zeros(size(dataCost));
msgR = zeros(size(dataCost));

[~, ~, nLevels] = size(dataCost);
labels = 0:(nLevels-1)

% circshift shifts the an array/matrix circularly
% 2nd argument indicates the number of shift steps and in which direction
% 3rd argument indicates the axis along the shift is performed
incomingMsgFromU = circshift(msgDPrev, 1, 1);
incomingMsgFromD = circshift(msgUPrev, -1, 1);
incomingMsgFromL = circshift(msgRPrev, 1, 2);
incomingMsgFromR = circshift(msgLPrev, -1, 2);

for l = 0:nLevels-1
    for lfirst = 0:nLevels-1
        tmp = exp(double(l ~= lfirst)* lambda);
        tempMsgU(:, :, lfirst+1) = (incomingMsgFromD(:, :, lfirst+1) .* incomingMsgFromL(:, :, lfirst+1) .* incomingMsgFromR(:, :, lfirst+1)) .* exp(-dataCost(:, :, lfirst+1)) * exp(-double(l ~= lfirst)* lambda);
        tempMsgR(:, :, lfirst+1) = (incomingMsgFromD(:, :, lfirst+1) .* incomingMsgFromL(:, :, lfirst+1) .* incomingMsgFromU(:, :, lfirst+1)) .* exp(-dataCost(:, :, lfirst+1)) * exp(-double(l ~= lfirst)* lambda);
        tempMsgD(:, :, lfirst+1) = (incomingMsgFromU(:, :, lfirst+1) .* incomingMsgFromL(:, :, lfirst+1) .* incomingMsgFromR(:, :, lfirst+1)) .* exp(-dataCost(:, :, lfirst+1)) * exp(-double(l ~= lfirst)* lambda);
        tempMsgL(:, :, lfirst+1) = (incomingMsgFromU(:, :, lfirst+1) .* incomingMsgFromR(:, :, lfirst+1) .* incomingMsgFromD(:, :, lfirst+1)) .* exp(-dataCost(:, :, lfirst+1)) * exp(-double(l ~= lfirst)* lambda);
    end
    msgU(:, :, l+1)=max(tempMsgU(:, :, 1), tempMsgU(:, :, 2));
    msgR(:, :, l+1)=max(tempMsgR(:, :, 1), tempMsgR(:, :, 2));
    msgD(:, :, l+1)=max(tempMsgD(:, :, 1), tempMsgD(:, :, 2));
    msgL(:, :, l+1)=max(tempMsgL(:, :, 1), tempMsgL(:, :, 2));
    
end
% Update the mesages using the incoming ones above.
% Use the Potts model for computing the cost \phi(x_i, x_j)

end

