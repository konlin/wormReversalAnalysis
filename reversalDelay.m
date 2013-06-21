%analyzes the delay between reveresal initiations with respect to phase
%Konlin Shen
%6/19/13

function delayArray=reversalDelay(mcdf)

numFrames=length(mcdf);
velocity=getVelocity(mcdf);
delayArray=[];
currentReversal=false;

for i=1:numFrames-1
    if(velocity(i)<0 && currentReversal==false)
        currentReversal=true;
        time=0;
        tempFrames=i+1;
        
        %find the first frame in which the DLP is on
        while (mcdf(tempFrames).DLPisOn+mcdf(tempFrames-1).DLPisOn)~=1
            time=time+1;
            tempFrames=tempFrames-1;
            if(tempFrames==0)
                break;
            end
        end
        delayArray=[delayArray,time];
    elseif velocity(i)>0
        currentReversal=false;
    end
end
% %normalize
% maxDelay=max(max(delayArray));
% normalizedDelayArray=delayArray/maxDelay;

figure;
hist(normalizedDelayArray,40);
end