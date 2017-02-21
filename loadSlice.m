function [sliceIM] = loadSlice(scan,stack,slice)
%loadSlice get image data from one slice from a specific stack from a
%specific scan

Path = [scan.(stack).Path,'\'];
Slicename = [scan.(stack).log{find(strcmp('Filename Prefix', ...
             scan.(stack).log)),2},...
            sprintf(['%0',scan.(stack).log{find(strcmp('Filename Index Length', ...
            scan.(stack).log)),2},'u'],slice)];
Extension = '.tif';
sliceIM = imread([Path,Slicename,Extension]);