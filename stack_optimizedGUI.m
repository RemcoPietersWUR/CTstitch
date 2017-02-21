function stack_optimizedGUI(scan,stack1,stack2,new_stack)
%GUI with slider to see optimized overlap between images in stack 1 and 2.

%Get shorted named variables
FirstSlice1 = scan.(stack1).sliceFirst;
LastSlice1 = scan.(stack1).sliceLast;
overlap1First = scan.(stack1).overlapFirst;
overlap1Last = scan.(stack1).overlapLast;

FirstSlice2 = scan.(stack2).sliceFirst;
LastSlice2 = scan.(stack2).sliceLast;
overlap2First = scan.(stack2).overlapFirst;
overlap2Last = scan.(stack2).overlapLast;

range_fixed=FirstSlice1:(overlap1First-1);
range_overlap1=overlap1First:overlap1Last;
range_overlap2=overlap2First:overlap2Last;
range_moving=(overlap2Last+1):LastSlice2;


FirstNewStack=1;
LastNewStack=size(new_stack,4);

%Setup GUI
hFig = figure('menu','none');
hAx = axes('Parent',hFig);
%Slider control
uicontrol('Parent',hFig, 'Style','slider', 'Value',FirstNewStack, 'Min',FirstNewStack,...
    'Max',LastNewStack, 'SliderStep', [1 10]./(LastNewStack-1), ...
    'Position',[150 5 300 20], 'Callback',@slider_callback)
%Text above slider
hTxt = uicontrol('Style','text', 'Position',[290 28 150 15], 'String',['Slice ',num2str(FirstNewStack)]);
%Show overlay
imshow(new_stack(:,:,1,FirstNewStack));

% Callback function
    function slider_callback(hObj, eventdata)
        %Get slide number from slider position
        slice = round(get(hObj,'Value'));
        %Update slice image
        if slice<overlap1First
            imshow(new_stack(:,:,1,slice))
        elseif slice>(numel(range_fixed)+numel(range_overlap1))
            imshow(new_stack(:,:,2,slice))
        else
            imshowpair(new_stack(:,:,1,slice),new_stack(:,:,2,slice),...
                'falsecolor','Scaling','independent')
        end
        %Update slider text
        set(hTxt, 'String',['Slice ',num2str(slice)]);
        hold off
    end
uiwait(hFig);
end