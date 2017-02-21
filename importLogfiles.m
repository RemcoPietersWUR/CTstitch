function [Files, Nlog] = importLogfiles
%importLogfiles function to identify the location of Log files created during the CT reconstruction in
%different folders
%   The files aren't loaded into the memory directly.


% Ask user to define root folder to start searching for log-files
dir = uigetdir(pwd,'Select folder with CT reconstruction data');
% if no files are selected give feedback to command window
if isequal(dir,0)
   disp('User selected Cancel')
end
currentFolder = pwd;
cd(dir)
% Find all log-files in selected folders
[status,list]=system('dir /B /S *.log');
Files = strsplit(list, '\n');
% Remove last empty element from the list
Files = Files(1:numel(Files)-1);
cd(currentFolder)
%Number of found log-files
Nlog = numel(Files);
end