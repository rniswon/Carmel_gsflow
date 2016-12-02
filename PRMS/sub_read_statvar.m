function [date,data,vars,elem,yr,mo,dy] = sub_read_statvar
% Based on JH original read_statvar

disp(' Reading in statvar.dat ...')
fid = fopen('statvar.dat');
% how many variables are printed in statvar?
header = textscan(fid, '%n','headerlines',0);
header=cell2mat(header);

% scan the variable names in statvar file
C = textscan(fid, '%s %s',header);
% allocate into vars and elements
for i = 1:header
vars{i,:} = C{1,1}{i,1};
elem{i,:} = C{1,2}{i,1};
end

% read the data
cols = header+7;
formatstring=strcat(repmat('%n ',1,cols));
data = textscan(fid, formatstring);
data = cell2mat(data);
% yr mo dy
yr = data(:,2);
mo = data(:,3);
dy = data(:,4);
% make date string from data
date = datenum(data(1,2),data(1,3),data(1,4)):1:datenum(data(end,2),data(end,3),data(end,4));
date = date';
fclose(fid);
% remove date columns from data matrix
data = data(1:end,8:end);
disp('   done.')

% Loop and convert elem to integers
i=1;
foo=[];
while i<=length(elem);
    foo(i)=str2num(cell2mat(elem(i)));
    i=i+1;
end
elem = foo';
