%worm video gui, takes in mcdf arrays
function wormVideoGUI(varargin)

%initialize the framenumber array
framenumbers=ones(nargin, 1)
%initialize figure
figure1=figure;

    function draw
        for n=1:nargin
            subplot(nargin,1,n);
            data=varargin{n};
            hold on
            plotXY(data.WormVid(framenumbers(n)).BoundaryA);
            plotXY(data.WormVid(framenumbers(n)).BoundaryB);
            plotXY(data.WormVid(framenumbers(n)).SegmentedCenterline);
            hold off
            panel=ui
        end
    end
end