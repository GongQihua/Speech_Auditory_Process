%Speaker Identification Demo
%Amin Koohi(AminKoohi@yahoo.com OR AminSohrevardi@yahoo.com )
% 
%Example:
%        >> code = train('train\', 8); %(Training stage)
%        >> test('test\', 8, code); %(Test)

clc; clear; clf;

disp(' ');
disp(' ');
[s1 fs1] = wavread('amintrain\s2.wav');
[s2 fs2] = wavread('amintrain\s3.wav');

t = 0:1/fs1:(length(s1) - 1)/fs1;
plot(t, s1), axis([0, (length(s1) - 1)/fs1 -0.4 0.5]);
title('Plot of signal s1.wav');
xlabel('Time [s]');
ylabel('Amplitude (normalized)')

pause
close all

M = 100;
N = 256;
frames = blockFrames(s1, fs1, M, N);
t = N / 2;
tm = length(s1) / fs1;
subplot(1,2,1);
imagesc([0 tm], [0 fs1/2], abs(frames(1:t, :)).^2), axis xy;
title('Power Spectrum (M = 100, N = 256)');
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colorbar;

subplot(1,2,2);
imagesc([0 tm], [0 fs1/2], 20 * log10(abs(frames(1:t, :)).^2)), axis xy;
title('Logarithmic Power Spectrum (M = 100, N = 256)');
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colorbar;
D=get(gcf,'Position');
set(gcf,'Position',round([D(1)*.5 D(2)*.5 D(3)*2 D(4)*1.3]))

pause
close all

lN = [128 256 512];
u=220;
for i = 1:length(lN)
    N = lN(i);
    M = round(N / 3);
    frames = blockFrames(s1, fs1, M, N);
    t = N / 2;
    temp = size(frames);
    nbframes = temp(2);
    u=u+1;
    subplot(u)
    imagesc([0 tm], [0 fs1/2], 20 * log10(abs(frames(1:t, :)).^2)), axis xy;
    title(sprintf('Power Spectrum (M = %i, N = %i, frames = %i)', M, N, nbframes));
    xlabel('Time [s]');
    ylabel('Frequency [Hz]');
    colorbar
end
D=get(gcf,'Position');
set(gcf,'Position',round([D(1)*.5 D(2)*.5 D(3)*1.5 D(4)*1.5]))
pause
close all

plot(linspace(0, (fs1/2), 129), (melfb(20, 256, fs1))');
title('Mel-Spaced Filterbank');
xlabel('Frequency [Hz]');

pause
close all

M = 100;
N = 256;
frames = blockFrames(s1, fs1, M, N);
n2 = 1 + floor(N / 2);
m = melfb(20, N, fs1);
z = m * abs(frames(1:n2, :)).^2;
t = N / 2;
tm = length(s1) / fs1;
subplot(1,2,1)
imagesc([0 tm], [0 fs1/2], abs(frames(1:n2, :)).^2), axis xy;
title('Power Spectrum unmodified');
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colorbar;
subplot(1,2,2)
imagesc([0 tm], [0 20], z), axis xy;
title('Power Spectrum modified through Mel Cepstrum filter');
xlabel('Time [s]');
ylabel('Number of Filter in Filter Bank');
colorbar;
D=get(gcf,'Position');
set(gcf,'Position',[0 D(2) D(3)*2 D(4)])
pause
close all

c1 = mfcc(s1, fs1);
c2 = mfcc(s2, fs2);
plot(c1(5, :), c1(6, :), 'or');
hold on;
plot(c2(5, :), c2(6, :), 'xb');
xlabel('5th Dimension');
ylabel('6th Dimension');
legend('Signal 1', 'Signal 2');
title('2D plot of accoustic vectors');

pause
close all

d1 = vqlbg(c1,16);
d2 = vqlbg(c2,16);
plot(c1(5, :), c1(6, :), 'xr')
hold on
plot(d1(5, :), d1(6, :), 'vk')
plot(c2(5, :), c2(6, :), 'xb')
plot(d2(5, :), d2(6, :), '+k')
xlabel('5th Dimension');
ylabel('6th Dimension');
legend('Speaker 1', 'Codebook 1', 'Speaker 2', 'Codebook 2');
title('2D plot of accoustic vectors');
pause
close all

 d1 = vqlbg(c1,16);
 d2 = vqlbg(c2,16);
 subplot(1,2,1)
 plot(c1(5, :), c1(6, :), 'or')
 hold on
 plot(d1(5,:),d1(6,:),'+')
 xlabel('5th Dimension');
 ylabel('6th Dimension');
 legend('Speaker 1', 'Codebook of s1');
 title('2D plot of accoustic vectors');
 subplot(1,2,2)
 plot(c2(5, :), c2(6, :), 'or')
 hold on
 plot(d2(5,:),d2(6,:),'+')
 xlabel('5th Dimension');
 ylabel('6th Dimension');
 legend('Speaker 2', 'Codebook of s2');
 title('2D plot of accoustic vectors');
 D=get(gcf,'Position');
 set(gcf,'Position',[0 D(2) D(3)*2 D(4)])
 pause
 close all