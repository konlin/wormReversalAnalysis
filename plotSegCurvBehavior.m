%segments worms, averages the curvature, then plots the segments over time
function [maxs1curvature,maxs2curvature,maxs3curvature,maxs4curvature,maxs5curvature]=plotSegCurvBehavior(wormReverse,mcdf)
%initialize segment arrays
maxs1curvature=[];
maxs2curvature=[];
maxs3curvature=[];
maxs4curvature=[];
maxs5curvature=[];


firstframe=find([mcdf.FrameNumber]==wormReverse.WormVid(1).FrameNumber);
if firstframe > 30
    startframe=firstframe-30;
else
    startframe=firstframe;
end

if firstframe+60 < length(mcdf)
    endframe=firstframe+60;
else
    endframe=length(mcdf);
end

frames=mcdf(startframe:endframe);
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

%maxs1curvature=smooth(maxs1curvature);
maxs2curvature=smooth(maxs2curvature);
maxs3curvature=smooth(maxs3curvature);
maxs4curvature=smooth(maxs4curvature);
maxs5curvature=smooth(maxs5curvature);

figure;
subplot(2,1,1);
hold on;
% plot(1:30,maxs1curvature(1:30),'.r'); plot(31:90,maxs1curvature(31:90),'r');
plot(startframe:startframe+29,maxs2curvature(1:30),'.b'); plot(startframe+30:endframe-1,maxs2curvature(31:90),'b');
plot(startframe:startframe+29,maxs3curvature(1:30),'.g'); plot(startframe+30:endframe-1,maxs3curvature(31:90),'g');
plot(startframe:startframe+29,maxs4curvature(1:30),'.c'); plot(startframe+30:endframe-1,maxs4curvature(31:90),'c');
plot(startframe:startframe+29,maxs5curvature(1:30),'.m'); plot(startframe+30:endframe-1,maxs5curvature(31:90),'m');
ylabel('Curvature');
xlabel('Time (in Frames)');

%diffSeg1=smooth(diff(maxs1curvature));
diffSeg2=smooth(diff(maxs2curvature),3);
diffSeg3=smooth(diff(maxs3curvature),3);
diffSeg4=smooth(diff(maxs4curvature),3);
diffSeg5=smooth(diff(maxs5curvature),3);

subplot(2,1,2);
hold on;
%plot(1:30,diffSeg1(1:30),'.r'); plot(31:90,diffSeg1(31:90),'r');
plot(startframe:startframe+29, diffSeg2(1:30), '.b'); plot(startframe+30:endframe-1, diffSeg2(31:90),'b');
plot(startframe:startframe+29, diffSeg3(1:30), '.g'); plot(startframe+30:endframe-1, diffSeg3(31:90),'g');
plot(startframe:startframe+29, diffSeg4(1:30), '.c'); plot(startframe+30:endframe-1, diffSeg4(31:90),'c');
plot(startframe:startframe+29, diffSeg5(1:30), '.m'); plot(startframe+30:endframe-1, diffSeg5(31:90),'m');
title('Derivative');
ylabel('Change in Curvature');
xlabel('Time (in Frames)');

% curv=generateCurvature(mcdf(firstframe));
% figure; 
% hold on; 
% plot(1:20,curv(1:20),'r'); 
% plot(21:40,curv(21:40),'b'); 
% plot(41:60,curv(41:60),'g'); 
% plot(61:80,curv(61:80),'c'); 
% plot(81:100,curv(81:100),'m');

end

