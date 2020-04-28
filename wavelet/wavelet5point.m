% File: wavdemo.m
% demonstrates various commands in the wavelet toolbox
clc;
clear all;
close all;
global e3;
% load sumsin
% x=sumsin;
load 100m;
me1=[0.85916,0.15893,0.85917,0.39038,69.916];
me2=[0.86125,0.14727,0.86018,0.446,69.781];
cov1=[0.0007067	-0.00080978	0.00070534	6.301e-005	-0.069454;
-0.00080978	0.013886	-0.00079216	-0.00031452	0.11299;
0.00070534	-0.00079216	0.00070404	6.2894e-005	-0.069259;
6.301e-005	-0.00031452	6.2894e-005	0.00031071	-0.007983;
-0.069454	0.11299	-0.069259	-0.007983	7.2403];
cov2=[0.00023458	-0.00062327	0.00013742	5.2401e-005	-0.013761;
-0.00062327	0.0082389	-0.00061148	-0.00056997	0.06373;
0.00013742	-0.00061148	0.00022262	0.000116	-0.020627;
5.2401e-005	-0.00056997	0.000116	0.038663	-0.010595;
-0.013761	0.06373	-0.020627	-0.010595	1.9439];
n=length(val);
n1=n/2;
e=mod(n,50);
w=(n-e)/50;
for i=1:n1;
    s(i)=(val(i));
end
%plot the original signal
aa=1:length(s);
q=length(val);
w=length(s);
figure;
plot(aa,s);
title('Signal');
[C,L] = wavedec(s,8,'db6');
A8 = wrcoef('a', C, L, 'db6', 8);
D8 = wrcoef('d', C, L, 'db6', 8);
D7 = wrcoef('d', C, L, 'db6', 7);
D6 = wrcoef('d', C, L, 'db6', 6);
D5 = wrcoef('d', C, L, 'db6', 5);
D4 = wrcoef('d', C, L, 'db6', 4);
D3 = wrcoef('d', C, L, 'db6', 3);
D2 = wrcoef('d', C, L, 'db6', 2);
A1 = wrcoef('a', C, L, 'db6', 1);
D1 = wrcoef('d', C, L, 'db6', 1);
z=D8+D7+D6+D5+D4+D3+D2+D1+A8;
a=[z' s'];
e1=D3+D4+D5; 
e2=D4.*(D3+D5)/(2^8); %R peak
E3=abs(e1.*e2); 
e11=abs(e1.*e1);%QRS complex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%R-peak
b=0;
j=1;
for i=1:length(e11)
    if e11(i)>0.1
        r(i)=1;
        b(j)=i;
        j=j+1;
    else
        r(i)=0;
    end
end
j=1;
k=1;
l=1;
for i=1:(length(b)-1)
        if (b(i+1)-b(i)<50)
            d(k)=s(b(i));
            k=k+1;
        else
            d(k)=s(b(i));
            [c,j]=max(d(1:k));
            r_max(l)=c;
            r_ind(l)=b(j);
            d=0;
            k=k+1;
            l=l+1;            
        end
end
d(k)=s(b(i+1));
[c,j]=max(d(1:k));
r_max(l)=c;
r_ind(l)=b(k);
rwave(length(s))=0;
for i=1:length(b)
    if(s(b(i))>0.1)
        rwave(b(i))=1;
    else
        rwave(b(i))=0;
    end
end
j=1;
r_peak(length(s))=0;
while(j<length(r_ind))
    for i=1:length(r)
        r_peak(r_ind(j))=1;
    end
    j=j+1;
end
figure
plot(1:length(s),s,'g',1:length(r_peak),r_peak,'r');
title('R-Peak');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Q-peak
e3=D2+D3+D4+D5;
for i=1:length(e3)
    e(i+3)=e3(i);
end
e(length(e):length(e)+2)=0;
for i=3:length(e3)
    f(i)=(-e(i+2)+8*(e(i+1))-8*(e(i-1))+e(i-2))/12;
end
f1=0;
for i=1:length(f)
    f1(i+25)=f(i);
end
for i=1:length(r_ind)
    j=r_ind(i)-5;
    y=-1;
    if(r_ind(i)>5)
    while(y<0)
        y=f1(j-1)-f1(j);
        j=j-1;
    end
    q_ind(i)=j;
    q_max(i)=s(j);
    q_peak(j)=-1;
    end
