%overlays the boundaries of the colormaps for dorsal and ventral calcium
%activity
%by Konlin Shen
%06/05/13

function caIghostOverlay(dorsal_brightness_filtered, ventral_brightness_filtered)
%save the images and load them into the workspace
imwrite(dorsal_brightness_filtered, 'dorsalcolormap.jpg');
imwrite(ventral_brightness_filtered, 'ventralcolormap.jpg');

dorsalcolormap=imread('dorsalcolormap.jpg');
ventralcolormap=imread('ventralcolormap.jpg');

%create masks from binary image
threshold=0.7;

dMask=im2bw(dorsalcolormap, threshold);
vMask=im2bw(ventralcolormap, threshold);

%use masks to find boundaries
figure;
imagesc(dorsalcolormap);
title('Dorsal Brightness Ratio');
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
    dbCell{k}=dboundary;
    hold on;
    plot(dboundary(:,2), dboundary(:,1), 'w', 'LineWidth', 2)

end

figure;
imagesc(ventralcolormap);
title('Ventral Brightness Ratio');
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
    vbCell{k}=vboundary;
    hold on;
    plot(vboundary(:,2), vboundary(:,1), 'w', 'LineWidth', 2)

end

%overlay boundaries
figure;
hold on;
set(gca,'YDir','reverse');

for k = 1:length(dbCell)
    dboundary=dbCell{k};
    plot(dboundary(:,2), dboundary(:,1),'LineWidth', 1, 'Color', 'g')
end

for k = 1:length(vbCell)
    vboundary=vbCell{k};
    plot(vboundary(:,2), vboundary(:,1),'LineWidth', 1, 'Color', 'r')
end

title('Dorsal(green) and Ventral(red) Boundaries Overlayed');
end
