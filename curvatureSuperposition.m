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
    
    %calculate average curvature per segment
    seg1=mean(curvature(1:20));
    seg2=mean(curvature(21:40));
    seg3=mean(curvature(41:60));
    seg4=mean(curvature(61:80));
    seg5=mean(curvature(81:100));
    
    %collect the average curvatures
    segArrays(1,i)=seg1;
    segArrays(2,i)=seg2;
    segArrays(3,i)=seg3;
    segArrays(4,i)=seg4;
    segArrays(5,i)=seg5;
    
    plot(curvature);
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