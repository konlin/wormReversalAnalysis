%calculates the cross correlation of the ventral and dorsal muscles
%Konlin Shen
%06/11/13

function segmentCorrelationCell=calciumImagingCrossCorr(vbd,dbd)
segmentCorrelationCell=cell(5);
fps=10;
timeLength=size(dbd,1);

for t=1:timeLength
    for i=1:5    
        dSegArray(t,i)=mean(dbd(t,(i-1)*20+1:i*20));
        vSegArray(t,i)=mean(vbd(t,(i-1)*20+1:i*20));
    end
end

for seg=1:5
    [correlationSequence,lags]=xcov(dSegArray(:,seg),vSegArray(:,seg),60,'coeff');
    segmentCorrelationCell{seg}=correlationSequence;
    figure;
    subplot(2,1,1);
    hold on;
    plot(dSegArray(:,seg));
    plot(vSegArray(:,seg),'r');
    titlestr=sprintf('Ventral and Dorsal Avg Segment Intensity for Segment %d', seg);
    title(titlestr);
    xlabel('Time(frames)');
    hold off;
    
    subplot(2,1,2);
    plot(lags, correlationSequence);
    str=sprintf('Ventral Dorsal Cross Correlation for Segment %d',seg);
    title(str);
    xlabel('Time(seconds)');
end
end