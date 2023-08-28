function [glottal] = glott(fs, f0)
    N1 = round(0.0025 * fs);
    N3 = round(0.003 * fs);
    N2 = N3 - N1;
    
    sig = zeros(1, N3);
    for i = 1:N1
        sig(i) = 0.5 * (1 - cos((pi * i)/N1));
    end
    for i = N1 + 1 : N3
        sig(i) = cos(pi * (i - N1) / (2 * N2));
    end
    
    p= zeros(size(sig));
    train= zeros(1, 1*fs);
    sig= cat(2, p, cat(2, sig, p));    

    for i= 1: length(train)
        if mod(i, f0) == 0
            train(i)= 1;
        end
    end
    
    glottal= conv(sig, train);% Creates complete signal
    noise= randn(size(glottal));
    noise= noise ./ (10*max(abs(noise)));
    glottal= glottal + noise;
end
