function [scan]=stack_transform(scan,stack1,stack2,transformation_type)
%stack_transform, compute geometric transformation matrix to align
%sub-stacks

%Get initial optimizer settings for two images captured on the same device
[optimizer, metric]  = imregconfig('monomodal');


%Get short-named variables
overlap1First = scan.(stack1).overlapFirst;
overlap1Last = scan.(stack1).overlapLast;
overlap2First = scan.(stack2).overlapFirst;
overlap2Last = scan.(stack2).overlapLast;

sliceCount = 0;
for slice1_id=overlap1First:overlap1Last
    slice2_id = overlap2First + sliceCount;
    %Load image
    fixed = loadSlice(scan,stack1,slice1_id);
    moving = loadSlice(scan,stack2,slice2_id);
    %Compute transformation
    scan.stack2.tform{slice2_id} = imregtform(moving, fixed,transformation_type, optimizer, metric);
    %Increase slice counter
    sliceCount = sliceCount+1;
    clear fixed moving
end