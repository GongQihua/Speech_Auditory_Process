function data = record_voice_from_mic(Fs, T)
%RECORD_VOICE_FROM_MIC マイクから音声を取得します
%
%   data = record_voice_from_mic(Fs, T) でマイクから音声を取得します
%
%       data : 音声データ
%       Fs : サンプリング周波数
%       T : 基本となる録音時間
%
%   Copyright 2016 The MathWorks, Inc.

recObj = audiorecorder(Fs, 24, 1);
disp('録音開始...')
recordblocking(recObj, T);
disp('録音終了');

% 録音した音声データを取得する
data = getaudiodata(recObj);

% 振幅の二乗の移動平均を算出する
windowSize = floor(Fs / 10);    % 窓長：約 0.1秒
powerSmooth = filter(ones(1, windowSize) / windowSize, 1, data.^2);

% 閾値を設定して音声区間を検出する
threshold = max(powerSmooth) / 10;  % 最大パワーの 1/10
idx = powerSmooth > threshold;

voice_bgn = find(idx, 1, 'first');
voice_end = find(idx, 1, 'last');

% 無音区間をマージンとして追加する
voice_bgn = max(voice_bgn - windowSize, 1);
voice_end = min(voice_end, length(data));

% 音声区間の切り出し
data = data(voice_bgn:voice_end);
