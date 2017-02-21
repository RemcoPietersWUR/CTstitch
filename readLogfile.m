function [LogID] = readLogfile(File)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Open log-file & read text data
fileID = fopen(File,'r');
data = textscan(fileID,'%s','Delimiter',{'=',sprintf('; ')},'EndOfLine','\r\n','CollectOutput', true);
fclose(fileID);
%Reshape cell array
data = [data{1,1}];
%Remove structual headers
for data_item = 1:(numel(data)-5)
    if strcmp(data{data_item},'[System]')
    data(data_item) = [];
    end
    if strcmp(data{data_item},'[Acquisition]')
    data(data_item) = [];
    end
    if strcmp(data{data_item},'[Reconstruction]')
    data(data_item) = [];
    end
    if strcmp(data{data_item},'[File name convention]')
    data(data_item) = [];
    end
    if strcmp(data{data_item},'Filter type description')
    data(data_item) = [];
    end
end
%Sort info data in cell-array
element = 1;
for data_item = 1:2:(numel(data)-1)
    LogID{element,1} = data{data_item};
    LogID{element,2} = data{data_item+1};
    element = element + 1;
    end
end