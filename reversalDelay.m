%analyzes the delay between reveresal initiations with respect to phase
%Konlin Shen
%6/19/13

function reversalDelay(mcdf)
numFrames=length(mcdf);
velocity=getVelocity(mcdf);

for i=1:numFrames-1
    if(velocity(i)<0)
        time=0;
        tempFrames=numFrames;
        %look for last time DLP was on
        while(mcdf(tempFrames+1).DLPisOn==0)
            time=time+1;
            tempFrames=tempFrames-1;
        end
    end
end


end