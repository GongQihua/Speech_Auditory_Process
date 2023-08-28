function data = record_voice_from_mic(Fs, T)
%RECORD_VOICE_FROM_MIC �}�C�N���特�����擾���܂�
%
%   data = record_voice_from_mic(Fs, T) �Ń}�C�N���特�����擾���܂�
%
%       data : �����f�[�^
%       Fs : �T���v�����O���g��
%       T : ��{�ƂȂ�^������
%
%   Copyright 2016 The MathWorks, Inc.

recObj = audiorecorder(Fs, 24, 1);
disp('�^���J�n...')
recordblocking(recObj, T);
disp('�^���I��');

% �^�����������f�[�^���擾����
data = getaudiodata(recObj);

% �U���̓��̈ړ����ς��Z�o����
windowSize = floor(Fs / 10);    % �����F�� 0.1�b
powerSmooth = filter(ones(1, windowSize) / windowSize, 1, data.^2);

% 臒l��ݒ肵�ĉ�����Ԃ����o����
threshold = max(powerSmooth) / 10;  % �ő�p���[�� 1/10
idx = powerSmooth > threshold;

voice_bgn = find(idx, 1, 'first');
voice_end = find(idx, 1, 'last');

% ������Ԃ��}�[�W���Ƃ��Ēǉ�����
voice_bgn = max(voice_bgn - windowSize, 1);
voice_end = min(voice_end, length(data));

% ������Ԃ̐؂�o��
data = data(voice_bgn:voice_end);
