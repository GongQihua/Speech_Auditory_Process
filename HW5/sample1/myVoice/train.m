%% train.m
disp('正在生成训练参数……');
for i=0:9
    fname=sprintf('male2_trial1\\aj_%da.wav',i);
    disp(fname)
    [k,fs]=audioread(fname);
    [StartPoint,EndPoint]=vad(k,fs);
    cc = mfcc(k);
    cc = cc(StartPoint-2:EndPoint-2,:);
    ref(i+1).StartPoint=StartPoint;
    ref(i+1).EndPoint=EndPoint;
    ref(i+1).mfcc=cc;
end
disp('正在存储模板库……');
save 'mel4.mat' ref;
close all;