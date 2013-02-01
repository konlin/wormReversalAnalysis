%reversalTimeAverager takes any number of cleanedReversalArrays
%then averages the reversal duration over all of them
%by Konlin Shen
%2/1/13
function averageTime=reversalTimeAverager(varargin)
len=length(varargin);
totalTime=0;
totalReversals=0;
for i=1:len
  arrayLen=length(varargin{i});
  for j=1:arrayLen
    totalTime=totalTime + varargin{i}(j).timeDuration;
  end
  totalReversals=totalReversals+arrayLen;
end
averageTime=totalTime./totalReversals;
end
