close all; clear; clc;

wlen = 512;
overlap = wlen/4;
nfft = 512;
for i = 1 : 10
    filename = sprintf('Rex/rex%d.wav',i);
    fprintf('for the file %s: ',filename)
    [x, fs] = audioread(filename);
    win = hamming(wlen, 'periodic');

    [S, Fs, t] = spectrogram(x, win, overlap, nfft, fs);
    winlen = length(win);
    C = sum(win)/winlen;
    S = abs(S)/winlen/C;    
    S = 20*log10(S + 1e-6);

    Y = x(:, 1);
    tap = [1 -0.96875];
    Y = filter(tap, 1, Y);
    win_func = hamming(length(Y));
    Y = win_func .* Y;
    [P, f] = pyulear(Y, 10, 2048, fs);
    P = 10*log10(P);
    [~, peaks] = findpeaks(P);
    energy = f(peaks);
    F = energy(energy > 200);
    F = F(1:2)';
    F1 = F(1)';
    F2 = F(2)';
    if (F1 > 500) && (F1 < 900)
        if (F2 > 1400) && (F2 < 2000)
            disp('Rex is here')
        else
            disp('Not Rex')
        end
    else
        disp('Not Rex')
    end
end
figure;
surf(t, Fs, S)
shading interp;
axis tight;
view(0, 90);
xlabel('Time, s');
ylabel('Frequency, Hz');
ylabel(colorbar, 'Magnitude, dB');