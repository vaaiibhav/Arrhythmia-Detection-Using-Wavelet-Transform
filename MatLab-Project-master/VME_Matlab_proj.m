close all;
clear all;
Sig1 = load('100.txt');%LOAD signals


    Sig1_fft = fft(Sig1(:, 2));%From timedomain to freq domain
     %DT = Sig1(2,1) - Sig1(1,1);
     Dif_vect = diff(Sig1(:,1));%time between samples is not constant,...
     %so just subtraction between first two sample is not trustable
     figure;
     plot(Dif_vect)
     title('Time between samples')
     DT = mean(Dif_vect);%Averaging gives us better time between samples     
     % sampling frequency based on new DT value
     Fs = 1/DT
     DF = Fs/size(Sig1,1)
     freq = 0:DF:Fs/2;
     Sig1_fft = Sig1_fft(1:length(Sig1_fft)/2+1);
     figure;
     subplot(2,1,1);
     plot(freq,20*log10(abs(Sig1_fft)));%Plot frequency domain
     title('Original frequency domain signal')

[Sig1Filter] = Filtering(Sig1,Fs); %Perform filtering    
    Sig1filt_fft = fft(Sig1Filter(:, 2)); %plot filtered freq domain signal 
     % sampling frequency
     Fs2 = 1/DT
     DF2 = Fs2/size(Sig1Filter,1)
     freq = 0:DF2:Fs2/2;
     Sig1filt_fft = Sig1filt_fft(1:length(Sig1filt_fft)/2+1);
     subplot(2,1,2)
     plot(freq,20*log10(abs(Sig1filt_fft))); %Plot filtered frequency domain
     title('Filtered frequency domain signal')
          

     
%PEAK DETECTOR
%Function executes RRinterval calculation as well
[Sig1Filter_PKS_ov05, PKS_ov05LOCS, R_R_Interval ] = Peaks_and_RR( Sig1Filter, Sig1);           
Numb_of_PKS_over = numel(Sig1Filter_PKS_ov05)

%Plot filtered time domain signal and peak finder
figure;
plot(Sig1(:, 1), Sig1Filter(:, 2)) 
hold on
plot (PKS_ov05LOCS, Sig1Filter_PKS_ov05, 'o')
title('Filtered signal and peak detector')
PKS_ov05LOCS = PKS_ov05LOCS(1: end-1);
figure;
subplot(2,1,1)
plot(PKS_ov05LOCS, R_R_Interval)
ylabel('RR-interval[s]')

    
%POINCARE plot, plots (xt, xt+1),then plots(xt+1, xt+2),then (xt+2, xt+3)..
figure;
plot(R_R_Interval(1:end-1),R_R_Interval(2:end), '.')
title('Poincare Plot')
xlabel('RR (n)')
ylabel('RR (n-1)')
%Used for loop (below) first to perform poincare, but to make it faster changed it
%to above
%{
for i = 1:(length(R_R_Interval)-1)
    plot(R_R_Interval(i),R_R_Interval(i+1), '.')
    hold on;
end
%}

[ RR_Category ] = Beat_classifi( R_R_Interval ); %Arrhythmic beat classification

%Additional features.

%Plot HR, in test point of view
HR = (60./R_R_Interval);
subplot(2,1,2)
plot(PKS_ov05LOCS,HR)
ylabel('Heart Rate ppm')

%AVG HR
HR_TOT = 0;
for t = 1:length(HR)
    HR_TOT = HR_TOT + HR(t);
end
AVG_HR = HR_TOT/length(HR)

%AVG R-R
AVG_R_R = mean(R_R_Interval)

%standard deviation
StDev_HR = std(HR)
StDev_R_R = std(R_R_Interval)

figure;
plot(PKS_ov05LOCS,RR_Category, 'x')
title('Arrhythmic Beat Classification')
ylim([0 5]); 