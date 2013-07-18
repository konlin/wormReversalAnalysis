%Obtains the velocity of the worm from calcium imaging data
%adapated from getVelocity made by Andrew Leifer
%Konlin Shen
%7/18/13

function velocity_smoothed=getVelFromCalcium(fps, curvdata)

spf=1/fps;
tstamp=(0:1:size(curvdata,1)-1)*spf;
ps=findPS(curvdata);

length(ps)
length(tstamp)


velocity_raw= -ps./(100*diff(tstamp));

%apply a cubic spline
velocity_smoothed=csaps(1:1:length(velocity_raw),velocity_raw,0.55);

end

%find phase shift function based off of "findPhaseShift" written by Andrew
%Leifer for the CoLBeRT system
function ps=findPS(curvdata)
    debug = false;
    sigma = 5;
    %pre-allucate the phase shift vector
    ps = zeros([1 (size(curvdata,1)-1)]);

    headCrop=.2;
    tailCrop=0.05;

    %pre allocate x shift
    xs = 1:size(curvdata,2);

    %crop index
    cinds = xs (floor(length(xs)*headCrop):ceil(length(xs)*(1-tailCrop)));

    %This is a function that just shifts xdata some amount x 
    shiftfn = @(x,xdata) interp1(xs, xdata, cinds + x,'linear');
    x = 0;
    op = optimset('lsqcurvefit');
    op.Display = 'off';
    curvaccumulated = lowpass1d(curvdata(1,:),sigma);
    alpha_accum = 0.85;
    for j = 1:length(ps)
           %find the phase shift by doing a least squares fit
           tofitdata = lowpass1d(curvdata(j+1,:),sigma);
        try   x = lsqcurvefit(shiftfn, x, curvaccumulated, tofitdata(:,cinds),-length(xs)*headCrop, length(xs)*tailCrop, op);
        catch
            disp([num2str(j) ': least squares curve fit failed!'])
           %disp('Just fudging it and saying the velocity is the previous veloctiy.')
           x=0; disp('Setting phase shift to zero');
        end
       curvaccumulated = alpha_accum * interp1(xs,curvaccumulated,xs+x,'linear','extrap') + (1-alpha_accum) * tofitdata;
       ps(j) = x; %record the phase shift
       if (debug)
           plot (xs, curvaccumulated, xs, tofitdata); ylim([min(curvdata(:)), max(curvdata(:))]);
           legend ('average', 'current');
           title (['Frame: ' num2str(j) ' PhaseShift: ' num2str(ps(j))]);
           pause(0.05);
       end
    end
end