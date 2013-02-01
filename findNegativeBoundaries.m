function [start,last]=findNegativeBoundaries(list)
start=0;
last=0;
n=length(list);
t1=list(1:n-1); %run through the list from the first to second to last element
t2=list(2:n); %run through the list from the second element to the last element
prod=t1.*t2; %multiply consecutive elements together
dlist=diff(list); %take the derivative
dn=length(dlist);
dt1=dlist(1:dn-1);
dt2=dlist(2:dn);
dprod=dt1.* dt2; %multiply consecutive derivative elements together

%finds the first frame where the worm starts reversing
count=0;
for i=1:dn-1
    prod(i)
    if(dprod(i)<0 && prod(i)>0.02)%If the worm changes direction with a velocity above a certain value
        disp('Found reversal');
        ind=i;
        break; %when you find the reversal, stop searching!
    end
    count=count+1;
end

if(count==dn-1)
    disp('Throwing exception');
    throw(exception);
end


startInd=ind-1;
%find the first frame to analyze
while(start==0)
    if(startInd==1||prod(startInd)<0)
        start=startInd;
    end
    startInd=startInd-1;
end
lastInd=ind+1;
%find the last frame to analyze
while(last==0)
    try
        if(lastInd==length(prod)||prod(lastInd)<0)
            last=lastInd;
        end
    catch exception
        last=length(prod);
    end
    lastInd=lastInd+1;
end
end