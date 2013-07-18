%calculates the cross covariance of the ventral and dorsal muscles in the
%head
%Konlin Shen
%07/03/13

function [lags,correlationSequence]=headCrossCov(vbd,dbd,reversalStart)
timeLength=size(dbd,1);

for t=1:timeLength
    dArray(t)=mean(dbd(t,1:10));
    vArray(t)=mean(vbd(t,1:10));
end

figure;
subplot(2,1,1);
hold on;
title('Ventral-Dorsal Avg Head Intensity');
xlabel('Time(Frames)');
plot(dArray,'k--');
plot(vArray,'k--');

if timeLength-reversalStart < 20
    [correlationSequence,lags]=xcov(dArray(reversalStart:timeLength)...
        ,vArray(reversalStart:timeLength),'coeff');
    plot(reversalStart:timeLength,dArray(reversalStart:timeLength),'b');
    plot(reversalStart:timeLength,vArray(reversalStart:timeLength),'r');
else
    [correlationSequence,lags]=xcov(dArray(reversalStart:reversalStart+20)...
        ,vArray(reversalStart:reversalStart+20),'coeff');
    plot(reversalStart:reversalStart+20,dArray(reversalStart:reversalStart+20),'b');
    plot(reversalStart:reversalStart+20,vArray(reversalStart:reversalStart+20),'r');
end

hold off;

subplot(2,1,2);
plot(lags,correlationSequence);
title('Ventral-Dorsal Cross Correlation');
xlabel('Time(Seconds)');

end