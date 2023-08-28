clear;
close all;
clc;

disp('loading training mat');
load PLP4.mat;
for i=0:9
	filename = sprintf('male2_trial2\\aj_%db.wav',i);
    [k,fs]=audioread(filename);
    [StartPoint,EndPoint]=vad(k,fs);
    cc=PLP(k, fs);
    test(i+1).StartPoint=StartPoint;
    test(i+1).EndPoint=EndPoint;
    test(i+1).PLP=cc;
end

disp('matching...')
dist = zeros(10,10);
for i=1:10
    for j=1:10
        dist(i,j) = dtw(test(i).PLP, ref(j).PLP);
    end
end

disp('result:')
for i=1:10
	[d,j] = min(dist(i,:));
	fprintf('The test model aj_%da.wav compare the result sample£ºaj_%db.wav\n', i-1, j-1);
end
%close all;