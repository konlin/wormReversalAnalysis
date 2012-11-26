%segCurvDist2 takes a cleanedReversalArray and for each reversal
%collects the curvature of each segment.  segCurvDist2 then plots the
%distribution of segment curvatures for each segment

function segCurvDistribution(cleanedReversalArray)
s1array=[];
s2array=[];
s3array=[];
s4array=[];
s5array=[];

for index=1:length(cleanedReversalArray)
    mcdf=cleanedReversalArray(index).WormVid(1);
    c=generateCurvature(mcdf);
    
    s1curv=smooth(mean(c(1:20)));
    s2curv=smooth(mean(c(21:40)));
    s3curv=smooth(mean(c(41:60)));
    s4curv=smooth(mean(c(61:80)));
    s5curv=smooth(mean(c(81:100)));
    
    s1array=[s1array,s1curv];
    s2array=[s2array,s2curv];
    s3array=[s3array,s3curv];
    s4array=[s4array,s4curv];
    s5array=[s5array,s5curv];
end

figure;hist(s1array,20);title('Seg 1 Curvature Distribution');
figure;hist(s2array,20);title('Seg 2 Curvature Distribution');
figure;hist(s3array,20);title('Seg 3 Curvature Distribution');
figure;hist(s4array,20);title('Seg 4 Curvature Distribution');
figure;hist(s5array,20);title('Seg 5 Curvature Distribution');

end

    
    