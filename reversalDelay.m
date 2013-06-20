%analyzes the delay between reveresal initiations with respect to phase
%Konlin Shen
%6/19/13

function delayArray=reversalDelay(mcdf)

numFrames=length(mcdf);
velocity=getVelocity(mcdf);
delayArray=[];

for i=1:numFrames-1
    if(velocity(i)<0)
        time=0;
        tempFrames=i+1
        %look for last time DLP was on
        while mcdf(tempFrames).DLPisOn==0
            time=time+1;
            tempFrames=tempFrames-1;
            if(tempFrames==0)
                break;
            end
        end
        delayArray=[delayArray,time];
    end
end

hist(delayArray);
end