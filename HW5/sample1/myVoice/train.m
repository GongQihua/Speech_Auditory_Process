%% train.m
disp('��������ѵ����������');
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
disp('���ڴ洢ģ��⡭��');
save 'mel4.mat' ref;
close all;