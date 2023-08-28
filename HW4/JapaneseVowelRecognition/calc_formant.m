function F = calc_formant(voice, Fs)
%CALC_FORMANT �����M�������1�E��2�t�H���}���g�v�Z���܂�
%
%   F = calc_formant(voice, Fs) �����M�������1�E��2�t�H���}���g���v�Z���܂�
%
%       F : ��1�E��2�t�H���}���g���g��
%       voice : 
%       Fs : �T���v�����O���g��
%
%   Copyright 2016 The MathWorks, Inc.

% �X�e���I�����̕Б��̒��o

voice_trgt = voice(:, 1);

% ���拭���i�v���G���t�@�V�X�j

tap_b = [1 -0.96875];

voice_trgt = filter(tap_b, 1, voice_trgt);

% �����M���̑��|��

win_func = hamming(length(voice_trgt));
voice_trgt = win_func .* voice_trgt;

% Yule Walker �@�ɂ��X�y�N�g���̐���

Ndeg_ar = 10;
[P, f] = pyulear(voice_trgt, Ndeg_ar, 2048, Fs);
P = 10*log10(P);

% �t�H���}���g�̌��o

[~, Nsmp_pks] = findpeaks(P);
Xhz_pks = f(Nsmp_pks);

F = Xhz_pks(Xhz_pks > 200);

F = F(1:2)';
