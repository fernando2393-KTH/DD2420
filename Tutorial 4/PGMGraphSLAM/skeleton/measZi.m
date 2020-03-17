function [z, known_associations, stop] = measZi(flines, count)
    
    stop = false;
    if count > length(flines)
        stop = true;
        z = zeros(3,1);
        known_associations = [];
        return;
    end
    line = flines{count};
    values = sscanf(line, '%f');
    n = values(10);
    if (n > 0) 
        bearings = values(12:3:end);
        ranges = values(13:3:end);
        ids = values(11:3:end);
    else
        bearings = [];
        ranges = [];
        ids = [];
    end
        
    % Store measurements
    known_associations = ids';
    z = [ranges';bearings';known_associations];
end