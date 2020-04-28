close all;
clear all;
clc;
[tm,sig]=rdsamp('database/a01',1);
plot(tm,sig);
time = length(sig);
shortsig = sig(1:200);
for x=1:200
p=max(shortsig);
% x=x+1;
end    
disp('p =');
disp(p);
nextshortsig = sig(200:500);
for x=1:300
R=max(nextshortsig);
% x=x+1;
end    
[indexR,locR] =ismember(R,sig);
disp('R =');
disp(R);
disp(locR);
timeR=(locR/1000)-0.0010;
disp('Time for R');
disp(timeR);
newnextshortsig = sig(800:1500);
for x=1:700
R1=max(newnextshortsig);
% x=x+1;
end    

[indexR1,locR1] =ismember(R1,newnextshortsig);
disp('R1 =');
disp(R1);
disp(locR1);
timeR1=(locR1/1000)-0.0010;
disp('Time for R1');
disp(timeR1);
ValueR= (1/(timeR1-timeR))*60;
disp(ValueR);