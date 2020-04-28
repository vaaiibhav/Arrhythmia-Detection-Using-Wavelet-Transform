clear all;
close all;
clc;
load mit200;
figure;
plot(tm,ecgsig);
hold on;
plot(tm(ann),ecgsig(ann),'ro');
xlabel('Seconds'); ylabel('Amplitude');
title('Subject - MIT-BIH 200');

qrsEx = ecgsig(4560:4810);
[mpdict,~,~,longs] = wmpdictionary(numel(qrsEx),'lstcpt',{{'sym4',3}});
figure;
plot(qrsEx);
hold on;
plot(2*circshift(mpdict(:,11),[-2 0]),'r');
axis tight;
legend('QRS Complex','Sym4 Wavelet');
title('Comparison of Sym4 Wavelet and QRS Complex');


wt = modwt(ecgsig,5);
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
y = imodwt(wtrec,'sym4');


y = abs(y).^2;
[qrspeaks,locs] = findpeaks(y,tm,'MinPeakHeight',0.35,...
    'MinPeakDistance',0.150);
figure;
plot(tm,y)
hold on
plot(locs,qrspeaks,'ro')
xlabel('Seconds')
title('R Peaks Localized by Wavelet Transform with Automatic Annotations')

plot(tm(ann),y(ann),'k*')
title('R peaks Localized by Wavelet Transform with Expert Annotations')