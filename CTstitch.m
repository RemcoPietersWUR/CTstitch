%CTstitch manual stitch reconstructed CT-images
clear all
close all
%Get LOG files from sub-scans
%[Files, Nstacks] = importLogfiles;
Files={'D:\temp\Trial scans\MIS17\2013\28\NRecon stacks\9\Bottom\trial_9_beeswax_expt2.4s_rec.log';
    'D:\temp\Trial scans\MIS17\2013\28\NRecon stacks\9\Top\trial_9_beeswax_expt2.4s_rec.log'};
Nstacks = 2;
%Open log files, get file locations and stack properties
for stack = 1:Nstacks
    stackname = ['stack',num2str(stack)];
    scan.(stackname).log = readLogfile(Files{stack});
    [Pathstr,Filename,Ext] = fileparts(Files{stack});
    scan.(stackname).Path = Pathstr;
    scan=stack_properties(scan,stack);
    clear Pathstr Filename Ext
end

%!!!!Assumption scans consist only of 2 subscans, this can be expanded if necessary  


%Show initial overlap stack to find best overlap
scan=stack_overlapGUI(scan,'stack1','stack2',-10,10);
%Find overlapping range in stack 1 & 2
scan=stack_overlap(scan,'stack1','stack2');
%Compute geometric transformation matrix for every overlap
scan=stack_transform(scan,'stack1','stack2','rigid');
%Apply geometric transformation to stack2 and reorganize complete stack
new_stack=stack_apply_transform(scan,'stack1','stack2');
%Show new stack
stack_optimizedGUI(scan,'stack1','stack2',new_stack)
%Save new images
stack_save_images(scan,'stack1','stack2',new_stack)

%Clear memory
clear all