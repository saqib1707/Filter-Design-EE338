function [num, den] = butterworth(omega_p, omega_s, delta1, delta2)
    D1 = (1/(1-delta1).^2)-1;
    D2 = (1/delta2.^2)-1;
    N = ceil(log10(sqrt(D2/D1))/log10(omega_s/omega_p));
    b = omega_s/D2.^(0.5/N);      % omega_c lies in [a,b]
    a = omega_p/D1.^(0.5/N);
    %omega_c = (b-a)*rand(1) + a;
    omega_c = 1.069;
    poles = zeros(N,1);
    count = 1;
    for k=1:2*N
        pole = omega_c*exp(1i*((2*k+1)*(pi/(2*N)) + pi/2));
        if real(pole) < 0
            poles(count) = pole;
            count = count + 1;
        end;
    end;
    Z = [];
    P = poles;
    K = omega_c.^N;
    [num, den] = zp2tf(Z,P,K);
end