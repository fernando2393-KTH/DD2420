function [known_associations] = getKnownAssociations(flines, num_poses)
    
    count = 0;
    known_associations={num_poses};
    while 1
        count = count + 1;
        if count > length(flines)
            break;
        end
        line = flines{count};
        values = sscanf(line, '%f');
        n = values(10);
        if (n > 0) 
            ids = values(11:3:end);
        else
            ids = [];
        end
        
        known_associations{count} = ids';
    end
end