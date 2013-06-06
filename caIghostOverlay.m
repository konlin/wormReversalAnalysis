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

figure;
subplot(2,1,1);
imshow(dorsalcolormap);
subplot(2,1,2);
imshow(ventralcolormap);

answer=inputdlg({'Set Threshold', 'white background?'});
close;

threshold=str2double(answer{1});
flipToggle=str2num(answer{2});
if(flipToggle==1)
    threshold=1-threshold;
end

sat=false;

while(sat==false)
    %create masks from binary image
    dMask=im2bw(dorsalcolormap, threshold);
    vMask=im2bw(ventralcolormap, threshold);

    if(flipToggle==1)
        dMask=(ones(size(dMask))-dMask);
        vMask=(ones(size(vMask))-vMask);
    end

    %use masks to find boundaries
    figure;
    imagesc(dorsalcolormap);colormap('jet');colorbar;
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
        plot(dboundary(:,2), dboundary(:,1), 'w', 'LineWidth', 3)
    end
    drawnow;
    waitforbuttonpress;
    
    figure;
    imagesc(ventralcolormap);colormap('jet');colorbar;
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
        plot(vboundary(:,2), vboundary(:,1), 'w', 'LineWidth', 3)
    end
    drawnow;
    
    button=questdlg('Satisfactory?');
    if(strcmp(button,'Yes'))
        sat=true;
    else
        newAns=inputdlg({'Set Threshold'});
        threshold=str2double(newAns{1});
        close; close;
    end
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
