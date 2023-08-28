function cc=melSpectrogram(k)

M=24; N=256;

bank=melbankm(M,N,8000,0,0.5,'m');
figure;
plot(linspace(0,N/2,129),bank);
title('Mel-Spaced Filterbank');
xlabel('Frequency [Hz]');
bank=full(bank);
bank=bank/max(bank(:));

for i=1:12
  j=0:23;
  coeff(i,:)=cos((2*j+1)*i*pi/(2*24));
end

w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

AggrK=double(k);
AggrK=filter([1,-0.9375],1,AggrK);

FrameK=enframe(AggrK,N,80);

for i=1:size(FrameK,1)
    FrameK(i,:)=(FrameK(i,:))'.*hamming(N);
end
FrameK=FrameK';

S=(abs(fft(FrameK))).^2;
figure;
plot(S);
axis([1,size(S,1),0,2]);
title('Power Spectrum (M=24, N=256)');
xlabel('Frame');
ylabel('Frequency [Hz]');
colorbar;

P=bank*S(1:129,:);
D=coeff*log(P);
for i=1:size(D,2)
    m(i,:)=(D(:,i).*w')';
end

dtm=zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;

cc=[m,dtm];
cc=cc(3:size(m,1)-2,:);