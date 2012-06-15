%plots the maximum curvature of the tail over time
function tailPlot(mcdf)
for n=1:length(mcdf)
    curvature=generateCurvature(mcdf(n));
    tail=curvature(70:100);
    [~,index]=max(abs(tail));
    maxtailcurvature(n)=tail(index);
end
figure;
plot(maxtailcurvature, '.')
title('Max Curvature of the Tail over Time');
end