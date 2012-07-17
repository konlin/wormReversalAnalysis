function vel=findWavePropagationSpeed(cleanedReversalArray,mcdf)
vel=[];
for i=1:length(cleanedReversalArray)
    firstframe=find([mcdf.FrameNumber]==cleanedReversalArray(i).WormVid(1).FrameNumber);
    lastframe=find([mcdf.FrameNumber]==cleanedReversalArray(i).WormVid(length(cleanedReversalArray(i).WormVid)).FrameNumber);
    vel=[vel,mean(getVelocity(mcdf(firstframe:lastframe)))];
end
end
