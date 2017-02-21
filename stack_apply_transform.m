function [new_stack]=stack_apply_transform(scan,stack1,stack2)
%stack_apply_transform, apply geometric transformation for stack2. Use
%compute transformation for every overlaping images and use avarge
%transformation maxtrix for the remaining images.
%Reorganize all images in a new stack.

%Get shorted named variables
FirstSlice1 = scan.(stack1).sliceFirst;
LastSlice1 = scan.(stack1).sliceLast;
overlap1First = scan.(stack1).overlapFirst;
overlap1Last = scan.(stack1).overlapLast;

FirstSlice2 = scan.(stack2).sliceFirst;
LastSlice2 = scan.(stack2).sliceLast;
overlap2First = scan.(stack2).overlapFirst;
overlap2Last = scan.(stack2).overlapLast;

%preallocate new_stack
image_layers=2; %Green layer, fixed image stack1, purple layer, moving image stack2
%Declare ranges of different image sections, fixed ones from stack1,
%overlaping range & stack2 without overlap
range_fixed=FirstSlice1:(overlap1First-1);
range_overlap1=overlap1First:overlap1Last;
range_overlap2=overlap2First:overlap2Last;
range_moving=(overlap2Last+1):LastSlice2;
new_stack=zeros(scan.(stack1).pxWidth,scan.(stack1).pxHeight,image_layers,...
    (numel(range_fixed)+numel(range_overlap1)+numel(range_moving)),'uint16');
%Load fixed images
for fixed_id = 1:numel(range_fixed)
    new_stack(:,:,1,fixed_id) = loadSlice(scan,stack1,range_fixed(fixed_id));
end
%Perform geometric correction in overlap region
for overlap_id = 1:numel(range_overlap1)
    fixedIM = loadSlice(scan,stack1,range_overlap1(overlap_id));
    movingIM = loadSlice(scan,stack2,range_overlap2(overlap_id));
    movingRegistered = imwarp(movingIM,scan.(stack2).tform{range_overlap2(overlap_id)},...
        'OutputView',imref2d(size(fixedIM)));
    new_stack(:,:,1,overlap_id+numel(range_fixed))=fixedIM;
    new_stack(:,:,2,overlap_id+numel(range_fixed))=movingRegistered;
    clear movingIM movingRegistered
end
%Perform geometric correction to extending region stack2
%Compute avarage tform matrix
tform=zeros(3,3);
for overlap2_id = 1:numel(range_overlap2)
    tform = tform + scan.(stack2).tform{1,range_overlap2(overlap2_id)}.T;
end
tform_avg = affine2d(tform/numel(range_overlap2));
for moving_id=1:numel(range_moving)
    movingIM = loadSlice(scan,stack2,range_moving(moving_id));
    movingRegistered = imwarp(movingIM,tform_avg,'OutputView',imref2d(size(fixedIM)));
    new_stack(:,:,2,moving_id+numel(range_fixed)+numel(range_overlap1)) = movingRegistered;
    clear movingIM movingRegistered
end
end
