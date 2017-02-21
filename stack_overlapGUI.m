function [scan]=stack_overlapGUI(scan,stack1,stack2,offset1,offset2)
%GUI with slider to see overlap between imagesin stack 1 and 2.
%Slice numer of stack 2 can be change by slider
%Input, scan: struct with scan data, 
%stack1&2, field names of stacks in struct
%offset1&2, offset in slide position with respect to last section for
%stack1 and first section in stack2 can be either negative or positive 
%Output, overlapping slice as additional field in struct "scan"

%Get short named variables for slice postions
FirstSlice1 = scan.(stack1).sliceFirst;
LastSlice1 = scan.(stack1).sliceLast;
FirstSlice2 = scan.(stack2).sliceFirst;
LastSlice2 = scan.(stack2).sliceLast;

%Open images
IM1 = loadSlice(scan,stack1,LastSlice1+offset1);
IM2 = loadSlice(scan,stack2,FirstSlice2+offset2);

%Setup GUI
hFig = figure('menu','none');
hAx = axes('Parent',hFig);
%Slider control
uicontrol('Parent',hFig, 'Style','slider', 'Value',FirstSlice2+offset2, 'Min',FirstSlice2,...
    'Max',LastSlice2, 'SliderStep', [1 10]./(LastSlice2-FirstSlice2), ...
    'Position',[150 5 300 20], 'Callback',@slider_callback)
%Text above slider
hTxt = uicontrol('Style','text', 'Position',[290 28 150 15], 'String',['Slice ',num2str(FirstSlice2+offset2)]);
%Show overlay
imshowpair(IM1,IM2)
title('Select best overlapping frame. Close window to continue.')

% Callback function
    function slider_callback(hObj, eventdata)
        %Get slide number from slider position
        slice2 = round(get(hObj,'Value'));
        %Update slice image
        IM2 = loadSlice(scan,stack2,slice2);
        imshowpair(IM1,IM2)
        title('Select best overlapping frame. Close window to continue.')
       %Update slider text
        set(hTxt, 'String',['Slice ',num2str(slice2)]);
        hold off
    end
uiwait(hFig);

%Compute overlap around user selected point to find the best fit.
%Get initial optimizer settings for two images captured on the same device
[optimizer, metric]  = imregconfig('monomodal');
%Run image registration on 9 slices, the one selected by the user and 4
%slices below and 4 slices on top.
%Check if these 4 slices exist in the CT stacks
Opt_range = 4;
FixedSlice=LastSlice1+offset1;
MovingSlice=slice2;
if (FixedSlice<(FirstSlice1+Opt_range)&&FixedSlice>(LastSlice1-Opt_range))
   warning('Optimisation range too small, stack1')
end
if (MovingSlice<(FirstSlice2-Opt_range)&&MovingSlice>(LastSlice2+Opt_range))
   warning('Optimisation range too small, stack2')
end
%Compute optimization
FixedIM = IM1;
for idx=1:(Opt_range*2+1)
    MovingIM = loadSlice(scan,stack2,(MovingSlice-Opt_range-1+idx));
    MovingRegistered = imregister(MovingIM, FixedIM, 'rigid', optimizer, metric);
    OptimizedIM(:,:,:,idx) = imfuse(FixedIM,MovingRegistered,...
                'falsecolor','Scaling','independent');
end
%Setup GUI to select best optimization
hFig2 = figure('menu','none');
hAx = axes('Parent',hFig2);
%Slider control
uicontrol('Parent',hFig2, 'Style','slider', 'Value',1+Opt_range, 'Min',1,...
    'Max',1+Opt_range*2, 'SliderStep', [1 10]./((1+Opt_range*2)-1), ...
    'Position',[150 5 300 20], 'Callback',@slider_callback2)
%Text above slider
hTxt = uicontrol('Style','text', 'Position',[290 28 150 15], 'String',['Slice ',num2str(1+Opt_range)]);
%Show overlay
imshow(OptimizedIM(:,:,:,1+Opt_range))
title('Select best overlapping frame. Close window to continue.')

% Callback function
    function slider_callback2(hObj2, eventdata2)
        %Get slide number from slider position
        slice_opt = round(get(hObj2,'Value'));
        %Update slice image
        imshow(OptimizedIM(:,:,:,slice_opt))
        title('Select best overlapping frame. Close window to continue.')
       %Update slider text
        set(hTxt, 'String',['Slice ',num2str(slice_opt)]);
        hold off
    end
uiwait(hFig2);

%Add overlapping slices in both stacks as additional field in struct "scan"
scan.(stack1).overlapMatch=LastSlice1+offset1;
scan.(stack2).overlapMatch=slice2-(Opt_range*2+1)+slice_opt;
end