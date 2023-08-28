function feature = PLP(rawdata,Fs)

data=rawdata;
[feature, spectra, pspectrum, lpcas, F, M] = rastaplp(data,Fs,0,12);
dt1 = acc(feature, 2);
dt2 = acc(dt1, 2);
feature = [feature; dt1; dt2];
feature = feature';



function dt = acc(input, winlen)

tmp = 0;
for cnt = 1 : winlen
    tmp = tmp + cnt*cnt;
end
num = 1 / (2*tmp);

dt   = zeros(size(input));
%rows = size(input,1);
cols = size(input,2);
for col = 1 : cols
    for cnt = 1 : winlen
        index1 = col - cnt; index2 = col + cnt;
        if index1 < 1;     index1 = 1;     end
        if index2 > cols;  index2 = cols;  end
        dt(:, col) = dt(:, col) + (input(:, index2) - input(:, index1)) * cnt;
    end
end
dt = dt * num;