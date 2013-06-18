% overlap histogram
% Konlin Shen
% 6/18/13

function overlapHistogram(intensityCell)
%get the length of the arrays
len=size(intensityCell,1);

overlapHist=zeros(1,100);

%make a for loop to run through all the reversals
for i=1:len
    vbd=intensityCell{i}{1};
    dbd=intensityCell{i}{2};
    %normalize the intensity data
    normalizedVBD=vbd/max(max(vbd));
    normalizedDBD=dbd/max(max(dbd));
    %look for regions where the intensity is above a certain threshold
    time=size(normalizedVBD,1);
    for t=1:time
        for s=1:100
            if(normalizedVBD(t,s)>0.5 && normalizedDBD(t,s)>0.5)
                overlapHist(s)=overlapHist(s)+1;
            end
        end
    end
end
figure;
hist(overlapHist);
end