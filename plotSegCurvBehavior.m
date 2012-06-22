%segments worms, averages the curvature, then plots the segments over time
function [maxs1curvature,maxs2curvature,maxs3curvature,maxs4curvature,maxs5curvature]=plotSegCurvBehavior(reversalArray,string)
%initialize segment arrays
maxs1curvature=[];
maxs2curvature=[];
maxs3curvature=[];
maxs4curvature=[];
maxs5curvature=[];

frames=reversalArray;%.WormVid(1:90);
for m=1:length(frames)
    curvature=generateCurvature(frames(m));
    s1=curvature(1:20);
    s2=curvature(21:40);
    s3=curvature(41:60);
    s4=curvature(61:80);
    s5=curvature(81:100);
    
    %[~,index]=max(abs(s1));
    maxs1curvature=[maxs1curvature,mean(s1)];%[maxs1curvature,s1(index)];
    %[~,index]=max(abs(s2));
    maxs2curvature=[maxs2curvature,mean(s2)];%[maxs2curvature,s2(index)];
    %[~,index]=max(abs(s3));
    maxs3curvature=[maxs3curvature,mean(s3)];%[maxs3curvature,s3(index)];
    %[~,index]=max(abs(s4));
    maxs4curvature=[maxs4curvature,mean(s4)];%[maxs4curvature,s4(index)];
    %[~,index]=max(abs(s5));
    maxs5curvature=[maxs5curvature,mean(s5)];%[maxs5curvature,s5(index)];
end

maxs2curvature=smooth(maxs2curvature);
maxs3curvature=smooth(maxs3curvature);
maxs4curvature=smooth(maxs4curvature);
maxs5curvature=smooth(maxs5curvature);


figure;
subplot(2,1,1);
hold on;
%plot(maxs1curvature,'r');
plot(maxs2curvature,'b');
plot(maxs3curvature,'g');
plot(maxs4curvature,'c');
plot(maxs5curvature,'m');
legend('Seg 2', 'Seg 3', 'Seg 4', 'Seg 5');
title(string);
ylabel('Curvature');
xlabel('Time (in Frames)');

%diffSeg1=smooth(diff(maxs1curvature));
diffSeg2=smooth(diff(maxs2curvature),2);
diffSeg3=smooth(diff(maxs3curvature),2);
diffSeg4=smooth(diff(maxs4curvature),2);
diffSeg5=smooth(diff(maxs5curvature),2);

subplot(2,1,2);
hold on;
%plot(diffSeg1, 'r');
plot(diffSeg2, 'b');
plot(diffSeg3, 'g');
plot(diffSeg4, 'c');
plot(diffSeg5, 'm');
legend('Seg 2', 'Seg 3', 'Seg 4', 'Seg 5');
title('Derivative');
ylabel('Change in Curvature');
xlabel('Time (in Frames)');

end

