function [tau_vec] = createTauJ(known_associations, M)
    
    % Group robot poses that have seen the same landmark j
    tau_vec = {size(M,2)};
    for j_num = 1 : size(M,2)
        tau_vec_j = [];
        lm_j = M(3,j_num);
        for x = 1 : size(known_associations,2)
            [lm_idx, ~] = find(lm_j == known_associations{x});
            if ~isempty(lm_idx)
                tau_vec_j = cat(1, tau_vec_j, x);
            end
        end
        tau_vec_j = sort(tau_vec_j);
        tau_vec{j_num} = tau_vec_j;
    end

end
