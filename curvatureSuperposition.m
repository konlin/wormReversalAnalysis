%superimposes all of the curvatures on top of each other
%Konlin Shen
%6/4/13

function curvatureSuperposition(cra)
size=length(cra);
segArrays=zeros(5,size);
figure;
hold all;

for i=1:size
    frame=cra(i).WormVid(1);
    curvature=generateCurvature(frame);
    
    plotFlag=true;
    
    for j=1:5
        %calculate average curvature for each segment
        segMax=max(abs(curvature((j-1)*10+1:j*20)));
        if(segMax<10)
            %collect the average curvatures
            seg=mean(curvature((j-1)*10+1:j*20));
            segArrays(j,i)=seg;
        else
            plotFlag=false;
            break;
        end
    end
    
    if(plotFlag==true)
        plot(curvature);
    end
end
title('Superposition of Worm Curvatures Prior to Reversing');

%plot histograms for all the segments
figure;
for segIndex=1:5
    subplot(3,2,segIndex);
    hist(segArrays(segIndex,:),30);
    titleStr=sprintf('Histogram of Average Curvature for Segment %d',segIndex);
    title(titleStr);
end

end