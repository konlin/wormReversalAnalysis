function plotkvdk(cleanedReversalArray,mcdf)



%maxs1curvature=[];
s2curvature=[];
s3curvature=[];
s4curvature=[];
s5curvature=[];

d2=[];
d3=[];
d4=[];
d5=[];

for k=1:length(cleanedReversalArray)
%s1array=[];
s2array=[];
s3array=[];
s4array=[];
s5array=[];
    firstframe=find([mcdf.FrameNumber]==cleanedReversalArray(k).WormVid(1).FrameNumber);
    if firstframe > 30
        startframe=firstframe-30;
    else
        startframe=firstframe;
    end

    if firstframe+60 < length(mcdf)
        endframe=firstframe+60;
    else
        endframe=length(mcdf);
    end

    frames=mcdf(startframe:endframe);
    for m=1:length(frames)
        curvature=generateCurvature(frames(m));
        s1=curvature(1:20);
        s2=curvature(21:40);
        s3=curvature(41:60);
        s4=curvature(61:80);
        s5=curvature(81:100);

        %s1array=[s1array,mean(s1)];
        s2array=[s2array,mean(s2)];
        s3array=[s3array,mean(s3)];
        s4array=[s4array,mean(s4)];
        s5array=[s5array,mean(s5)];
    end

    %s1array=smooth(s1array);
    s2array=smooth(s2array);
    s3array=smooth(s3array);
    s4array=smooth(s4array);
    s5array=smooth(s5array);

    %diffSeg1=smooth(diff(s1array));
    diffSeg2=smooth(diff(s2array),2);
    diffSeg3=smooth(diff(s3array),2);
    diffSeg4=smooth(diff(s4array),2);
    diffSeg5=smooth(diff(s5array),2);
    
    s2curvature=[s2curvature,s2array(30)];
    s3curvature=[s3curvature,s3array(30)];
    s4curvature=[s4curvature,s4array(30)];
    s5curvature=[s5curvature,s5array(30)];
    
    d2=[d2,abs(mean(diffSeg2(29:44)))];
    d3=[d3,abs(mean(diffSeg3(29:44)))];
    d4=[d4,abs(mean(diffSeg4(29:44)))];
    d5=[d5,abs(mean(diffSeg5(29:44)))];

end

figure;
hold on;
%plot(abs(s2curvature),d2,'.b');
plot(abs(s3curvature),d3,'.g');
plot(abs(s4curvature),d4,'.c');
plot(abs(s5curvature),d5,'.m');
xlabel('curvature');
ylabel('change in curvature');
legend('seg 3','seg 4', 'seg 5');

end
