function [d1array,d2array,d3array,d4array,d5array]=segCurvDistribution(cleanedReversalArray)
d1array=[];
d2array=[];
d3array=[];
d4array=[];
d5array=[];
for index=1:length(cleanedReversalArray)
    mcdf1=cleanedReversalArray(index).WormVid(1);
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
    
    
    
    
