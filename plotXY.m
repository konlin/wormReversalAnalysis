%simple program to plot data in the form [x1,y1,x2,y2,x3,y3,...]
%created by Konlin Shen 6/6/12
function plotXY(data)
Xdata=[];
Ydata=[];
for n=1:200
    if(mod(n,2)==1)
        Xdata=[Xdata,data(n)];
    end
    if(mod(n,2)==0)
        Ydata=[Ydata,data(n)];
    end
end
plot(Xdata,Ydata)
end