function lambda=findWavelength2(mcdf_array)
%mcdf_array=wormReverse.WormVid;
curvdata=generateCurvature(mcdf_array)';

figure; imagesc(curvdata); colormap(spring); colorbar;
title('Please Click Two Points to Find the Period');
[x,y]=ginput(2);
T=round(y(1))-round(y(2))
title('Please Click on Two Points to Calculate the Velocity');
[x,y]=ginput(2);
v=(.01*(round(x(2))-round(x(1))))/(round(y(2))-round(y(1)))

lambda=T*v

