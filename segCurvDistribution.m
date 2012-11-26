%SegCurvDistributioni takes a cleanedReversal Array and for each reversal
%calculates the CHANGE in curvature of each segment between the time the 
%worm stops moving (frame 1) and starts reversing (frame 2) and plots it
%in a histogram
%by Konlin Shen (modified 11/16/12)

function [d1array,d2array,d3array,d4array,d5array]=segCurvDistribution(cleanedReversalArray)
d1array=[];
d2array=[];
d3array=[];
d4array=[];
d5array=[];
for index=1:length(cleanedReversalArray)
    %take the first frame of the reversal (stopped)
    mcdf1=cleanedReversalArray(index).WormVid(1);
    %takes the second frame of the reversal (reversing)
    mcdf2=cleanedReversalArray(index).WormVid(2);
    curv1=generateCurvature(mcdf1);
    curv2=generateCurvature(mcdf2);
    c=[curv1;curv2];
    dcurv=diff(c);
    
    d1=smooth(mean(dcurv(1:20)));
    d2=smooth(mean(dcurv(21:40)));
    d3=smooth(mean(dcurv(41:60)));
    d4=smooth(mean(dcurv(61:80)));
    d5=smooth(mean(dcurv(81:100)));
    
    d1array=[d1array,d1];
    d2array=[d2array,d2];
    d3array=[d3array,d3];
    d4array=[d4array,d4];
    d5array=[d5array,d5];
    
end

d1array=diff(d1array)
d2array=diff(d2array)
d3array=diff(d3array)
d4array=diff(d4array)
d5array=diff(d5array)

figure;
subplot(2,3,1);
hist(d1array,5);
title('Change in Curvature for Segment 1')
subplot(2,3,2);
hist(d2array,5);
title('Change in Curvature for Segment 2')
subplot(2,3,3);
hist(d3array,5);
title('Change in Curvature for Segment 3')
subplot(2,3,4);
hist(d4array,5);
title('Change in Curvature for Segment 4')
subplot(2,3,5);
hist(d5array,5);
title('Change in Curvature for Segment 5')

end
    
    
    
    
