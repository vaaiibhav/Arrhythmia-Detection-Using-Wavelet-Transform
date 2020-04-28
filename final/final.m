close all;
clear all;
load('ECG.mat');
[R_i,R_amp,S_i,S_amp,T_i,T_amp]=peakdetect(EKG1,250,10);
