function plotSegCurvBehavior2(reversalArray, mcdf)
%initialize segment arrays
s1array=[];
s2array=[];
s3array=[];
s4array=[];
s5array=[];

figure;
ax(1)=subplot(5,2,1); title('Segment 1');
ax(2)=subplot(5,2,3); title('Segment 2');
ax(3)=subplot(5,2,5); title('Segment 3');
ax(4)=subplot(5,2,7); title('Segment 4');
ax(5)=subplot(5,2,9); title('Segment 5');

ax2(1)=subplot(5,2,2); title('Derivative of Segment 1');
ax2(2)=subplot(5,2,4); title('Derivative of Segment 2');
ax2(3)=subplot(5,2,6); title('Derivative of Segment 3');
ax2(4)=subplot(5,2,8); title('Derivative of Segment 4');
ax2(5)=subplot(5,2,10); title('Derivative of Segment 5');



%subplot(5,2,2); title('Average'); 
%subplot(5,2,4); title('Average Derivative');
for i=1:length(reversalArray)
    
    maxs1curvature=[];
    maxs2curvature=[];
    maxs3curvature=[];
    maxs4curvature=[];
    maxs5curvature=[];
    
    firstframe=find([mcdf.FrameNumber]==reversalArray(i).WormVid(1).FrameNumber);
    if firstframe > 30
        transitionstart=firstframe-30;
    else
        transitionstart=firstframe;
    end
    
    if firstframe+60 < length(mcdf)
        transitionend=firstframe+60;
    else
        transitionend=length(mcdf);
    end
    
    transitionmcdf=mcdf(transitionstart:transitionend);
    
    for index=1:length(transitionmcdf)
        curvature=generateCurvature(transitionmcdf(index));
        s1=curvature(1:20);
        s2=curvature(21:40);
        s3=curvature(41:60);
        s4=curvature(61:80);
        s5=curvature(81:100);

        maxs1curvature=[maxs1curvature,mean(s1)];
        maxs2curvature=[maxs2curvature,mean(s2)];
        maxs3curvature=[maxs3curvature,mean(s3)];
        maxs4curvature=[maxs4curvature,mean(s4)];
        maxs5curvature=[maxs5curvature,mean(s5)];
    end

    s1array=[s1array;maxs1curvature];s2array=[s2array;maxs2curvature];
    s3array=[s3array;maxs3curvature];s4array=[s4array;maxs4curvature];
    s5array=[s5array;maxs5curvature];

    
    ds1=abs(smooth(diff(maxs1curvature)));ds2=abs(smooth(diff(maxs2curvature)));
    ds3=abs(smooth(diff(maxs3curvature)));ds4=abs(smooth(diff(maxs4curvature)));
    ds5=abs(smooth(diff(maxs5curvature)));
    
    
    
    subplot(5,2,1);
    hold on;
    plot(1:30,maxs1curvature(1:30),'k');
    plot(31:90,maxs1curvature(31:90),'r');
    hold off;
    
    subplot(5,2,2);
    hold on;
    plot(1:30,ds1(1:30),'k');
    plot(31:90,ds1(31:90),'r');
    hold off;
    
    subplot(5,2,3);
    hold on;
    plot(1:30,maxs2curvature(1:30),'k');
    plot(31:90,maxs2curvature(31:90),'b');
    hold off; 
    
    subplot(5,2,4);
    hold on;
    plot(1:30,ds2(1:30),'k');
    plot(31:90,ds2(31:90),'b');
    hold off;
    
    subplot(5,2,5);
    hold on;
    plot(1:30,maxs3curvature(1:30),'k');
    plot(31:90,maxs3curvature(31:90),'g');
    hold off;
    
    subplot(5,2,6);
    hold on;
    plot(1:30,ds3(1:30),'k');
    plot(31:90,ds3(31:90),'g');
    hold off;
    
    subplot(5,2,7);
    hold on;
    plot(1:30,maxs4curvature(1:30),'k')
    plot(31:90,maxs4curvature(31:90),'c');
    hold off;
    
    subplot(5,2,8);
    hold on;
    plot(1:30,ds4(1:30),'k')
    plot(31:90,ds4(31:90),'c');
    hold off;
    
    subplot(5,2,9);
    hold on;
    plot(1:30,maxs5curvature(1:30),'k')
    plot(31:90,maxs5curvature(31:90),'m');
    hold off;
    
    subplot(5,2,10);
    hold on;
    plot(1:30,ds5(1:30),'k')
    plot(31:90,ds5(31:90),'m');
    hold off;
    
    
end

s1avg=mean(s1array); s2avg=mean(s2array); s3avg=mean(s3array); s4avg=mean(s4array);
s5avg=mean(s5array);

figure;
title('Average');
hold on;
plot(s1avg,'r');plot(s2avg,'b');plot(s3avg,'g');plot(s4avg,'c');plot(s5avg,'m');
hold off;
legend('Seg 1', 'Seg 2', 'Seg 3', 'Seg 4', 'Seg 5');

% ds1avg=smooth(abs(diff(s1)));ds2avg=smooth(abs(diff(s2)));ds3avg=smooth(abs(diff(s3)));
% ds4avg=smooth(abs(diff(s4)));ds5avg=smooth(abs(diff(s5)));
% 
% subplot(5,2,4);
% hold on;
% plot(ds1avg,'r');plot(ds2avg,'b');plot(ds3avg,'g');plot(ds4avg,'c');plot(ds5avg,'m');
% hold off
% legend('Seg 1', 'Seg 2', 'Seg 3', 'Seg 4', 'Seg 5');

linkaxes(ax,'y');
linkaxes(ax2,'y');
set(ax,'YLim',[-7 7]);
set(ax2,'YLim',[0 1])

end
    