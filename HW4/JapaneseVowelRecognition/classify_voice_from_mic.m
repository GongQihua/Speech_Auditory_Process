%% 日本語の母音認識
%
% 音声信号をマイクから取り込み、日本語の５つの母音に分類します。
%
% Copyright 2016 The MathWorks, Inc.

%% 初期化

clear
close all

%% 音声信号の取り込み

Fs = 8000;
T = 3;

data = record_voice_from_mic(Fs, T);

%% フォルマント（特徴量）の計算

Y = calc_formant(data, Fs);

%% 分類器の構成

D = readtable('data_for_training.csv');
X = D{:, 1:2};
T = D{:, 3};

% K-最近傍分類器
d = fitcknn(X, T, 'NumNeighbors', 4);

% 線形判別分類器
% d = fitcdiscr(X, T, 'DiscrimType', 'linear');

% ２次判別分類器
% d = fitcdiscr(X, T, 'DiscrimType', 'quadratic');

%% 分類器による予測

C = predict(d, Y);

V = {'あ', 'い', 'う', 'え', 'お'};
disp('認識結果')
disp(V(C))
