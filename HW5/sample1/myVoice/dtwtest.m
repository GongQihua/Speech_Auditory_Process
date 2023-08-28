% dtwtest.m
clear;close all;clc;
disp('���ڵ���ο�ģ�����...');
load mel4.mat;

disp('���ڼ������ģ��Ĳ���...')
for i=0:9
	fname = sprintf('male2_trial2\\aj_%db.wav',i);
    [k,fs]=audioread(fname);
    [StartPoint,EndPoint]=vad(k,fs);
    cc=mfcc(k);
    cc=cc(StartPoint-2:EndPoint-2,:);
    test(i+1).StartPoint=StartPoint;
    test(i+1).EndPoint=EndPoint;
    test(i+1).mfcc=cc;
end

disp('���ڽ���ģ��ƥ��...')
dist = zeros(10,10);
for i=1:10
    for j=1:10
        dist(i,j) = dtw(test(i).mfcc, ref(j).mfcc);
    end
end

disp('���ڼ���ƥ����...')
for i=1:10
	[d,j] = min(dist(i,:));
	fprintf('The test model aj_%da.wav compare the result sample��aj_%db.wav\n', i-1, j-1);
end
close all;