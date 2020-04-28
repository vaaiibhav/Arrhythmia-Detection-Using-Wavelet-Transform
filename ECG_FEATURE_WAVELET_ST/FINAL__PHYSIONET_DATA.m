 % Load original 1D signal.
clc;
clear all;
close all;
ELEVATED=[]
[fname path]=uigetfile('*.mat');
fname=strcat(path,fname);

        load(fname );
       z=zeros(100,1);
       
       A=val(1,:);
       v1=val(1,:)-val(1,1);
       A=v1;
       A=A';
       zc=A(1);
       A=[z;A;z];
       
       
      %  s = A(1:1:400);
        s = A;
        
        ls = length(s);
        figure(1)
        plot(s);
        title('Actual Signal'),grid on

  [c,l]=wavedec(s,4,'db4');
  ca1=appcoef(c,l,'db4',1);
  ca2=appcoef(c,l,'db4',2);
  ca3=appcoef(c,l,'db4',3);
  ca4=appcoef(c,l,'db4',4);
  
  figure(2)
  plot(c),title('decomposed signal'),grid on
  figure(3)
  subplot(2,2,1)
  plot(ca1),title('1st level reconstructed'),grid on
    subplot(2,2,2)
  plot(ca2),title('2nd level reconstructed'),grid on
    subplot(2,2,3)
  plot(ca3),title('3rd level reconstructed'),grid on
    subplot(2,2,4)
  plot(ca4),title('4th level reconstructed'),grid on
  
  

  

  
  %% ZERO CROSSING REMOVAL%%%%%%
  base_corrected=ca2;
  y=base_corrected-zc;
  figure(4)
  plot(y),grid on
  title('base line corrected and smoothed signal')
  
  
  %% DETECT R_PEAK
y1=y
m1=max(y1)-max(y1)*.60;
P=find(y1>=m1);
% it will give two two points ... remove one point each
P1=P;
P2=[];
last=P1(1);
P2=[P2 last];
for(i=2:1:length(P1))
    if(P1(i)>(last+10))
        last=P1(i);
        P2=[P2 last];
    end
end
Rt=y1(P2);
figure(5)
plot(y1),grid on,hold on
plot(P2,Rt,'*');
%% Calculate R in the actual Signal
P3=P2*4;
Rloc=[];
for( i=1:1:length(P3))
    range= [P3(i)-20:P3(i)+20]
    m=max(A(range));
    l=find(A(range)==m);
    pos=range(l);
    Rloc=[Rloc pos];
end
Ramp=A(Rloc);
figure(6)
plot(A),grid on,hold on
plot(Rloc,Ramp,'*');
title('Detected R peak in actual Signal')

%% After R Peak Tracking ... DETCET OTHERS
X=Rloc;
y1=A;
for(i=1:1:1)


for(j=1:1:length(X))
    a=X(j)-100:X(j)-50;
    m=max(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    %%% ONSET
    fnd=0;
for k=b-20:+1:b
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b-20:+1:b;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
RON(i,j)=qon1(1);
fnd
for k=b:+1:b+20
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b:+1:b+20;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
ROF(i,j)=qon1(1);
 %% P Peak
    try
        
    a=Rloc(i,j)-100:Rloc(i,j)-10;
    m=max(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Ploc(i,j)=b;
    Pamp(i,j)=m;
        
    end

    %% Q  Detection
    a=Rloc(i,j)-50:Rloc(i,j)-10;
    m=min(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Qloc(i,j)=b;
    Qamp(i,j)=m;
    %%%%% ONSET
    fnd=0;
for k=b-20:+1:b
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b-20:+1:b;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
QON(i,j)=qon1(1);
fnd
for k=b:+1:b+20
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b:+1:b+20;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
QOF(i,j)=qon1(1);
    
    %% S  Detection
    a=Rloc(i,j)+5:Rloc(i,j)+50;
    m=min(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Sloc(i,j)=b;
    Samp(i,j)=m;
    %%%% onset off
    fnd=0;
for k=b-5:+1:b
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b-20:+1:b;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
SON(i,j)=qon1(1);
fnd=0;
for k=b:+1:b+20
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b:+1:b+20;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
SOFF(i,j)=qon1(1);
    
    
   
    
    %% T Peak
    a=Rloc(i,j)+25:Rloc(i,j)+100;
    m=max(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Tloc(i,j)=b;
    Tamp(i,j)=m;
     %%%% onset off
    fnd=0;
for k=b-20:+1:b
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b-20:+1:b;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
TON(j,i)=qon1(1);
fnd=0;
for k=b:+1:b+20
    if((y1(k)<=0) && (y1(k-1)>0))
        qon1=k;
        fnd=1;
      break 
  end
end
if(fnd==0)
Qrange=b:+1:b+20;
qon1=find(y1(Qrange)==max(y1(Qrange)));
qon1=Qrange(qon1);
end
TOFF(j,i)=qon1(1);   

    if(Tamp(i,j)<Pamp(i,j))
        a=Rloc(i,j)+25:Rloc(i,j)+70;
    m=min(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Tloc(i,j)=b;
    Tamp(i,j)=m;
    ELEVATED=[ELEVATED j];
    
    end
    %% END OF T
end
end
figure;
k=1;
for(i=1:1:1)
    %subplot(6,1,k);
    
    plot(y1), hold on;
    plot(Rloc(i,:),Ramp(i,:),'*'),hold on;
    plot(Qloc(i,:),Qamp(i,:),'+'),hold on;
    plot(Sloc(i,:),Samp(i,:),'+'),hold on;
    plot(Ploc(i,:),Pamp(i,:),'.'), hold on
    plot(Tloc(i,:),Tamp(i,:),'^')
    grid on;
    k=k+1;
    if(k>6)
        k=1;
        figure;
    end
end


clc;
flag=0;
if(length(ELEVATED)>ceil(.8*length(Rloc)))
    disp('T inverted (MI Detected) with T inverted Logic')
    return;
else
    
    flag=1;
end

%% CASE OF ST SEGMENT ELEVATION
x=A;
TOFF=TOFF';
TON=TON';
for(i=1:1:1)
   
 for(j=1:1:length(Rloc(i,:))   )
PRpoint(i,j)= ceil(Rloc(i,j)-(SOFF(i,j)-QON(i,j))/2);
STpoint(i,j)=ceil(Tloc(i,j)-(TOFF(i,j)-TON(i,j))/2);
STDeviation(i,j)=abs(x(PRpoint(i,j),i)-x(STpoint(i,j),i));
 end
end
x=STDeviation/100;
x=mean(x);
if(x>1)
    disp('MI Detected')
else
    disp('Normal Signal')
end