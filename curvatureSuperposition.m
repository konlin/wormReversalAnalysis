%superimposes all of the curvatures on top of each other
%Konlin Shen
%6/4/13

function [segArrays,curvatures,peaknumbers]=curvatureSuperposition(cra)
craSize=length(cra);
segArrays=zeros(5,craSize);
curvatures=[];
peaknumbers=[];
onepeakcurvatures=[];
twopeakcurvatures=[];
threepeakcurvatures=[];
fourpeakcurvatures=[];
fivepeakcurvatures=[];
sixpeakcurvatures=[];
sevenpeakcurvatures=[];
figure;
hold all;

for i=1:craSize
    frame=cra(i).WormVid(1);
    curvature=generateCurvature(frame);
    
    plotFlag=true;
    
    if((curvature(5)-curvature(10))/(5-10)<0)
        curvature=-1*curvature;
    end
    
    for j=1:5
        %calculate average curvature for each segment
        segMax=max(abs(curvature((j-1)*10+1:j*20)));
        
        %filter out curvatures which make no sense
        if(segMax<2*pi)
            %collect the average curvatures
            seg=mean(curvature((j-1)*10+1:j*20));
            segArrays(j,i)=seg;
        else
            plotFlag=false;
            break;
        end
    end
    
    if(plotFlag==true)
        temppeak=findpeaks(abs(curvature));
        peaknumbers=[peaknumbers,length(temppeak)];
        curvatures=[curvatures; curvature'];
        
        switch length(temppeak)
            case 1
                onepeakcurvatures=[onepeakcurvatures; curvature'];
            case 2
                twopeakcurvatures=[twopeakcurvatures; curvature'];
            case 3
                threepeakcurvatures=[threepeakcurvatures; curvature'];
            case 4
                fourpeakcurvatures=[fourpeakcurvatures; curvature'];
            case 5
                fivepeakcurvatures=[fivepeakcurvatures; curvature'];
            case 6
                sixpeakcurvatures=[sixpeakcurvatures; curvature'];
            case 7
                sevenpeakcurvatures=[sevenpeakcurvatures; curvature'];                
        end
        
        plot(curvature);
    end
end
title('Superposition of Worm Curvatures Prior to Reversing');

averageCurvature=mean(curvatures);
plot(averageCurvature,'LineWidth',4,'color','r');

%plot histograms for all the segments
figure;
for segIndex=1:5
    subplot(3,2,segIndex);
    hist(segArrays(segIndex,:),30);
    titleStr=sprintf('Histogram of Average Curvature for Segment %d',segIndex);
    title(titleStr);
end

%plot histogram for peak number
figure;
hist(peaknumbers);
title('histogram of maxes/mins');

%plot curvature superpositions for various postures:
figure;
hold on;
for k=1:size(onepeakcurvatures,1)
    plot(1:100, onepeakcurvatures(k,:));
end
title('One Peak Curvature Superposition');

figure;
hold on;
for k=1:size(twopeakcurvatures,1)
    plot(1:100, twopeakcurvatures(k,:));
end
title('Two Peak Curvature Superposition');

figure;
hold on;
for k=1:size(threepeakcurvatures,1)
    plot(1:100, threepeakcurvatures(k,:));
end
title('Three Peak Curvature Superposition');

figure;
hold on;
for k=1:size(fourpeakcurvatures,1)
    plot(1:100, fourpeakcurvatures(k,:));
end
title('Four Peak Curvature Superposition');

figure;
hold on;
for k=1:size(fivepeakcurvatures,1)
    plot(1:100, fivepeakcurvatures(k,:));
end
title('Five Peak Curvature Superposition');

figure;
hold on;
for k=1:size(sixpeakcurvatures,1)
    plot(1:100, sixpeakcurvatures(k,:));
end
title('Six Peak Curvature Superposition');

figure;
hold on;
for k=1:size(sevenpeakcurvatures,1)
    plot(1:100, sevenpeakcurvatures(k,:));
end
title('Seven Peak Curvature Superposition');

end