function plotKDist(wormReverseArray, binsize)
k3=[];
k4=[];
k5=[];

for i=1:length(wormReverseArray)
    frames=wormReverseArray(i).WormVid;
    initialCurv=generateCurvature(frames(1));
    k3=[k3,mean(initialCurv(41:60))];
    k4=[k4,mean(initialCurv(61:80))];
    k5=[k5,mean(initialCurv(81:100))];
end

figure;
hold on;
hist(k3,binsize);
hist(k4,binsize);
hist(k5,binsize)
h = findobj(gca,'Type','patch');
set(h(1),'FaceColor','w','EdgeColor','r','facealpha',.75)
set(h(2),'FaceColor','w','EdgeColor','b','facealpha',.75);
set(h(3),'FaceColor','w','EdgeColor','g','facealpha',.75)
legend('Seg 3', 'Seg 4', 'Seg 5');
xlabel('Curvature');
ylabel('Frequency of Occurence');
title(['bin number = ',int2str(binsize)]);
end