function [ msgU, msgD, msgL, msgR ] = normalizeMessages( msgU, msgD, msgL, msgR)
% Normalize messages with log-sum exp trick

msgU = msgU ./ sum(msgU,3);
msgD = msgD ./ sum(msgD,3);
msgL = msgL ./ sum(msgL,3);
msgR = msgR ./ sum(msgR,3);

end

