%calculates the cross correlation of the ventral and dorsal muscles
%Konlin Shen
%06/11/13

function segmentCorrelationCell=calciumImagingCrossCorr(dbd,vbd)
segmentCorrelationCell=cell(5);

timeLength=size(dbd,1);

for t=1:timeLength
    for i=1:5    
        dSegArray(t,i)=mean(dbd(t,(i-1)*20+1:i*20));
        vSegArray(t,i)=mean(vbd(t,(i-1)*20+1:i*20));
    end
end

for seg=1:5
    segmentCorrelationCell{seg}=xcorr(dSegArray(:,seg),vSegArray(:,seg));
    figure;
    plot(segmentCorrelationCell{seg});
    str=sprintf('Ventral Dorsal Cross Correlation for Segment %d',seg);
    title(str);
    xlabel('Time (frames)');
end
end
