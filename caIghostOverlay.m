function caIghostOverlay(dorsal_brightness_filtered, ventral_brightness_filtered)
%save the images and load them into the workspace
imwrite(dorsal_brightness_filtered, 'dorsalcolormap.jpg');
imwrite(ventral_brightness_filtered, 'ventralcolormap.jpg');

dorsalcolormap=imread('dorsalcolormap.jpg');
ventralcolormap=imread('ventralcolormap.jpg');

%create masks from binary image
dMask=im2bw(dorsalcolormap, .75);
vMask=im2bw(ventralcolormap, .75);

%use masks to find boundaries
figure;
imagesc(dorsalcolormap);
dbndries=bwboundaries(dMask,'noholes');
dbndry=zeros(1,2);
for k=1:length(dbndries)
    dbndry=dbndries{k};
    n=size(dbndry,1);
    filt=normpdf((1:n),n/2,.01*n);
    filt=filt/sum(filt);
    dbndry=[dbndry;dbndry(1:n,:)];
    dbnd=filter(filt,1,dbndry);
    dboundary=dbnd(n+1:end,:);
    hold on;
    for k = 1:length(dbndries)
        plot(dboundary(:,2), dboundary(:,1), 'w', 'LineWidth', 2)
    end
end

figure;
imagesc(ventralcolormap);
vbndries=bwboundaries(vMask,'noholes');
vbndry=zeros(1,2);
for k=1:length(vbndries)
    vbndry=vbndries{k};
    n=size(vbndry,1);
    filt=normpdf((1:n),n/2,.01*n);
    filt=filt/sum(filt);
    vbndry=[vbndry;vbndry(1:n,:)];
    vbnd=filter(filt,1,vbndry);
    vboundary=vbnd(n+1:end,:);
    hold on;
    for k = 1:length(vbndries)
        plot(vboundary(:,2), vboundary(:,1), 'w', 'LineWidth', 2)
    end
end

%overlay boundaries
figure;
hold on;
for k = 1:length(dbndries)
    plot(dboundary(:,2), dboundary(:,1), 'w', 'LineWidth', 2, 'Color', 'g')
end

for k = 1:length(vbndries)
    plot(vboundary(:,2), vboundary(:,1), 'w', 'LineWidth', 2, 'Color', 'r')
end

title('Boundaries Overlayed');
end
