m = 36;
filt = 2;
samp_freq = (2-filt)*300e3 + (filt-1)*200e3;  % all frequency in KHz
[w2, w3] = bandedge(m, filt);  % [w2, w3] returned are in KHz
delta1 = 0.15;
delta2 = 0.15;
trans_band = 2e3;

% In case of bandpass filter w1, w4 : stopband edge w2, w3 : passband edge
% In case of bandstop filter w1, w4 : passband edge w2, w3 : stopband edge
w1 = w2 - trans_band;
w4 = w3 + trans_band;
norm_w2 = (2*w2/samp_freq)*pi;
norm_w3 = (2*w3/samp_freq)*pi;
norm_w1 = (2*w1/samp_freq)*pi;
norm_w4 = (2*w4/samp_freq)*pi;

% conversion from discrete to analog domain using tan
omega_w2 = tan(norm_w2/2);
omega_w3 = tan(norm_w3/2);
omega_w1 = tan(norm_w1/2);
omega_w4 = tan(norm_w4/2);

% conversion from bandpass/bandstop to equivalent low pass
fr = band2low(omega_w1, omega_w2, omega_w3, omega_w4, filt);

% low pass filter specs
omega_p = 1;
if filt == 1
    omega_s = min(abs(fr(1)), abs(fr(4)));
elseif filt == 2
    omega_s = min(abs(fr(2)), abs(fr(3)));
end;

% low pass filter
if filt == 1
    [num, den] = butterworth(omega_p, omega_s, delta1, delta2);
elseif filt == 2
    [num, den] = chebyshev(omega_p, omega_s, delta1, delta2);
end;

syms s z;
H_analog_lpf(s) = poly2sym(num, s)/poly2sym(den,s);
if filt == 1
    H_analog_bf(s) = H_analog_lpf((s*s + omega_w2*omega_w3)/(s*(omega_w3-omega_w2)));
elseif filt == 2
    H_analog_bf(s) = H_analog_lpf((omega_w4-omega_w1)*s/(omega_w1*omega_w4+s*s));
end
[testnum, testden] = numden(H_analog_bf(s));
testn = sym2poly(expand(testnum));
testd = sym2poly(expand(testden));
testn = testn/testd(1);
testd = testd/testd(1);

H_disc_bf(z) = H_analog_bf((z-1)/(z+1));

[n,d] = numden(H_disc_bf(z));   % converts (.) to a rational form where num and den are relatively prime polynomials with integer coefficients
nz = sym2poly(expand(n));       % expand simplifies inputs/multiplies all parentheses
dz = sym2poly(expand(d));       % sym2poly returns a vector of coefficients of symbolic polynomial
nz = nz/dz(1);
dz = dz/dz(1);
fvtool(nz, dz);           % magnitude response in dB

[H, f] = freqz(nz, dz, 1024*1024, samp_freq);
fmin = min(f);
fmax = max(f);

figure;
line([fmin, fmax],[1,1], 'Color',[1,0,0]);
line([fmin, fmax],[1-delta1, 1-delta1], 'Color',[1,0,0]);
line([fmin, fmax],[delta2, delta2],'Color',[1,0,0]);
hold on;
plot(f, abs(H));   % magnitude plot  
hold off;