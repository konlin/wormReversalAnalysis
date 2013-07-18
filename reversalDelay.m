%analyzes the delay between reversal initiations with respect to phase
%Konlin Shen
%6/19/13

function [cra,delayArray]=reversalDelay(mcdf)

numFrames=length(mcdf);
options=optimset('MaxFunEvals', 100000, 'MaxIter', 100000);
reversalArray=findReversals(mcdf, options);
cra=cleanReversalData(reversalArray);

numReversals=length(cra);
velocity=getVelocity(mcdf);
for i=1:length(mcdf)
    DLParray(i)=mcdf(i).DLPisOn;
end

delayArray=[];

for i=1:numReversals
    currentReversal=cra(i);
    firstFrame=find([mcdf.FrameNumber]==currentReversal.WormVid(1).FrameNumber);
    searchIndex=firstFrame-1;
    time=0;
    while(searchIndex~=1)
      if(mcdf(searchIndex).DLPisOn+mcdf(searchIndex-1).DLPisOn~=1)
          searchIndex=searchIndex-1;
          time=time+1;
      else
          break;
      end
    end
    

    delayArray=[delayArray,time];
end
% %normalize
% maxDelay=max(max(delayArray));
% normalizedDelayArray=delayArray/maxDelay;

figure;
hist(delayArray,40);
end