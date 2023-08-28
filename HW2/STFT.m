function [S, f, t] = STFT(x, win, overlap, nfft, fs)

    x = x(:);
    xlen = length(x);
    winlen = length(win);
    L = 1+fix((xlen-winlen)/overlap);
    S = zeros(nfft, L);
    
    for l = 0:L-1
        xw = x(1+l*overlap : winlen+l*overlap).*win;
        X = fft(xw, nfft);
        X = fftshift(X);
        S(:, 1+l) = X(1:nfft);
    end
    
    t = (winlen/2:overlap:winlen/2+(L-1)*overlap)/fs;
    f = (-nfft/2:nfft/2-1) * (fs/nfft);
    
end