function [ Sig1Filter ] = Filtering( Sig1, Fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Noise occurs at 55.5Hz, filter out 55.4-55.7, also 111Hz is filtered
[b,a] = butter(2,[59.5, 60.5]/(Fs/2),'stop');%Create filters
%fvtool(b,a)
[d,c] = butter(10,100/(Fs/2),'low');
[f,e] = butter(1,0.5/(Fs/2),'high') %removes the baseline
Sig1Filter = filter(b,a,Sig1);%perform filtering
Sig1Filter = filter(d,c,Sig1Filter);
Sig1Filter = filter(f,e,Sig1Filter);

end

