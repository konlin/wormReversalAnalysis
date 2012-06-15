%plots the maximum curvature of the head over time
function headtailPlot(mcdf)
for n=1:length(mcdf)
    curvature=generateCurvature(mcdf(n));
    head=curvature(1:30);
    tail=curvature(70:100);
    [~,index]=max(abs(tail));
    maxtailcurvature(n)=tail(index);
    [~,index]=max(abs(head));
    maxheadcurvature(n)=head(index);
end
figure;
subplot(2,1,1);
plot(maxheadcurvature, '.');
title('Max Curvature of the Head over Time');
subplot(2,1,2);
plot(maxtailcurvature, '.');
title('Max Curvature of the Tail over Time');


end