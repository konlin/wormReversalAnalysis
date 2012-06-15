%segments worms, averages the curvature, then plots the segments over time
function [maxs1curvature,maxs2curvature,maxs3curvature,maxs4curvature,maxs5curvature]=plotSegCurvBehavior(reversalArray)
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
    
    [~,index]=max(abs(s1));
    maxs1curvature=[maxs1curvature,s1(index)];
    [~,index]=max(abs(s2));
    maxs2curvature=[maxs2curvature,s2(index)];
    [~,index]=max(abs(s3));
    maxs3curvature=[maxs3curvature,s3(index)];
    [~,index]=max(abs(s4));
    maxs4curvature=[maxs4curvature,s4(index)];
    [~,index]=max(abs(s5));
    maxs5curvature=[maxs5curvature,s5(index)];
end

figure;
hold on
plot(maxs1curvature,'r');
plot(maxs2curvature,'b');
plot(maxs3curvature,'g');
plot(maxs4curvature,'c');
plot(maxs5curvature,'m');
legend('seg 1', 'seg 2', 'seg 3', 'seg 4', 'seg 5');
title('foward motion in C.elegans');

end

%s1=mean(s1);
%s2=mean(s2);
%s3=mean(s3);
%s4=mean(s4);
%s5=mean(s5);


