function [obs_date,obs_data,obs_vars,obs_type,obs_yr,obs_mo,obs_dy] = sub_read_obs

% Based on JH original read_statvar
disp(' Reading in Carmel_2sta.data ...')
fid = fopen('Carmel_2sta.data');

% Figure out the number of columns of data
i=1;
while i>0
    line = fgetl(fid);
    if strcmp(line(1),'#')
        headerlines = i;
        line = fgetl(fid);
        line = str2num(line);
        cols = length(line);
        frewind(fid);
        i=-1;
        break
    end
    i=i+1;
end

% Get the variable names for each column of data
% Discard first 4 header lines
fgetl(fid);fgetl(fid);fgetl(fid);fgetl(fid);
i=1;
while i<=cols-6; % Six columns for date
    line = fgetl(fid);
    obs_vars{i,:} = strtrim(line(3:30));
    obs_type{i,:} = strtrim(line(30:40));
    i=i+1;
end


% Read in the data based on the number of columns
formatstring  = strcat(repmat('%n ',1,cols));
C1            = textscan(fid, formatstring,'treatAsEmpty', {'*'},'headerlines',headerlines);

% obs Date
DateTime = cell2mat(C1(1,1:6));
obs_date  = datenum(DateTime(:,1),DateTime(:,2),DateTime(:,3),DateTime(:,4),DateTime(:,5),DateTime(:,6));
obs_yr    = DateTime(:,1);
obs_mo    = DateTime(:,2);
obs_dy    = DateTime(:,3);

% obs Data
obs_data = cell2mat(C1(1,7:cols));

% Set "no data -999" to NaN
[nrows,ncols]=size(obs_data);
i=1;
while i<=ncols
    a = find(obs_data(:,i)<-100);
    obs_data(a,i) = NaN;
    i = i+1;
end
disp('   done.')
fclose(fid);
