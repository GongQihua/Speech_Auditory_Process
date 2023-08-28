% dtwtest.m
clear;close all;clc;
disp('正在导入参考模板参数...');
load mel4.mat;

disp('正在计算测试模板的参数...')
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

disp('正在进行模板匹配...')
dist = zeros(10,10);
for i=1:10
    for j=1:10
        dist(i,j) = dtw(test(i).mfcc, ref(j).mfcc);
    end
end

disp('正在计算匹配结果...')
for i=1:10
	[d,j] = min(dist(i,:));
	fprintf('The test model aj_%da.wav compare the result sample：aj_%db.wav\n', i-1, j-1);
end
close all;