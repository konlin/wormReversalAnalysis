function reversalList=findReversals(mcdf)
options = optimset('MaxFunEvals', 100000, 'MaxIter', 100000);
numFrames=length(mcdf);
velocity=getVelocity(mcdf);
startReversalIndex=0;
endReversalIndex=0;
reversal=false;
j=1;
for k=1:numFrames-1
    if(~reversal && velocity(k)<0)
        disp('found start of reversal');
        startReversalIndex=k;
        reversal=true;
    end
    if(reversal && velocity(k)>0)
        disp('found end of reversal');
        endReversalIndex=k;
        reversal=false;
        reversalList(j)=wormReverse(startReversalIndex, endReversalIndex, mcdf,...
            options,endReversalIndex-startReversalIndex)
        j=j+1;
    end
end
end
    
        
        
    