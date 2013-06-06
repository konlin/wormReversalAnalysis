% %GCamp3/RFP muscle image processing
% %by Quan Wen
% %minor modifications by Konlin Shen 06/04/13
% %March 2013

function [ventral_brightness_data_filtered, dorsal_brightness_data_filtered...
    ,curvdatafiltered]=calcium_imaging_muscles_triggering2(varargin)
    
    button = length(questdlg('Load new data?','','Yes (TIF)','Yes (MAT) ','No', 'Yes (TIF)') ) ;
    
    if button == 10
        [filename,pathname]  = uigetfile({'*.mat'});
        load([pathname filename]);
    elseif button == 9
    
    do_dialog = 1;
    
    if do_dialog
    
        if exist('pathname', 'var')
            try
                if isdir(pathname)
                cd(pathname);
                end
            end
        end
        [filename,pathname]  = uigetfile({'*.tif'});

       fname = [pathname filename];


        info = imfinfo(fname);
        num_images = numel(info);

        fps=10;
        spline_p=0.001;
        istart=0;
        iend=0;
        thresh=2;

    %enter the frame rate, start frame and end frame selected from the imaging sequences

        if exist('do_multitif', 'var')
            answer = inputdlg({'fps','Start frame', 'End frame','spline parameter','threshold(1-3)','multi-tif files'}, 'Cancel to clear previous', 1, ...
                {num2str(fps),num2str(istart),num2str(iend),num2str(spline_p),num2str(thresh),num2str(do_multitif)});
        else
            answer = inputdlg({'fps','Start frame', 'End frame','spline parameter','threshold(1-3)','multi-tif files'}, '', 1);
        end

        if isempty(answer) 
            answer = inputdlg({'fps','Start frame', 'End frame','spline parameter','threshold(1-3)'}, '', 1);
        end


        fps = str2double(answer{1});
        istart = str2double(answer{2});
        iend = str2double(answer{3});
        spline_p=str2double(answer{4});
        thresh=str2double(answer{5});
        do_multitif=str2double(answer{6});

    end

    numframes = iend - istart + 1; %number of frames analyzed


    %%%%%%%%%%%%%%%%%%%%%%%%%%INITIALIZATIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numcurvpts = 100;
    corr_pts_all = zeros(numframes, numcurvpts, 6);
    curvdata = zeros(numframes,numcurvpts);
    angle_data =zeros(numframes, numcurvpts+1);
    ventral_brightness_data = zeros(numframes,numcurvpts);
    dorsal_brightness_data = zeros(numframes,numcurvpts);   
    vulva_indices = zeros(numframes,1);
    boundary_segment1=zeros(numframes,1);
    boundary_segment2=zeros(numframes,1);
    %max_pt = 100;
    %min_pt = 1;
    brows=[];

    %%%%% MAIN CALCULATIONS %%%%%

    for j=1:numframes
        
        if do_multitif
            
            rb = imread(fname, 2*j-1+2*(istart-1), 'Info', info); %read multiple tif files and green channel
            c = imread(fname, 2*j+2*(istart-1), 'Info', info); %read red channel

        else
            
            if (j+istart-1 > 9999)
                constr = '%05d';
            else
                constr = '%03d';
            end

            frame_index = num2str(j+istart-1,constr);
            num_digits = length(frame_index);

            fname1=strcat(pathname, filename(1:length(filename)-num_digits-6), frame_index, 'c1','.tif');
            rb=imread(fname1);

            fname2=strcat(pathname, filename(1:length(filename)-num_digits-6), frame_index, 'c2','.tif');
            c=imread(fname2);

        end

        [m,n]=size(rb);

        %text(10,10,num2str(j+istart-1),'Color', 'white');

        corr_pts = -ones(numcurvpts,6);            %pad out data matrices with -1 for "no data"
        corr_data = -ones(numcurvpts,3);
        corr_data_average = -ones(numcurvpts,3);

        if j==1
            figure (1); imagesc(rb); colormap(gray); axis off; hold on;
            text(10,20, 'select ROI for background intensity estimate', 'Color', 'white');
            [cropx1_bkg cropy1_bkg] = ginput(1);
            cropx1_bkg= floor(cropx1_bkg);
            cropy1_bkg  = floor(cropy1_bkg);
            hold on, plot([1 n], [cropy1_bkg cropy1_bkg], '-r');
            hold on, plot([cropx1_bkg cropx1_bkg], [1 m], '-r');
            [cropx2_bkg cropy2_bkg] = ginput(1);
            cropx2_bkg = floor(cropx2_bkg);
            cropy2_bkg = floor(cropy2_bkg);
            hold on, plot([1 n], [cropy2_bkg cropy2_bkg], '-r');
            hold on, plot([cropx2_bkg cropx2_bkg], [1 m/2], '-r');
            text(10,20, 'select ROI for background intensity estimate', 'Color','black');

            text(10,10,'click on head', 'Color', 'white');
            [headx heady] = ginput(1);
            hold on; 
            plot(headx, heady, 'or');
            headx0 = headx; heady0 = heady;
            text(10,10,'click on head', 'Color', 'black');     
            text(10,10,'click on tail', 'Color', 'white');
            [tailx taily] = ginput(1);
            tailx0 = tailx; taily0 = taily;
            text(10,10,'click on tail', 'Color', 'black');

            %text(10,10,'click two points separated by worm diameter','Color', 'white');
            %tmp1 = ginput(1); 
            %plot(tmp1(1),tmp1(2), 'ow');
            %tmp2 = ginput(1);
            %plot(tmp2(1),tmp2(2), 'ow');
            %worm_diam = norm(tmp1-tmp2);
            %text(10,10,'click two points separated by worm diameter','Color', 'black');

            %filsize=0.25;

            %if mod(round(filsize*worm_diam),2)==1
            %    filradius = round(filsize*worm_diam/2);
            %else
            %    filradius = round(filsize*worm_diam/2)+1;
            %end
    %       
            %fil = fspecial('disk', filradius);

            %text(10,10,'define threshold value for computing the skeleton', 'Color', 'black');
            %text(10,10,'define threshold value for computing the muscle intensity', 'Color', 'white');     %user defines threshold value for finding worm boundary (this is global)
            %[threshx threshy] = ginput(1);
            %lvl_original = mean(mean(I(round(threshy)-2:round(threshy)+2, round(threshx)-2:round(threshx)+2))); 
            %text(10,10,'define threshold value for computing the muscle intensity', 'Color', 'black');

        end


        bkg_rb=mean(mean(rb(cropy1_bkg:cropy2_bkg,cropx1_bkg:cropx2_bkg)));
        bkg_c=mean(mean(c(cropy1_bkg:cropy2_bkg,cropx1_bkg:cropx2_bkg)));

        rb_cross_adj=rb-bkg_rb;
        I_cross_adj=c-bkg_c;%-0.153*rb_cross_adj;

        %ratio_cross=ratio(cropy1:cropy2,cropx1:cropx2);

        figure (1), hold off
        imagesc(rb); colormap(gray); axis equal; axis off; hold on;

        text(10,10,num2str(j+istart-1),'Color', 'white');

        if j==1
            text(10,20,'click on vulva', 'Color', 'white');     %user selects vulva location (this is done for each frame)
            [vulvax vulvay] = ginput(1);
            text(10,20,'click on vulva', 'Color', 'black');  
        end

         %c_filtered_gaussian=imfilter(rb+c,hg);                    %gaussian low-pass filter the image 
        %rb_cross_filtered=imfilter(r_cross,hg);
        
        sigma=1;

        [~,threshold]=edge(rb+c,'canny');

        BW_edge=edge(rb+c,'canny',thresh*threshold,sigma);

        BW_edge=bwareaopen(BW_edge,4);

        se=strel('disk',6);

        closeBW_edge=imclose(BW_edge,se);

        bw=imfill(closeBW_edge,'holes');

        se2=strel('disk',4);

        bw = imopen(bw,se2);

        STATS = regionprops(logical(bw),'Area', 'Centroid');

        if size(STATS,1) == 0 
            disp('Error: no worm found');
            break;
        end

        num=1;

        area=0;

        if (length(STATS)>1)
            for k=1:length(STATS)
                if STATS(k).Area>area
                    area=STATS(k).Area;
                    num=k;
                end
            end
        end

        [B,L] = bwboundaries(bw,'noholes');

        B1 = B{num};

        B1_size = size(B1,1);

        ksep = ceil(B1_size/20);

        B1_plus = circshift(B1,[ksep 0]);
        B1_minus = circshift(B1,[-ksep 0]);

        AA = B1 - B1_plus;  % AA and BB are vectors between a point on boundary and neighbors +- ksep away
        BB = B1 - B1_minus;

        cAA = AA(:,1) + sqrt(-1)*AA(:,2);
        cBB = BB(:,1) + sqrt(-1)*BB(:,2);

        B1_angle = unwrap(angle(cBB ./ cAA));

        min1 = find(B1_angle == min(B1_angle),1); % find point on boundary w/ minimum angle between AA, BB
        B1_angle2 = circshift(B1_angle, -min1);
        min2a = round(.25*B1_size)-1+find(B1_angle2(round(.25*B1_size):round(0.75*B1_size))==min(B1_angle2(round(.25*B1_size):round(0.75*B1_size))),1);  % find minimum in other half
        min2 = 1+mod(min2a + min1-1, B1_size);

        tmp = circshift(B1, [1-min1 0]);
        end1 = 1+mod(min2 - min1-1, B1_size);
        path1 = tmp(1:end1,:);
        path2 = tmp(end:-1:end1,:);

        if norm(path1(1,:) - [heady headx]) > norm(path1(end,:) - [heady headx]) % if min1 is at tail, reverse both paths
            tmp = path1;
            path1 = path2(end:-1:1,:);
            path2 = tmp(end:-1:1,:);
        end

        heady = path1(1,1);
        headx = path1(1,2);
        taily = path1(end,1);
        tailx = path1(end,2);

        path_length = numcurvpts;

        path1_rescaled = zeros(path_length,2);
        path2_rescaled = zeros(path_length,2);
        path1_rescaled2 = zeros(path_length,2);
        path2_rescaled2 = zeros(path_length,2);

        path1_rescaled(:,1) = interp1(0:size(path1,1)-1, path1(:,1), (size(path1,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
        path1_rescaled(:,2) = interp1(0:size(path1,1)-1, path1(:,2), (size(path1,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
        path2_rescaled(:,1) = interp1(0:size(path2,1)-1, path2(:,1), (size(path2,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
        path2_rescaled(:,2) = interp1(0:size(path2,1)-1, path2(:,2), (size(path2,1)-1)*(0:path_length-1)/(path_length-1), 'linear');

        for kk=1:path_length
            path_temp=path2_rescaled(max(1,kk-15):min(path_length,kk+15),:);
            l=length(path_temp);
            tmp1 = repmat(path1_rescaled(kk,:), [l,1]) - path_temp;
            tmp2 = sqrt(tmp1(:,1).^2 + tmp1(:,2).^2);
            path2_rescaled2(kk,:) = path_temp(find(tmp2==min(tmp2),1),:);
        end

    %     path1_rescaled2 = path1_rescaled;

        for kk=1:path_length
            path_temp=path1_rescaled(max(1,kk-15):min(path_length,kk+15),:);
            l=length(path_temp);
            tmp1 = repmat(path2_rescaled(kk,:), [l,1]) - path_temp;
            tmp2 = sqrt(tmp1(:,1).^2 + tmp1(:,2).^2);
    %         find(tmp2==min(tmp2),1)
            path1_rescaled2(kk,:) = path_temp(find(tmp2==min(tmp2),1),:);
        end
        weight_fn = ones(path_length,1);
        tmp=round(path_length*0.1);
        weight_fn(1:tmp)=(0:tmp-1)/tmp;
        weight_fn(end-tmp+1:end)=(tmp-1:-1:0)/tmp;
        weight_fn_new = [weight_fn weight_fn];


        midline = 0.5*(path1_rescaled+path2_rescaled);
        midline2a = 0.5*(path1_rescaled+path2_rescaled2);
        midline2b = 0.5*(path1_rescaled2+path2_rescaled);
        midline_mixed = midline2a .* weight_fn_new + midline .* (1-weight_fn_new);



        figure(1);
        plot(path1_rescaled(1,2),path1_rescaled(1,1), 'or'); hold on;
        plot(path2_rescaled(end,2),path2_rescaled(end,1), 'oy'); hold on;
    %  
        %plot(path1_rescaled(1:path_length,2),path1_rescaled(1:path_length,1),'-g'); hold on;
        %plot(path2_rescaled(1:path_length,2),path2_rescaled(1:path_length,1), '-r'); hold on;

        if j==1
            d1_square=min(sum((path1_rescaled-repmat([vulvay vulvax],path_length,1)).^2,2));
            d2_square=min(sum((path2_rescaled-repmat([vulvay vulvax],path_length,1)).^2,2));
        end

        if d1_square<d2_square
            ventral=path1;
            dorsal=path2;
        else
            ventral=path2;
            dorsal=path1;
        end

        %d_p=csaps(dorsal(:,2),dorsal(:,1),spline_p);
        %v_p=csaps(ventral(:,2),ventral(:,1),spline_p);

        plot(path1(:,2),path1(:,1),'-k'); hold on;
        plot(path2(:,2),path2(:,1),'-k'); hold on;
        plot(midline_mixed(:,2),midline_mixed(:,1), '-k');

        %d_path(:,2)=smooth(d_path(:,2),10);
        %d_path(:,1)=smooth(d_path(:,1),10);
        %v_path(:,2)=smooth(v_path(:,2),10);
        %v_path(:,1)=smooth(v_path(:,1),10);

        [line,cv2,splen] = spline_line( midline_mixed,spline_p,numcurvpts);

        d_path = spline_line( dorsal,spline_p,2*numcurvpts);

        v_path = spline_line( ventral,spline_p,2*numcurvpts);

        segment_len=splen(end)/path_length;

        % interpolate to equally spaced length units
        cv2i = interp1(splen+.00001*(0:length(splen)-1),cv2, (0:(splen(end)-1)/(numcurvpts+1):(splen(end)-1)));

        % store cv2i data 
        %cv2i_data(j,:,:) = cv2i;


        df2 = diff(cv2i,1,1);
        atdf2 =  unwrap(atan2(-df2(:,2), df2(:,1)));
        angle_data(j,:) = atdf2';

        curv = unwrap(diff(atdf2,1)); 
        corr_data(:,1) = curv;     %collect curvature information for midline

        figure (1); hold on; plot(line(:,1),line(:,2),'w.','linewidth',2);
        %plot(d_path(:,1),d_path(:,2),'-r','linewidth',2);
        %plot(v_path(:,1),v_path(:,2),'-b','linewidth',2);


        for i=1:path_length  %compute the brightness of ventral and dorsal side

            ld=length(d_path);
            lv=length(v_path);

            %end_pt_d=min(round((i+20)/path_length*ld),ld);

            start_pt_d=max(1,round((i-20)/path_length*ld));
            end_pt_d=min(round((i+20)/path_length*ld),ld);
            start_pt_v=max(1,round((i-20)/path_length*lv));
            end_pt_v=min(round((i+20)/path_length*lv),lv);

            %vector_midline=(line(min(i+1,path_length),:)-line(max(i-1,1),:))/norm((line(min(i+1,path_length),:)-line(max(i-1,1),:)));
            %d_d=zeros(end_pt_d-start_pt_d+1,1);
            %d_v=zeros(end_pt_v-start_pt_v+1,1);

            %for kk=start_pt_d:1:end_pt_d
            %    d_d(kk-start_pt_d+1)=norm(d_path(kk,:)-line(i,:));
            %end

            %for kk=start_pt_v:1:end_pt_v
            %    d_v(kk-start_pt_v+1)=norm(v_path(kk,:)-line(i,:));
            %end

            d_norm = sum((d_path(start_pt_d:end_pt_d,:) - repmat(line(i,:), end_pt_d-start_pt_d+1,1)).^2,2);        %find points on dorsal and ventral lines that have minimum distance to midline (corresponding points)
            v_norm = sum((v_path(start_pt_v:end_pt_v,:) - repmat(line(i,:), end_pt_v-start_pt_v+1,1)).^2,2);  

            [d_norm_min,I_d] = min(d_norm);
            [v_norm_min,I_v] = min(v_norm);
            I_d=I_d+start_pt_d-1;
            I_v=I_v+start_pt_v-1;

            hold on; plot([d_path(I_d,1),v_path(I_v,1)],[d_path(I_d,2),v_path(I_v,2)],'-w','linewidth',0.5);

            corr_pts(i, 1:2) = line(i,:);                     % makes a matrix of corresponding points on midline, ventral line, and dorsal line
            corr_pts(i, 3:4) = d_path(I_d,:);                 % column 1:2 = midline (x,y)    column 3:4 = dorsal(x,y)    column 5:6 = ventral(x,y)
            corr_pts(i, 5:6) = v_path(I_v,:);

            if i>=3
                f_d=0.8;

                corner1_d=(1-f_d)*corr_pts(i,3:4)+f_d*corr_pts(i,1:2);
                corner2_d=(1-f_d)*corr_pts(i-2,3:4)+f_d*corr_pts(i-2,1:2);

                f_v=0.8;

                corner1_v=(1-f_v)*corr_pts(i,5:6)+f_v*corr_pts(i,1:2);
                corner2_v=(1-f_v)*corr_pts(i-2,5:6)+f_v*corr_pts(i-2,1:2);

                C_d=[corner1_d(1) corner2_d(1) corr_pts(i-2,3) corr_pts(i,3) corner1_d(1)];
                R_d=[corner1_d(2) corner2_d(2) corr_pts(i-2,4) corr_pts(i,4) corner1_d(2)];

                C_v=[corner1_v(1) corner2_v(1) corr_pts(i-2,5) corr_pts(i,5) corner1_v(1)];
                R_v=[corner1_v(2) corner2_v(2) corr_pts(i-2,6) corr_pts(i,6) corner1_v(2)];

                bw_d=roipoly(rb,C_d,R_d);
                bw_v=roipoly(rb,C_v,R_v);
                corr_data(i-1, 2) = mean(rb_cross_adj(bw_d))/mean(I_cross_adj(bw_d));   %collects brightness information for dorsal and ventral sides average over different sides
                corr_data(i-1, 3) = mean(rb_cross_adj(bw_v))/mean(I_cross_adj(bw_v));

                if isinf(corr_data(i-1,2))
                    corr_data(i-1, 2) = mean(rb_cross_adj(bw_d))/mean(I_cross_adj(bw_d)+mean(I_cross_adj(:)));
                end

                 if isinf(corr_data(i-1,3))
                    corr_data(i-1, 3) = mean(rb_cross_adj(bw_v))/mean(I_cross_adj(bw_v)+mean(I_cross_adj(:)));
                 end

                 if isnan(corr_data(i-1,2))||isnan(corr_data(i-1,3))
                     brows(end+1)=j;
                 end
            end
            
            %column 2 = dorsal brightness         column 3 = ventral brightness

            %range=max((d_norm_min+v_norm_min)/3,mt); %define a region to calculate the brightness

            % create windows on dorsal and ventral side, to look up brightness values
            %I_d_x_window = max(1,ceil(d_path(I_d,1)-range)):min(Xmax,round(d_path(I_d,1)+range));
            %I_v_x_window = max(1,ceil(v_path(I_v,1)-range)):min(Xmax,round(v_path(I_v,1)+range));

            %I_d_y_window = max(1,ceil(d_path(I_d,2)-range)):min(Ymax,round(d_path(I_d,2)+range));
            %I_v_y_window =  max(1,ceil(v_path(I_v,2)-range)):min(Ymax,round(v_path(I_v,2)+range));

            %I_window_d=ratio_cross(I_d_y_window,I_d_x_window);
            %I_window_v=ratio_cross(I_v_y_window,I_v_x_window);

            %bw_d=bw(I_d_y_window,I_d_x_window);
            %bw_v=bw(I_v_y_window,I_v_x_window);
        end

        corr_data(end,2:3)=corr_data(end-1,2:3);
        corr_data(1,2:3)=corr_data(2,2:3);

        figure (1); hold on;
        plot(corr_pts(:,3), corr_pts(:,4), 'r-','linewidth',2);      %plot dorsal side in red
        plot(corr_pts(:,5), corr_pts(:,6), 'b-','linewidth',2);      %plot ventral side in blue 

        %save brightness and curvature data 
        corr_pts_all(j,:,:) = corr_pts;
        curvdata(j,:)=corr_data(:,1);
        ventral_brightness_data(j,:) = corr_data(:,3);
        dorsal_brightness_data (j,:) = corr_data(:,2);
        %ratio_data(j,:,:)=ratio;

        %pause;

    end    %end of calculations for 1 frame

    end    %end of dialog

    %%%%%%DELETE BAD FRAMES%%%%%%%

    cmap=redgreencmap;
    cmap(:,3)=cmap(:,2);
    cmap(:,2)=0;

    figure; clf; 
        imagesc(curvdata(:,:)*100); colormap(cmap); caxis([-10,10]);

      %imagesc(dorsal_brightness_data_filtered(:,:)); colormap(jet); colorbar; caxis([0.8 5]);

        title('click bad rows, press return');
        badrows = ginput;

        if ~isempty(badrows)
            brows=[brows';ceil(badrows(:,2))];
        end

         for j=1:length(brows)
             row = brows(j);

             disp(strcat('bad row #', num2str(j), '=', num2str(row)));
             if row==1
                 curvdata(1,:) = curvdata(2,:);
                 corr_pts_all(1,:,:)=corr_pts_all(2,:,:);
                 ventral_brightness_data(1,:)=ventral_brightness_data(2,:);
                 dorsal_brightness_data(1,:)=ventral_brightness_data(2,:);
             end
             if row==numframes
                 curvdata(numframes,:) = curvdata(numframes-1,:);
                 corr_pts_all(numframes,:,:)=corr_pts_all(numframes-1,:,:);
                 ventral_brightness_data(numframes,:)=ventral_brightness_data(numframes-1,:);
                 dorsal_brightness_data(numframes,:)=ventral_brightness_data(numframes-1,:);

             end
             if row>1 && row<numframes
                 %m=size(badrows,1);
                 %pre=row-j;
                 %post=row+m-j+1;
                 %if pre<1 pre=1;
                 %end
                 %if post>numframes
                 %    post=numframes; 
                 %end
                 pre=row-1;
                 while ~isempty(find(brows==pre,1))&&(pre>1)
                     pre=pre-1;
                 end
                 post=row+1;
                 while ~isempty(find(brows==post,1))&&(post<numframes)
                     post=post+1;
                 end
                 curvdata(row,:) =0.5*(curvdata(pre,:)+curvdata(post,:));
                 boundary_segment1(row)=0.5*(boundary_segment1(pre)+boundary_segment1(post));
                 boundary_segment2(row)=0.5*(boundary_segment2(pre)+boundary_segment2(post));
                 corr_pts_all(row,:,:)=0.5*(corr_pts_all(pre,:,:)+corr_pts_all(post,:,:));
                 ventral_brightness_data(row,:)=0.5*(ventral_brightness_data(pre,:)+ventral_brightness_data(post,:));
                 dorsal_brightness_data(row,:)=0.5*(dorsal_brightness_data(pre,:)+dorsal_brightness_data(post,:));

             end
         end
         
    close;

    %%%%%running average of curvature, brightness%%%%%%%

    answer = inputdlg({'time filter', 'body coord filter', 'mean=0, median=1'}, '', 1, {num2str(2), num2str(10), '0'});
    timefilter = str2double(answer{1});
    bodyfilter = str2double(answer{2});

    h = fspecial('average', [timefilter bodyfilter]);
    curvdatafiltered = imfilter(curvdata*100,  h , 'replicate');
    ventral_brightness_data_filtered = imfilter(ventral_brightness_data, h, 'replicate');
    dorsal_brightness_data_filtered = imfilter(dorsal_brightness_data, h, 'replicate');

    %plot the curvature diagram
    figure; 
    imagesc(curvdatafiltered(:,:)); colormap(cmap); colorbar; caxis([-10 10]);

    title('cuvature diagram');


    set(gca,'XTICK',[1 20 40 60 80 100]);
    set(gca,'XTICKLABEL',[0 0.2 0.4 0.6 0.8 1]);

    set(gca,'YTICK',1:10*fps:numframes);
    y_tick=get(gca,'YTICK');
    set(gca,'YTICKLABEL',(y_tick-1)/fps);

    xlabel('fractional distance along the centerline (head=0; tail=1)');
    ylabel('time (s)');
    m=msgbox('Please select origin of reversal');
    uiwait(m);
    [~,revY]=ginput(1);
    hold on;
    plot(1:100, revY, 'LineWidth', 8, 'Color', 'g', 'LineStyle','-');
    hold off;
    
    %plot the GC3/RFP ratios
    %first determine bounds for scaling
    maxVentral=max(max(ventral_brightness_data_filtered));
    maxDorsal=max(max(dorsal_brightness_data_filtered));
    
    if(maxVentral>maxDorsal)
        colorMax=maxVentral;
    else
        colorMax=maxDorsal;
    end
    
    clims=[0 colorMax];
    
    %now plot ratios using the same colorbar scale
    figure;
    subplot(1,2,1); 
    imagesc(ventral_brightness_data_filtered(:,:), clims); 
    colormap(jet); colorbar; %caxis([0 colorMax]);

    title('ventral ratio GC3/RFP');
    set(gca,'XTICK',[1 20 40 60 80 100]);
    set(gca,'XTICKLABEL',[0 0.2 0.4 0.6 0.8 1]);

    set(gca,'YTICK',1:10*fps:numframes);
    y_tick=get(gca,'YTICK');
    set(gca,'YTICKLABEL',(y_tick-1)/fps);

    xlabel('fractional distance along the centerline (head=0; tail=1)');
    ylabel('time (s)');
    
    hold on;
    plot(1:100, revY, 'LineWidth', 8, 'Color', 'm', 'LineStyle','-');

    subplot(1,2,2); 
    imagesc(dorsal_brightness_data_filtered(:,:), clims); 
    colormap(jet); colorbar; %caxis([0 colorMax]);

    title('dorsal ratio GC3/RFP');
    set(gca,'XTICK',[1 20 40 60 80 100]);
    set(gca,'XTICKLABEL',[0 0.2 0.4 0.6 0.8 1]);

    set(gca,'YTICK',1:10*fps:numframes);
    y_tick=get(gca,'YTICK');
    set(gca,'YTICKLABEL',(y_tick-1)/fps);

    xlabel('fractional distance along the centerline (head=0; tail=1)');
    ylabel('time (s)'); 
    
    hold on;
    plot(1:100, revY, 'LineWidth', 8, 'Color', 'm', 'LineStyle','-');

    if length(questdlg('Save this data? '))==3
        [fn savepathname]= uiputfile('*.mat', 'choose file to save', strcat(fname, '_',num2str(istart),'-',num2str(iend),'.mat'));
        if length(fn) > 1
            fnamemat = strcat(savepathname,fn);
            save(fnamemat);
        end
    end
        
end

