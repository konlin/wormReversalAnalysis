function x =createSineFit2(c, options)
%c = c(19:90);
xdata = [1:100]';
lb = [0; 0; 0];
ub = [12; .18; 2*pi];

x0 = [5; .097; pi];
x = lsqcurvefit(@myfun,x0,xdata,c,lb,ub, options);
figure;
hold on;
plot(c, '-r');
plot(myfun(x,xdata), '-g'); 
title('Click to accept, press any key to reject');
hold off;
k=waitforbuttonpress;
if k==1
    x=[];
end

close;
end

function F = myfun(x,xdata)
F = x(1)*sin(x(2)*xdata + x(3));
end