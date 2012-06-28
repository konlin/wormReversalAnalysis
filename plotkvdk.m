function plotkvdk(cleanedReversalArray,mcdf)

%maxs1curvature=[];
s2curvature=[];
s3curvature=[];
s4curvature=[];
s5curvature=[];

seg3freq=0;
seg4freq=0;
seg5freq=0;


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
    
    [~,maxd2index]=max(diffSeg2(30:90));
    [~,maxd3index]=max(diffSeg3(30:90));
    [~,maxd4index]=max(diffSeg4(30:90));
    [~,maxd5index]=max(diffSeg5(30:90));
    
    [minIndex,segment]=min([maxd3index,maxd4index,maxd5index]);

    if(segment==1)
        seg3freq=seg3freq+1;
    elseif(segment==2)
        seg4freq=seg4freq+1;
    elseif(segment==3)
        seg5freq=seg5freq+1;
    end
    
    smallestIndex=minIndex+30;
    lastCurvIndex=smallestIndex+15;
    
    d2=[d2,max(s2array(30:lastCurvIndex))-s2array(30)];
    d3=[d3,max(s3array(30:lastCurvIndex))-s3array(30)];
    d4=[d4,max(s4array(30:lastCurvIndex))-s4array(30)];
    d5=[d5,max(s5array(30:lastCurvIndex))-s5array(30)];
    
    s2curvature=[s2curvature,s2array(30)];
    s3curvature=[s3curvature,s3array(30)];
    s4curvature=[s4curvature,s4array(30)];
    s5curvature=[s5curvature,s5array(30)];
  
end

figure;
hold on;
%plot(abs(s2curvature),d2,'.b');
plot(abs(s3curvature),d3,'.g');
plot(abs(s4curvature),d4,'.c');
plot(abs(s5curvature),d5,'.m');
[~,pval3]=corrcoef(abs(s3curvature)',d3')
[~,pval4]=corrcoef(abs(s4curvature)',d4')
[~,pval5]=corrcoef(abs(s5curvature)',d5')
xlabel('curvature');
ylabel('change in curvature');
legend('seg 3','seg 4', 'seg 5');

figure;
hold on;
bar([seg3freq,seg4freq,seg5freq]);
end
