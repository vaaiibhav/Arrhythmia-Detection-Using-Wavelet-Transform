function [ Sig1Filter_PKS_ov05, PKS_ov05LOCS, R_R_Interval ] = Peaks_and_RR( given_THD, Sig1Filter, Sig1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Tried to add threshold value windowing, but didnt get it working properly.
%More explanation in the report.


 %PEAK DETECTOR

%{
windowed = 0; %This option is not working properly, so constant value is used
for i=1:1000:length(Sig1Filter(:,2))-1000
    window = Sig1Filter(i:i+1000, 2);
    for k=1:100
        windowed(i,k) = window(k);
    end
end  
for i=1:1000:length(Sig1Filter(:,2))-2000
    minimums(i) = min(windowed(i)); 
end
mean_min = mean(minimums);
%PeakTHD = mean_min*0.5; 
%}
 %{
%This option didnt work either. This one would have been the best in my
opinion.
Sig1Filter_PKS_ov05(1) = 0;
PKS_ov05LOCS(1) = 0;
for l = 1000:1000:length(Sig1Filter(:,2))
    window = Sig1Filter(l-999:l, 2);
    PeakTHD = mean(abs(window))*2;
    [pks,locs] = findpeaks(window,(l-999:l),'MinPeakHeight',PeakTHD, 'MinPeakWidth', 0.01, 'MinPeakDistance',0.3);
    Sig1Filter_PKS_ov05(end+1:end+length(pks)) = pks;
    PKS_ov05LOCS(end+1:end+length(locs)) = locs;
end
Sig1Filter_PKS_ov05 = Sig1Filter_PKS_ov05(2:end);
PKS_ov05LOCS = PKS_ov05LOCS(2:end);
%}

%PeakTHD = 0.5; %Didnt get threshold windowing working proprely, so 
                %used temporary threshold value
 PeakTHD = given_THD % After adding UI, threshold value is set by user.
 MinWidth = 0.01;
 MinDist = 0.3;
 [Sig1Filter_PKS_ov05,PKS_ov05LOCS] = findpeaks(Sig1Filter(:, 2), Sig1(:, 1), 'MinPeakHeight',PeakTHD, 'MinPeakWidth', MinWidth, 'MinPeakDistance',MinDist); %COUNT PEAKS THAT ARE OVER threshold;

 
 
 %Count differences between peak locations( RR-interval)
for j = 2:length(PKS_ov05LOCS)
    R_R_Interval(j-1) = PKS_ov05LOCS(j) - PKS_ov05LOCS(j-1);
end

end

