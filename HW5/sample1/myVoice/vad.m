function [StartPoint,EndPoint]=vad(k,fs)
%% [StartPoint,EndPoint]=vad(k,fs)
%%     语音信号端点检测程序，k为语音信号，
%%     fs为其采样频率，程序绘制出语音信号
%%     相关波形图并返回起止端点所对帧号

close all;
% 幅度归一化到[-1,1]
k=double(k);
k=k./max(abs(k));
%------------------------------
%          显示波形
%------------------------------
disp('显示原始波形图……');
t=0:1/fs:(length(k)-1)/fs;
subplot(3,1,1);
plot(t,k);
axis([0,(length(k)-1)/fs,min(k),max(k)]);
title('(I)  “00.wav”语音信号波形');
xlabel('Time:s');
ylabel('Amplitude(normalized)');
disp('显示语音起始处放大波形图……');
t1=0.2:1/fs:0.3;
k1=k(0.2*fs:0.3*fs);
subplot(3,1,2);
plot(t1,k1);
axis([0.2,0.3,min(k),max(k)]);
title('(II)  “00.wav”语音起始处放大波形图');
xlabel('Time:s');
ylabel('Amplitude(normalized)');
disp('显示语音结束处放大波形图……');
t1=0.4:1/fs:0.5;
k1=k(0.4*fs:0.5*fs);
subplot(3,1,3);
plot(t1,k1);
axis([0.4,0.5,min(k),max(k)]);
title('(III)  “00.wav”语音结束处放大波形图');
xlabel('Time:s');
ylabel('Amplitude(normalized)');
%------------------------------
%        计算短时过零率
%------------------------------
FrameLen=240;
FrameInc=80;
FrameTemp1=enframe(k(1:end-1),FrameLen,FrameInc);
FrameTemp2=enframe(k(2:end),FrameLen,FrameInc);
signs=(FrameTemp1.*FrameTemp2)<0;
diffs=abs(FrameTemp1-FrameTemp2)>0.01;
zcr=sum(signs.*diffs,2);
disp('显示原始波形图……');
figure,subplot(3,1,1);
plot(t,k);
axis([0,(length(k)-1)/fs,min(k),max(k)]);
title('(I)  “00.wav”语音信号波形');
xlabel('Time:s');
ylabel('Amplitude(normalized)');
disp('显示过短时零率……')
zcrInd=1:length(zcr);
subplot(3,1,2);
plot(zcrInd,zcr);
axis([0,length(zcr),0,max(zcr)]);
title('(II)  短时过零率');
xlabel('Frame');
ylabel('Zcr');
%------------------------------
%         计算短时能量
%------------------------------
amp=sum(abs(enframe(filter([1 -0.9375], 1, k), FrameLen, FrameInc)), 2);
disp('显示短时能量……')
ampInd=1:length(amp);
subplot(3,1,3);
plot(ampInd,amp);
axis([0,length(amp),0,max(amp)]);
title('(III)  短时能量');
xlabel('Frame');
ylabel('Energy');
%------------------------------
%         设置门限
%------------------------------
disp('设置门限……');
ZcrLow=max([round(mean(zcr)*0.1),3]);                   %过零率低门限
ZcrHigh=max([round(max(zcr)*0.1),5]);                   %过零率高门限
AmpLow=min([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]);   %能量低门限
AmpHigh=max([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]);  %能量高门限
%------------------------------
%         端点检测
%------------------------------
MaxSilence=8;   %最长语音间隙时间
MinAudio=16;    %最短语音时间
Status=0;       %状态：0静音段,1过渡段,2语音段,3结束段
HoldTime=0;     %语音持续时间
SilenceTime=0;  %语音间隙时间
disp('开始端点检测……');
for n=1:length(zcr)
    switch Status
        case{0,1}
            if amp(n)>AmpHigh | zcr(n)>ZcrHigh
                StartPoint=n-HoldTime;
                Status=2;
                HoldTime=HoldTime+1;
                SilenceTime=0;
            elseif amp(n)>AmpLow | zcr(n)>ZcrLow
                Status=1;
                HoldTime=HoldTime+1;
            else
                Status=0;
                HoldTime=0;
            end
        case 2,
            if amp(n)>AmpLow | zcr(n)>ZcrLow
                HoldTime=HoldTime+1;
            else
               SilenceTime=SilenceTime+1;
               if SilenceTime<MaxSilence
                   HoldTime=HoldTime+1;
               elseif (HoldTime-SilenceTime)<MinAudio
                   Status=0;
                   HoldTime=0;
                   SilenceTime=0;
               else
                   Status=3;
               end
            end
        case 3,
            break;
    end
    if Status==3
        break;
    end
end
HoldTime=HoldTime-SilenceTime;
EndPoint=StartPoint+HoldTime;
disp('显示端点……');
figure,subplot(3,1,1);
plot(k);
axis([1,length(k),min(k),max(k)]);
title('(I)  “00.wav”语音信号');
xlabel('Sample');
ylabel('Speech');
line([StartPoint*FrameInc,StartPoint*FrameInc],[min(k),max(k)],'color','red');
line([EndPoint*FrameInc,EndPoint*FrameInc],[min(k),max(k)],'color','red');
subplot(3,1,2);
plot(zcr);
axis([1,length(zcr),0,max(zcr)]);
title('(II)  短时过零率');
xlabel('Frame');
ylabel('ZCR');
line([StartPoint,StartPoint],[0,max(zcr)],'Color','red');
line([EndPoint,EndPoint],[0,max(zcr)],'Color','red');
subplot(3,1,3);
plot(amp);
axis([1,length(amp),0,max(amp)]);
title('(III)  短时能量');
xlabel('Frame');
ylabel('Energy');
line([StartPoint,StartPoint],[0,max(amp)],'Color','red');
line([EndPoint,EndPoint],[0,max(amp)],'Color','red');