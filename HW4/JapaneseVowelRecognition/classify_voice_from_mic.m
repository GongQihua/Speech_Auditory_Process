%% ���{��̕ꉹ�F��
%
% �����M�����}�C�N�����荞�݁A���{��̂T�̕ꉹ�ɕ��ނ��܂��B
%
% Copyright 2016 The MathWorks, Inc.

%% ������

clear
close all

%% �����M���̎�荞��

Fs = 8000;
T = 3;

data = record_voice_from_mic(Fs, T);

%% �t�H���}���g�i�����ʁj�̌v�Z

Y = calc_formant(data, Fs);

%% ���ފ�̍\��

D = readtable('data_for_training.csv');
X = D{:, 1:2};
T = D{:, 3};

% K-�ŋߖT���ފ�
d = fitcknn(X, T, 'NumNeighbors', 4);

% ���`���ʕ��ފ�
% d = fitcdiscr(X, T, 'DiscrimType', 'linear');

% �Q�����ʕ��ފ�
% d = fitcdiscr(X, T, 'DiscrimType', 'quadratic');

%% ���ފ�ɂ��\��

C = predict(d, Y);

V = {'��', '��', '��', '��', '��'};
disp('�F������')
disp(V(C))
