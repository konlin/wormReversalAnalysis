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
hold on;
plot([mcdf(1).FrameNumber:mcdf(length(mcdf)).FrameNumber],maxheadcurvature, '.');
plot([mcdf(1).FrameNumber:mcdf(length(mcdf)).FrameNumber],maxtailcurvature, '.r');
legend('max head curvature', 'max tail curvature');

end