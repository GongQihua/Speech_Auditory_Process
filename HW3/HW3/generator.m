clear
clc

F0 = 100; %parameters set
Fs = 16000;
BW = 256;

ff1  = 300;
High1 = 350;
Low1 = 250;

ff2  = 800;
High2 = 850;
Low2 = 750;

om1 = (2 * pi * ff1) / Fs;
Bw1 = Low1 - High1;
k1 = (-pi * Bw1) / Fs;
r1 = exp(k1);
a11 = (-2 * r1 * cos(om1));
a12 = (r1 * r1);
om2 = (2 * pi * ff2) / Fs;
Bw2 = Low2 - High2;
k2 = (-pi * Bw2) / Fs;
r2 = exp(k2);
a21 = (-2 * r2 * cos(om2));
a22 = (r2 * r2);
mx = [1 0 0 1, a11 a12; 1 0 0 1, a21 a22];
[b, a] = sos2tf(mx); %change peak to filter para


glottal = glott(Fs, F0);% create signal
output = filter(b, a, glottal); %build in filter function
soundsc(glottal, Fs)
%audiowrite('uh.wav',glottal, Fs);


figure (1);
t= linspace(0, length(glottal)/Fs, length(glottal));
plot(t, glottal)
xlabel('Time (sec)')
ylabel('Amplitude')

figure(2)
t = linspace(0, Fs/2, length(output)/2);
m = (abs(fft(output)));
M = db(m(1: fix(length(output)/2)));
plot(t, M)
xlabel('Frequency (Hz)')
ylabel('Magnitude (db)')