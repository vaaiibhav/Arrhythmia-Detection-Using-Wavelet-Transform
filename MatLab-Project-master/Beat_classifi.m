function [ RR_Category ] = Beat_classifi( R_R_Interval )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Arrhythmic beat classification
RR_Category = ones(length(R_R_Interval),1);
for i=2:length(R_R_Interval)-1 
    RR_Category(i) = 1;
    RR1 = R_R_Interval(i-1);
    RR2 = R_R_Interval(i);
    RR3 = R_R_Interval(i+1);
    
    %%Rule1 = VF Beat classification
    if RR2 < 0.6 && 1.8*RR2 < RR1;
        RR_Category(i) = 3;
            
        for k=i+1:length(R_R_Interval)-1
            RR1k = R_R_Interval(k-1);
            RR2k = R_R_Interval(k);
            RR3k = R_R_Interval(k+1);
            if (RR1k < 0.7 && RR2k < 0.7 && RR3k < 0.7)||...
                    (RR1k + RR2k + RR3k < 1.7)
                RR_Category(i) = 3; 
            %end
            else % Not arrhythm  
                if i > 4 && (RR_Category(i-4) == 1 && RR_Category(i-3) == 3 &&...
                    RR_Category(i-2) == 3 && RR_Category(i-1) == 3)
                    RR_Category(i-1) = 1;
                    RR_Category(i-2) = 1;
                    RR_Category(i-3) = 1; %Sequentially Cat3 less than 4--> Classified to Cat1 
           %{         
            RR_Cat3 = find (RR_Category = 3); 
                if RR_Cat3 < 4
                    RR_Category = 1;
                end
            %}
                end
            end
        end
    end

    %RULE2 = PVC
    
    if ((1.15*RR2 < RR1) && (1.15*RR2 < RR3)) ||...
            ((abs(RR1-RR2) < 0.3) && ((RR1 < 0.8) && (RR2 < 0.8)) && (RR3 > 1.2*((RR1+RR2)/2))) ||...
            ((abs(RR2-RR3) < 0.3) && ((RR2 < 0.8) && (RR3 < 0.8)) && (RR1 > 1.2*((RR1+RR2)/2)))
        %}
        RR_Category(i) = 2;
    end
    
        
    %RULE3 = 2degree heart block beats
    if (2.2 < RR2 && RR2 < 3.0) && (abs(RR1-RR2) < 0.2 || abs(RR2-RR3) < 0.2)
        RR_Category(i) = 4;
    end
    
end    

end

