function plotDelKDist(wormReverseArray, binsize, windowsize)
delk3=[];
delk4=[];
delk5=[];

for i=1:length(wormReverseArray)
    frames=wormReverseArray(i).WormVid;
    initialCurv=generateCurvature(frames(1));
    si3=mean(initialCurv(41:60));
    si4=mean(initialCurv(61:80));
    si5=mean(initialCurv(81:100));
    
    tenthFrameCurv=generateCurvature(frames(windowsize));
    st3=mean(tenthFrameCurv(41:60));
    st4=mean(tenthFrameCurv(61:80));
    st5=mean(tenthFrameCurv(81:100));
    
    delk3=[delk3,st3-si3];
    delk4=[delk4,st4-si4];
    delk5=[delk5,st5-si5];
    
end

delk3
delk4
delk5


figure;
hold on;
hist(delk3,binsize);
hist(delk4,binsize);
hist(delk5,binsize)
h = findobj(gca,'Type','patch');
set(h(1),'FaceColor','w','EdgeColor','r','facealpha',.75)
set(h(2),'FaceColor','w','EdgeColor','b','facealpha',.75);
set(h(3),'FaceColor','w','EdgeColor','g','facealpha',.75)
legend('Seg 3', 'Seg 4', 'Seg 5');
xlabel('Change in Curvature');
ylabel('Frequency of Occurence');
title(['bin number = ',int2str(binsize),' window size = ',int2str(windowsize)]);
end

