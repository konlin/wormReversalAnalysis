function phaseArray=plotPhase(mcdf, options)
numFrames=length(mcdf);
velocity=getVelocity(mcdf);
startReversalIndex = 0;
endReversalIndex = 100000000000;
for k=1:numFrames
    c=generateCurvature(mcdf(k));
    x=createSineFit2(c, options);
    amplitudeArray(k)=x(1);
    frequencyArray(k)=x(2);
    phaseArray(k)= x(3);
    if(startReversalIndex == 0 && k > 2 && velocity(k-2) > 0 && velocity(k-1) < 0)
        if(k-1 < endReversalIndex)
            startReversalIndex = k-1
        end
    end
    if(endReversalIndex == 100000000000 && k > 2 && velocity(k-2) < 0 && velocity(k-1) > 0)
        if(k > startReversalIndex)
            endReversalIndex = k-1
        end
    end
end
unwrappedPhaseArray = unwrap(phaseArray);
startReversalIndex
endReversalIndex
startCurvature = generateCurvature(mcdf(startReversalIndex));
firstCurv = startCurvature(19)
startPhase = phaseArray(startReversalIndex)
phaseDifference = unwrappedPhaseArray(endReversalIndex) - unwrappedPhaseArray(startReversalIndex)
phaseDifferenceInPi = phaseDifference/pi
figure;
hold on;
ax2(1) = subplot(5,1,1);
xaxis=[mcdf.FrameNumber];
plot(xaxis, amplitudeArray, 'Parent', ax2(1));
title('Amplitude x Frame');

ax2(2) = subplot(5,1,2);
plot(xaxis, frequencyArray, 'Parent', ax2(2));
title('Frequency x Frame');

ax2(3) = subplot(5,1,3);
plot(xaxis, phaseArray, 'Parent', ax2(3));
title('Phase x Frame');

ax2(4) = subplot(5,1,4);
plot(xaxis, unwrappedPhaseArray, 'Parent', ax2(4));
title('Unwrapped Phase x Frame');

ax2(5) = subplot(5,1,5);
plot(xaxis(1:end-1) ,getVelocity(mcdf), 'Parent', ax2(5));
hold on
plot(mcdf(startReversalIndex).FrameNumber, velocity(startReversalIndex), 'r');
plot(mcdf(endReversalIndex).FrameNumber, velocity(endReversalIndex), 'r');
title('Velocity x Frame');
linkaxes(ax2,'x');

end
