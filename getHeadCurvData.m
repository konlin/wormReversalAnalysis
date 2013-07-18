%calculates the mean curvature and derivative of curvature of the head
%Konlin Shen
%7/8/13

function [hcurv,dhcurv]=getHeadCurvData(curvdata)
t=size(curvdata,1);
dcurvdata=diff(curvdata);

for i=1:t
    hcurv(i)=smooth(mean(curvdata(i,1:10)));
end

for i=1:t-1
    dhcurv(i)=smooth(mean(dcurvdata(i,1:10)));
end

figure;
subplot(2,1,1);plot(hcurv,'.');title('head angles');
subplot(2,1,2);plot(dhcurv,'.');title('derivative of head angles');

end