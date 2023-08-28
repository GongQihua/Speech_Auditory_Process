disp('training......');
for i=0:9
    filename=sprintf('male2_trial1\\aj_%da.wav',i);
    disp(filename)
    [k,fs]=audioread(filename);
    [StartPoint,EndPoint]=vad(k,fs);
    cc = PLP(k, fs); % use in PLP
    %cc = melSpectrogram(k) % use in melSpectrogram
    ref(i+1).StartPoint=StartPoint;
    ref(i+1).EndPoint=EndPoint;
    ref(i+1).PLP=cc;
end
disp('saving the mat form');
save 'PLP4.mat' ref;
close all;