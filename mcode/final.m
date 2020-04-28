%%Calculate HR

close all; clear all; clc;

fs = 250 % find the sampling rate or frequency

T = 1/fs;% sampling rate or frequency
window = 120; % 2 min 0r 120 second

%%Select a filename in .mat format and load the file.
fignum = 0;
load('ecg.mat') % contains hr_sig and fs
% Make time axis for ECG signal
hr_sig=val;
tx = [0:length(hr_sig)-1]/fs;
fignum = fignum + 1;
figure(fignum)
plot(tx,hr_sig)
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('ECG signal')
xlim([30.3,31]) % Used to zoom in on single ECG waveform

disp('Contents of workspace after loading file:')
%whos
%% copy the data and put into excel
%  y1=xlsread('ecg_1.xls');
y1=hr_sig/60;
% find the length of the data per second
N = length(y1);
ls = size(y1);
t = (0 : N-1) / fs;% sampling period
fignum = fignum + 1; %% keep track of figures
figure(fignum)
plot(t,y1);
title ('plot of the original of ECG signal')
xlabel ('time (sec)')
ylabel ('Amplitute (mv)')
grid on;

%% find PP interval
 i = 0;  %% to make the code start from 0.
 rr = 0; %% each time the code run, rr distance two peaks
 hold off % for the next graph
 rrinterval = zeros(3600,1); % create an array to strore 2 peaks
beat_count =0;
for k = 2 : length(y1)-1
    %the peak has to be greater than 1 and greater than the value before it and greater then the value after it.
    if(y1(k)> y1(k-1) && y1(k) > y1(k+1) && y1(k)> 1);
     beat_count = beat_count +1;
     if beat_count ==1;
        rr =0;
     else
         rr = k-i;
         rrinterval(k)=rr;
         i=k;  
     end
    else
        rrinterval(k)= rr;
    end       
end

%% heart rate analysis
% count the dominat peak
beat_count =0;
for k = 2 : length(y1)-1
    %the peak has to be greater than 1 and greater than the value before it and greater then the value after it.
    if(y1(k)> y1(k-1) && y1(k) > y1(k+1) && y1(k)> 1)
         beat_count = beat_count +1;
    end       
end
display (k);
disp('dominant peaks');

%% this section is calculate heart rate of the ECG
%% divide the peak count by the duration in minute
duration_in_sec = N/fs;
duration_in_minute = duration_in_sec/60;
BPM = beat_count/duration_in_minute; %% this is calculation heart rate
msgbox(strcat('Heart-rate is = ',mat2str(BPM),' BPM'));


%Compute the spectrum of the ECG

%b) Compute the spectrum of the ECG and provide remarks on the spectral features of the ECG ( see reference “ECG Statistics, Noise, Artifacts, and Missing Data”).

%%%  DFT to describe the signal in the frequency
NFFT = 2 ^ nextpow2(N);
Y = fft(y1, NFFT) / N;
f = (fs / 2 * linspace(0, 1, NFFT / 2+1))'; % Vector containing frequencies in Hz
amp = ( 2 * abs(Y(1: NFFT / 2+1))); % Vector containing corresponding amplitudes
figure;
plot (f, amp);
title ('plot single-sided amplitude spectrume of the ECG signal');
xlabel ('frequency (Hz)');
ylabel ('|y(f)|');
grid on;

figure;
psdest = psd(spectrum.periodogram,y1,'fs',fs);
plot(psdest)
title ('plot single-sided PSD of the ECG signal');
xlabel ('frequency (Hz)');
ylabel ('|y(f)|');
grid on;

figure;
psdest1 = psd(spectrum.periodogram,y1,'NFFT',length(y1),'Fs',fs);
plot(psdest1)
avgpower(psdest1,[58,62]);
title ('plot single-sided PSD of the ECG signal')
xlabel ('frequency (Hz)');
ylabel ('|y(f)|');

grid on;
max_value=max(y1);
mean_value=mean(y1);
threshold=(max_value-mean_value)/2;


%% create a subset to zoom into the signal make easy to verify mark position
y1_1500 = y1(1:1850);
t2 = 1:length(y1_1500);
figure;
plot(t2,y1_1500);
title ('plot of subset of the ECG signal')
xlabel ('time (msec)')
ylabel ('Amplitute (mv)')
grid on
%c) Write code to automatically detect the various features of the ECG (PQRST) and use that to mark the ECG waveform features
%% used the snip code from this website.
%%%%http://www.mathworks.com/help/signal/examples/peak-analysis.html
%Detrending Data
%The above signal shows a baseline shift and therefore does not represent the true amplitude. In order to remove the trend, fit a low order polynomial to the signal and use the polynomial to detrend it.
[p,s,mu] = polyfit((1:numel(y1_1500))',y1_1500,6);
f_y = polyval(p,(1:numel(y1_1500))',[],mu);
ECG_data = y1_1500 - f_y;        % Detrend data
N1= length (y1_1500);
t1 = (0 : N1-1) / fs;% sampling period
figure
%plot(t1,ECG_data); grid on
plot(t2,ECG_data); grid on
ax = axis; axis([ax(1:2) -2.2 2.2])
%ax = axis; axis([ax(1:2) -3.2 3.2])
title('Detrended ECG Signal')
xlabel('time msec'); ylabel('Voltage(mV)')
legend('Detrended ECG Signal')

%Thresholding to Find Peaks of Interest
%The QRS-complex consists of three major components: Q-wave, R-wave, S-wave. The R-waves can be detected by thresholding peaks above 0.5mV. Notice that the R-waves are separated by more than 200 samples. Use this information to remove unwanted peaks by specifying a 'MinPeakDistance'.

[~,locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',0.5,...
                                    'MinPeakDistance',120);
%Finding Local Minima in Signal

%Local minima can be detected by finding peaks on an inverted version of the original signal.
ECG_inverted = -ECG_data;
[~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.4,...
                                        'MinPeakDistance',120);                                                           
%The following plot shows the R-waves and S-waves detected in the signal.
figure
hold on
plot(t2,ECG_data);
plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r');
plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b');
%axis([0 1850 -1.1 1.1]); grid on;
axis([0 1850 -2.2 2.2]); grid on;
legend('ECG Signal','R-waves','S-waves');
xlabel('time msec'); ylabel('Voltage(mV)')
title('R-wave and S-wave in ECG Signal')

[~,locs_Twave] = findpeaks(ECG_data,'MinPeakHeight',-0.02,...
                                      'MinPeakDistance',40);
                                  
%% The following code detect and mark T                                
figure;
hold on
plot(t2,ECG_data);                             
plot(locs_Twave,ECG_data(locs_Twave),'X','MarkerFaceColor','y');                               
plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r');
plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b');
grid on
title('Thresholding Peaks in Signal')
xlabel('time msec'); ylabel('Voltage(mV)')
ax = axis; axis([0 1850 -2.2 2.2])
legend('ECG signal','T-wave','R-wave','S-wave');
