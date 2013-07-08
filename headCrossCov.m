%calculates the cross covariance of the ventral and dorsal muscles in the
%head
%Konlin Shen
%07/03/13

function [lags,correlationSequence]=headCrossCov(vbd,dbd)
timeLength=size(dbd,1);

for t=1:timeLength
    dArray(t)=mean(dbd(t,1:10));
    vArray(t)=mean(vbd(t,1:10));
end

[correlationSequence,lags]=xcov(dArray,vArray,'coeff');

figure;
subplot(2,1,1);
hold on;
plot(dArray);
plot(vArray,'r');
title('Ventral-Dorsal Avg Head Intensity');
xlabel('Time(Frames)');
hold off;

subplot(2,1,2);
plot(lags,correlationSequence);
title('Ventral-Dorsal Cross Correlation');
xlabel('Time(Seconds)');

end