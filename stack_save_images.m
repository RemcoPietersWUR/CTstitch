function stack_save_images(scan,stack1,stack2,new_stack)
%Save new images 

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
%Get directory for files
DirName = uigetdir(scan.(stack1).Path,'Select folder to save images');
FileNamePrefix = scan.(stack1).FileNamePrefix;
for slice=1:LastNewStack
        if slice<overlap1First
            imwrite(new_stack(:,:,1,slice),[DirName,'\',FileNamePrefix,sprintf('%04u',slice),'.tif']);
        elseif slice>(numel(range_fixed)+numel(range_overlap1))
            imwrite(new_stack(:,:,2,slice),[DirName,'\',FileNamePrefix,sprintf('%04u',slice),'.tif'])
        else
            composedIM= imfuse(new_stack(:,:,1,slice),new_stack(:,:,2,slice),...
                'falsecolor','Scaling','independent','ColorChannels',[1 2 0]);
            imwrite(composedIM,[DirName,'\',FileNamePrefix,sprintf('%04u',slice),'.tif'])
        end
end
end