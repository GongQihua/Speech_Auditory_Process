function F = calc_formant(voice, Fs)
%CALC_FORMANT 音声信号から第1・第2フォルマント計算します
%
%   F = calc_formant(voice, Fs) 音声信号から第1・第2フォルマントを計算します
%
%       F : 第1・第2フォルマント周波数
%       voice : 
%       Fs : サンプリング周波数
%
%   Copyright 2016 The MathWorks, Inc.

% ステレオ音源の片側の抽出

voice_trgt = voice(:, 1);

% 高域強調（プリエンファシス）

tap_b = [1 -0.96875];

voice_trgt = filter(tap_b, 1, voice_trgt);

% 音声信号の窓掛け

win_func = hamming(length(voice_trgt));
voice_trgt = win_func .* voice_trgt;

% Yule Walker 法によるスペクトルの推定

Ndeg_ar = 10;
[P, f] = pyulear(voice_trgt, Ndeg_ar, 2048, Fs);
P = 10*log10(P);

% フォルマントの検出

[~, Nsmp_pks] = findpeaks(P);
Xhz_pks = f(Nsmp_pks);

F = Xhz_pks(Xhz_pks > 200);

F = F(1:2)';
