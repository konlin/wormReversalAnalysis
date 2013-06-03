%Superimposes all the centerlines on top of each other
%5/20/13

function centerlineSuperposition(cra)
size=length(cra);

%cycles through a cleanedReversalArray and plots the centerlines
figure;
hold all;
for i=1:size
  centerline=reshape(cra(i).WormVid(1).SegmentedCenterline'...
      ,2,100);
  centerline=centerline';
  
  %normalizes the centerlines such that the expectation of theta is 0
  normCenterline=normalizeCenterline(centerline);
  
  plot(normCenterline(:,1),normCenterline(:,2));
end
title('Superposition of Worm Centerlines Prior to Reversing');
end

function normCenterline=normalizeCenterline(centerline)
%translate the centerline such that the tail is at the origin
translateX=centerline(100,1)-0;
translateY=centerline(100,2)-0;
for j=1:100
  centerline(j,1)=centerline(j,1)-translateX;
  centerline(j,2)=centerline(j,2)-translateY;
end

%normalize for wormlength by summing over the distances between adjacent
%points on the centerline
totalLength=0;
for k=1:99
    ds=sqrt((centerline(k,1)-centerline(k+1,1))^2+...
        (centerline(k,2)-centerline(k+1,2))^2);
    totalLength=totalLength+ds;
end

centerline=centerline./totalLength;

%rotates the centerline such that the head-tail vector is (1,0)
htVector=[centerline(1,1)-centerline(100,1)...
    centerline(1,2)-centerline(100,2)];
theta=acos(dot([1 0],htVector)/sqrt(htVector(1)^2+htVector(2)^2));
rotMat=[cos(-theta) -sin(-theta); sin(-theta) cos(-theta)];
rotCenterlineTranspose=rotMat*centerline';
normCenterline=rotCenterlineTranspose';
normHTvector=[normCenterline(1,1)-normCenterline(100,1)...
    normCenterline(1,2)-normCenterline(100,2)]
if(round(normHTvector(2))~=0)
    disp('rotating the other way');
    rotMat=[cos(theta) -sin(theta); sin(theta) cos(theta)];
    rotCenterlineTranspose=rotMat*centerline';
    normCenterline=rotCenterlineTranspose';
    normHTvector=[normCenterline(1,1)-normCenterline(100,1)...
        normCenterline(1,2)-normCenterline(100,2)]
end
disp('success!');

%-----------------------------OLD ALGORITHM-------------------------------%
% %rotate the centerline such that the expectation of theta is 0
% tangents=diff(centerline);
% for i=1:length(tangents)
%     theta(i)=acos(dot([1 0],[tangents(i,1) tangents(i,2)])...
%         ./(sqrt(tangents(i,1).^2+tangents(i,2).^2)));
% end
% expectationTheta=mean(theta);
% 
% if(expectationTheta ~= 0)
%     rotMat=[cos(-expectationTheta) -sin(-expectationTheta);...
%         sin(-expectationTheta) cos(-expectationTheta)];
%     rotCenterlineTranspose=rotMat*centerline';
%     normCenterline=rotCenterlineTranspose';
%     normTangents=diff(normCenterline);
%     for j=1:length(normTangents)
%         normTheta(i)=acos(dot([1 0], [normTangents(j,1) normTangents(j,2)])...
%             ./(sqrt(normTangents(j,1).^2+normTangents(j,2).^2)));
%     end
%     normExpectation=mean(normTheta)
% else
%     normCenterline=centerline;
% end
%-------------------------------------------------------------------------%

end