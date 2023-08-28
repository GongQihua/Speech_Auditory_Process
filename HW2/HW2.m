close all; clear; clc;
fs = 16000;
tt = 0:1/fs:1 - 1/fs;
wlen = 512;
overlap = wlen/4;
nfft = 512;
x=sin(2*pi*1500*tt).*(tt<=0.7) + sin(2*pi*2000*tt).*(tt>0.7&tt<=1);
win = hamming(wlen, 'periodic');

[S, f, t] = STFT(x, win, overlap, nfft, fs);

winlen = length(win);
C = sum(win)/winlen;
S = abs(S)/winlen/C;    
S = 20*log10(S + 1e-6);
figure;
surf(t, f, S)
shading interp;
axis tight;
view(0, 90);
%view(-45,60)
xlabel('Time, s');
ylabel('Frequency, Hz');
ylabel(colorbar, 'Magnitude, dB');