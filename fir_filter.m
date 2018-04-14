m = 36;
filt = 1;
samp_freq = (2-filt)*300e3 + (filt-1)*200e3;   % all frequency in KHz
[w2, w3] = bandedge(m, filt);  % [w2, w3] returned are in KHz
delta = 0.15;
trans_band = 2e3;

% In case of bandpass filter w1, w4 : stopband edge | w2, w3 : passband edge
% In case of bandstop filter w1, w4 : passband edge | w2, w3 : stopband edge
w1 = w2 - trans_band;
w4 = w3 + trans_band;
norm_w2 = (2*w2/samp_freq)*pi;
norm_w3 = (2*w3/samp_freq)*pi;
norm_w1 = (2*w1/samp_freq)*pi;
norm_w4 = (2*w4/samp_freq)*pi;

dwt = norm_w4 - norm_w3;

% kaiser design parameters 
A = -20*log10(delta);     % sidelobe attenuation of A dB

% window len
N = ceil((A-8)/(2.285*dwt)) + 32;

if(A < 21)
    alpha = 0;
elseif(A < 51)
    alpha = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    alpha = 0.1102*(A-8.7);
end
beta = alpha/N;

% generate window sequence v[n]
% v = zeros(N,1);
% for k=1:N
%     v(k,1) = (mykaiser(alpha*sqrt(1-(k/N)^2)))/(mykaiser(alpha));
% end;
v = (kaiser(N, beta))';

cutoff1 = (norm_w1 + norm_w2)/2;
cutoff2 = (norm_w3 + norm_w4)/2;
% generate ideal sequence h_ideal[n]
if filt == 1
    h_ideal_bf = h_ideal_lp(cutoff2, N) - h_ideal_lp(cutoff1, N);
elseif filt == 2
    h_ideal_bf = h_ideal_lp(pi, N) - (h_ideal_lp(cutoff2, N) - h_ideal_lp(cutoff1, N));
end;

% generate FIR impulse response h_fir[n] = h_ideal[n]*v[n]
h_fir_bf = h_ideal_bf.*v;
b = tf(h_fir_bf, 1);

fvtool(h_fir_bf);                       %frequency response
[H, f] = freqz(h_fir_bf, 1, 1024*1024, samp_freq); %magnitude response
fmin = min(f);
fmax = max(f);
plot(f,abs(H));
hold on;
line([fmin, fmax], [1,1], 'Color', [1,0,0]);
line([fmin, fmax], [1-delta, 1-delta], 'Color', [1,0,0]);
line([fmin, fmax], [1+delta, 1+delta], 'Color', [1,0,0]);
line([fmin, fmax], [delta, delta], 'Color', [1,0,0]);
hold off;