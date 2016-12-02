function [GaugeName,Gauge_SubbasinID,GaugeType]=sub_read_gauge_key
% Read in the key linking subbasins (Statvar) with stream gauges
% (Observations)
disp(' Reading in subbasin_gauge_key.csv ...');
fid = fopen('subbasin_gauge_key.csv','r');
i=1;
line = fgetl(fid);
while i>0
    line = fgetl(fid);
    if line == -1
        fclose(fid);
        i=0;
        break
    else
        a = strfind(line,',');
        GaugeName{i}        = line(a(1)+1:a(2)-1);
        Gauge_SubbasinID(i) = str2num(line(a(2)+1:a(3)-1)); 
        GaugeType{i}        = line(a(3)+1:length(line));
    end
    i=i+1;
end
disp('   done.');
