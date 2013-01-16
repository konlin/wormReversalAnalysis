%findDLPisOnFrames takes an Mcd_Frame array and returns the first frame of
%each laserOn event
%Made by Konlin Shen (1/16/13)
function firstFrames=findDLPisOnFrames(mcdf)
firstFrames=[];
allframes=find([mcdf.DLPisOn]==1);
arrayLen=length(allframes);
firstFrames=[firstFrames,allframes(1)];
for i=2:arrayLen
  if(allframes(i)-allframes(i-1) > 1)
      firstFrames=[firstFrames,allframes(i)];
  end
end
end