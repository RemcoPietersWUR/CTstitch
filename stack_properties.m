function [scan]=stack_properties(scan,stack_id)
%Stack_properties read essential stack properties from CT log file using
%the struct "scan". Output added as additional field in struct "scan"

%Stackname 
stackname = ['stack',num2str(stack_id)];

%Get fist, last and number of slices in the CT stack
scan.(stackname).sliceFirst = str2double(scan.(stackname).log{find(strcmp('First Section',...
                        scan.(stackname).log)),2});
scan.(stackname).sliceLast = str2double(scan.(stackname).log{find(strcmp('Last Section',...
                        scan.(stackname).log)),2});
scan.(stackname).sliceCount= str2double(scan.(stackname).log{find(strcmp('Sections Count',...
                        scan.(stackname).log)),2});
%Get image resolution
scan.(stackname).pxWidth = str2double(scan.(stackname).log{find(strcmp('Result Image Width (pixels)',...
                        scan.(stackname).log)),2});
scan.(stackname).pxHeight = str2double(scan.(stackname).log{find(strcmp('Result Image Height (pixels)',...
                        scan.(stackname).log)),2});

%Get FileName prefix
scan.(stackname).FileNamePrefix = scan.(stackname).log{find(strcmp('Filename Prefix',...
                        scan.(stackname).log)),2};
end


