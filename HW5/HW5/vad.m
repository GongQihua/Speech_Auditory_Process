function [StartPoint,EndPoint]=vad(k,fs)

close all;
k=double(k);
k=k./max(abs(k));

FrameLen=240;
FrameInc=80;
FrameTemp1=enframe(k(1:end-1),FrameLen,FrameInc);
FrameTemp2=enframe(k(2:end),FrameLen,FrameInc);
signs=(FrameTemp1.*FrameTemp2)<0;
diffs=abs(FrameTemp1-FrameTemp2)>0.01;
zcr=sum(signs.*diffs,2);
amp=sum(abs(enframe(filter([1 -0.9375], 1, k), FrameLen, FrameInc)), 2);
ZcrLow=max([round(mean(zcr)*0.1),3]);
ZcrHigh=max([round(max(zcr)*0.1),5]);                  
AmpLow=min([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]);
AmpHigh=max([min(amp)*10,mean(amp)*0.2,max(amp)*0.1]); 

MaxSilence=8;
MinAudio=16;
Status=0; 
HoldTime=0;
SilenceTime=0;

for n=1:length(zcr)
    switch Status
        case{0,1}
            if amp(n)>AmpHigh || zcr(n)>ZcrHigh
                StartPoint=n-HoldTime;
                Status=2;
                HoldTime=HoldTime+1;
                SilenceTime=0;
            elseif amp(n)>AmpLow || zcr(n)>ZcrLow
                Status=1;
                HoldTime=HoldTime+1;
            else
                Status=0;
                HoldTime=0;
            end
        case 2
            if amp(n)>AmpLow || zcr(n)>ZcrLow
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
        case 3
            break;
    end
    if Status==3
        break;
    end
end
HoldTime=HoldTime-SilenceTime;
EndPoint=StartPoint+HoldTime;

figure;
subplot(3,1,1);
plot(k);
axis([1,length(k),min(k),max(k)]);
xlabel('Sample');
ylabel('Speech');
line([StartPoint*FrameInc,StartPoint*FrameInc],[min(k),max(k)],'color','red');
line([EndPoint*FrameInc,EndPoint*FrameInc],[min(k),max(k)],'color','red');
subplot(3,1,2);
plot(zcr);
axis([1,length(zcr),0,max(zcr)]);
xlabel('Frame');
ylabel('ZCR');
line([StartPoint,StartPoint],[0,max(zcr)],'Color','red');
line([EndPoint,EndPoint],[0,max(zcr)],'Color','red');
subplot(3,1,3);
plot(amp);
axis([1,length(amp),0,max(amp)]);
xlabel('Frame');
ylabel('Energy');
line([StartPoint,StartPoint],[0,max(amp)],'Color','red');
line([EndPoint,EndPoint],[0,max(amp)],'Color','red');