end
figure
plot(1:length(s),s,'g',1:length(q_peak),q_peak,'r');
title('Q-Peak');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%S-peak
for i=1:length(r_ind)
    j=r_ind(i)+5;
    y=-1;
    if(r_ind(i)>5)
    while(y<0)
        y=f(j)-f(j+1);
        j=j+1;
    end
    s_ind(i)=j+1;
    s_max(i)=s(j+1);
    end
end
for i=1:length(s_ind)
    if(s_ind(i)>20)
    [val ind]=min(s((s_ind(i)-20):(s_ind(i)+20)));
    s_ind(i)=ind+s_ind(i);
    s_max(i)=s(s_ind(i));
    s_peak(s_ind(i))=-1;
    else
    [val ind]=max(s(1:s_ind(i)+20));
    s_ind(i)=ind+s_ind(i);
    s_max(i)=s(ind+s_ind(i));
    s_peak(ind+s_ind(i))=-1;
    end
end
s(length(s)+1:length(s)+100)=0;
figure
plot(1:length(s),s,'g',1:length(s_peak),s_peak,'r');
title('S_peak');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T-peak
e4=D6+D7;
e4(length(e4):length(e4)+100)=0;
for i=1:length(s_ind)
    j=s_ind(i)+90;
    y=-1;
    while(y<0)
        y=e4(j)-e4(j+1);
        j=j+1;
    end
    t_ind(i)=j+1;
    t_max(i)=s(j+1);
end
for i=1:length(t_ind)
    if(t_ind(i)>20)
    [val ind]=max(s(t_ind(i)-20:t_ind(i)+20));
    t_ind(i)=ind+t_ind(i)-20;
    t_max(i)=s(ind+t_ind(i)-20);
    t_peak(ind+t_ind(i)-20)=-1;
    else
    [val ind]=max(s(1:t_ind(i)+20));
    t_ind(i)=ind+t_ind(i);
    t_max(i)=s(ind+t_ind(i));
    t_peak(ind+t_ind(i))=-1;
    end
end
figure;
plot(1:length(s),s,'g',1:length(t_peak),t_peak,'r');
title('T-peak');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%P-peak
for i=1:length(s_ind)
    j=q_ind(i)-5;
    y=-1;
    if(q_ind(i)>5)
    while(y<0 && (j-1)~=0)
        y=e4(j-1)-e4(j);
        j=j-1;
    end
    p_ind(i)=j+1;
    p_max(i)=s(j+1);
    end
end
for i=1:length(p_ind)
    if(p_ind(i)>20)
    [val ind]=max(s(p_ind(i)-20:p_ind(i)+20));
    p_ind(i)=ind+p_ind(i)-20;
    p_max(i)=s(ind+p_ind(i)-20);
    p_peak(ind+p_ind(i)-20)=-1;
    else
    [val ind]=max(s(1:p_ind(i)+20));
    p_ind(i)=ind+p_ind(i);
    p_max(i)=s(ind+p_ind(i));
    p_peak(ind+p_ind(i))=-1;
    end
end
figure;
plot(1:length(s),s,'g',1:length(p_peak),p_peak,'r');
title('P-Peak');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(s_ind)
    s_t_interval(i)=(t_ind(i)-s_ind(i))/360;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(r_ind)-1
    r_r_interval(i)=(r_ind(i+1)-r_ind(i))/360;
end
r_peaks_count=length(r_ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(t_ind)-1
    t_t_interval(i)=(t_ind(i+1)-t_ind(i))/360;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:(length(r_ind)-1)
    p_r_interval(i)=(r_ind(i+1)-p_ind(i))/360;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:min(length(q_ind),length(t_ind))
    q_t_interval(i)=(t_ind(i)-q_ind(i))/360;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(p_ind)-1
    p_p_interval(i)=(p_ind(i+1)-p_ind(i))/360;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
consolidated=[mean(p_p_interval),mean(p_r_interval),mean(r_r_interval),mean(q_t_interval),mean(r_peaks_count)*2];
a=me1';
 b=me2';
 x=consolidated';
  m1 = 1/sqrt((2*pi)^2*det(cov1)) * exp(-((x-a)'*inv(cov1)*(x-a))/2); % Compute likelihood
  m2 = 1/sqrt((2*pi)^2*det(cov2)) * exp(-((x-b)'*inv(cov2)*(x-b))/2); % Compute likelihood
   Px1=1/2;
   Px2=1/2;
      m=[m1 m2]*1/2;
      Po=(m/sum(m));
[value class]=max(Po);
if class==1
    disp('normal')
else
    disp('abnormal')
end