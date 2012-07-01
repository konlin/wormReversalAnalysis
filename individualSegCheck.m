function individualSegCheck(WormReverse,mcdf)

s1array=[];
s2array=[];
s3array=[];
s4array=[];
s5array=[];

firstframe=find([mcdf.FrameNumber]==WormReverse.WormVid(1).FrameNumber);
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
    diffSeg2=smooth(diff(s2array),3);
    diffSeg3=smooth(diff(s3array),3);
    diffSeg4=smooth(diff(s4array),3);
    diffSeg5=smooth(diff(s5array),3);
    
    %[~,maxd2index]=max(abs(diffSeg2(30:90)));
    [~,maxd3index]=max(abs(diffSeg3(30:80)));
    [~,maxd4index]=max(abs(diffSeg4(30:80)));
    [~,maxd5index]=max(abs(diffSeg5(30:80)));
    
    [minIndex,segment]=min([maxd3index,maxd4index,maxd5index]);
    
     minIndex=minIndex+30;
    
    %d2=[d2,max(s2array(30:lastCurvIndex))-s2array(30)];
    d3=abs(s3array(minIndex)-s3array(30));
    d4=abs(s4array(minIndex)-s4array(30));
    d5=abs(s5array(minIndex)-s5array(30));
    
    figure;
    hold on;
    %plot(abs(s2curvature),d2,'.b');
    plot(abs(s3array(30)),d3,'.g');
    plot(abs(s4array(30)),d4,'.c');
    plot(abs(s5array(30)),d5,'.m');
%     [~,pval3]=corrcoef(abs(s3curvature)',d3')
%     [~,pval4]=corrcoef(abs(s4curvature)',d4')
%     [~,pval5]=corrcoef(abs(s5curvature)',d5')
    xlabel('curvature');
    ylabel('change in curvature');
    legend('seg 3','seg 4', 'seg 5');
end
