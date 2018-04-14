function [num,den] = chebyshev(wp, ws, delta1, delta2)
    D1 = (1/(1-delta1).^2)-1;
    D2 = (1/delta2.^2)-1;
    epsilon = sqrt(D1);
    N = ceil(acosh(sqrt(D2)/epsilon)/acosh(ws/wp));
    poles = zeros(N, 1);
    B = (asinh(1/epsilon))/N;
    count = 1;
    product = 1;
    for k=1:2*N
        A = ((2*k+1)*pi)/(2*N);
        pole = -wp*sin(A)*sinh(B) + 1i*wp*cos(A)*cosh(B);
        if real(pole) < 0
            poles(count) = pole;
            count = count + 1;
            product = product*(-pole);
        end;
    end;
    Z = [];
    P = poles
    if mod(N,2) == 0
        K = product/sqrt(1+epsilon.^2);
    else
        K = product;
    end;
    [num, den] = zp2tf(Z,P,K);
end