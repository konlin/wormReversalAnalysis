%create sine fit 4 is for trying to fit sine waves to individual body
%segments over time
function x=createSineFit4(c)
options = optimset('MaxFunEvals', 100000, 'MaxIter', 100000);
numpoints=length(c);
xdata =[1:numpoints];
lb = [0; 0; 0];
ub = [12; .18; 2*pi];

x0 = [5; .097; pi];
x = lsqcurvefit(@myfun,x0,xdata,c,lb,ub, options);
figure;
hold on;
plot(c, '-r');
plot(myfun(x,xdata), '-g'); 
hold off;
k=waitforbuttonpress;

close;
end

function F = myfun(x,xdata)
F = x(1)*sin(x(2)*xdata + x(3));
end