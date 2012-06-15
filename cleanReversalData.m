function cleanedReversalArray = cleanReversalData(reversalArray)
%cleans up reversal data from findReversals by applying the following:
% 1. round phase shifts within .15 of an integer to an integer(NO LONGER)
% removes reversal data if head jumps more than 60 pixels

num = numel(reversalArray);
count = 1;
for k=1:num
    numframes=numel(reversalArray(k).WormVid);
    for l=1:numframes-1
        head = reversalArray(k).WormVid(l).Head;
        nexthead = reversalArray(k).WormVid(l+1).Head;
        distance = sqrt((head(1)-nexthead(1))^2 + (head(2)-nexthead(2))^2);
        if(distance > 60)
            disp('Filtering Reversal');
            break;
        end
        if(l==numframes-1)
            cleanedReversalArray(count)=reversalArray(k);
            count=count+1;
        end
    end
end
%for k=1:num
%    phaseShift = reversalArray(k).phaseChangePi;
%    if(abs(round(phaseShift)-phaseShift)<.15)
%        cleanedReversalArray(k)=round(phaseShift);
%    else
%        cleanedReversalArray(k)=phaseShift;
%    end
%end

%cleanedReversalArray(cleanedReversalArray==0) = [];
