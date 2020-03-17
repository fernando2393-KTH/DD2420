function [x_hat_t, G_t, t, enc, stop] = predict(count, flines, mu_rob, t, enc)

    E_T = 2048;
    B = 0.35;
    R_L = 0.1;
    R_R = 0.1; 
    stop = 0;

    % If end of file, break
    if count > length(flines)
        stop = 1;
        x_hat_t = zeros(3,1);
        G_t = zeros(3,3);
        t = 0;
        enc = [0,0];
        return;
    end
    
    % Read file
    line = flines{count};
    values = sscanf(line, '%f');
    pt = t;
    t = values(1);
    delta_t = t - pt;
    penc = enc;
    enc = values(5:6);
    denc = enc - penc;
    
    % Increment robot poses counter
    poses_cnt = (count-1)*3 + 1;
      
    % Compute odom
    mu_tprev = mu_rob(poses_cnt:poses_cnt+2, 1);    
    u = calculate_odometry(denc(1),denc(2),E_T,B,R_R,R_L,delta_t,mu_tprev);
    x_hat_t = mu_tprev + u;
    
    % Keep values of yaw within limits    
    x_hat_t(3,1) = mod(x_hat_t(3,1) + pi, 2*pi)-pi;

    % Jacobian of transition model
    G_t = [1,  0, -1*u(2);
           0,  1,    u(1);
           0,  0,      1];
    
end