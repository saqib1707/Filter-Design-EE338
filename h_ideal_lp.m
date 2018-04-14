function [lpf_samp] = h_ideal_lp(wc, M)
    alpha = (M-1)/2;
    n = [0:1:(M-1)];
    m = n - alpha + eps;
    lpf_samp = sin(wc*m)./(pi*m);
    %lpf_samp(N+1) = 1;
end