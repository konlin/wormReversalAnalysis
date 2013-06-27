%
%6/25/13
%Konlin Shen

function headContraction(vbd,dbd)

timeLen=size(dbd,1);

vbdHEAD=vbd(:,1:10);
dbdHEAD=dbd(:,1:10);

for t=1:timeLen
    vbdHEADmeans(t)=mean(vbdHEAD(t,:));
    dbdHEADmeans(t)=mean(dbdHEAD(t,:));
end

vmin=min(min(vbdHEADmeans));
dmin=min(min(dbdHEADmeans));

vHEADdeltas=(vbdHEADmeans-vmin)/vmin;
dHEADdeltas=(dbdHEADmeans-dmin)/dmin;

figure;
plot(vHEADdeltas,'b');
hold on;
plot(dHEADdeltas,'r');

end