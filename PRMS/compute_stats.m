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
% make date string from data
date = datenum(data(1,2),data(1,3),data(1,4)):1:datenum(data(end,2),data(end,3),data(end,4));
fclose(fid);

%% read in observed sub cfs 
fid = fopen('../input/martis.data');
C1 = textscan(fid, '%d %d %d %d %d %d %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n %n','treatAsEmpty', {'*'},'headerlines',77);
subcfsobs_3 = cell2mat(C1(1,50));
subcfsobs_4 = cell2mat(C1(1,49));
subcfsobs_5 = cell2mat(C1(1,55));
subcfsobs_7 = cell2mat(C1(1,67));
subcfsobs_11 = cell2mat(C1(1,63));
subcfsobs_14 = cell2mat(C1(1,58));
basinobscfs = cell2mat(C1(1,66));
for i = 1:length(date)
    if(subcfsobs_3(i)==-999)
        subcfsobs_3(i) =NaN;
    end
end
for i = 1:length(date)
    if(subcfsobs_4(i)==-999)
        subcfsobs_4(i) =NaN;
    end
end
for i = 1:length(date)
    if(subcfsobs_5(i)==-999)
        subcfsobs_5(i) =NaN;
    end
end
for i = 1:length(date)
    if(subcfsobs_7(i)==-999)
        subcfsobs_7(i) =NaN;
    end
end
for i = 1:length(date)
    if(subcfsobs_11(i)==-999)
        subcfsobs_11(i) =NaN;
    end
end
for i = 1:length(date)
    if(subcfsobs_14(i)==-999)
        subcfsobs_14(i) =NaN;
    end
end
for i = 1:length(date)
    if(basinobscfs(i)==-999)
        basinobscfs(i) =NaN;
    end
end

fclose(fid);
%% Basin outlet stats
QQ = basinobscfs;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,9);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'basin_outlet','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'basin_outlet','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'basin_outlet','D2:D22');

%% Donner Ck stats
QQ = subcfsobs_3;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,16);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'donner_ck','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'donner_ck','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'donner_ck','D2:D22');
%% Cold Ck stats
QQ = subcfsobs_4;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,26);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'cold_ck','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'cold_ck','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'cold_ck','D2:D22');
%% truckee r at truckee stats
QQ = subcfsobs_5;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,36);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'truckeer_at_truckee','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'truckeer_at_truckee','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'truckeer_at_truckee','D2:D22');
%% Squaw Valley stats
QQ = subcfsobs_7;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,46);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'squaw valley','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'squaw valley','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'squaw valley','D2:D22');
%% Prosser stats
QQ = subcfsobs_11;
id = isnan(QQ);
id1 =(QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,56);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'prosser','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'prosser','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'prosser','D2:D22');

%% Martis Ck stats
QQ = subcfsobs_14;
id = isnan(QQ);
id1 = (QQ<0);
id2 = QQ==0;
if(isempty(id1))
    Time = ~id;
else
    Time = ~id & ~id1 & ~id2;
end
QQ = QQ(Time);
PQQ = data(Time,66);
[stats_daily,statsname]=FuncMeasures(QQ,PQQ);
% monthly stats
QQ_mon = grpstats(QQ,{data(Time,2),data(Time,3)});
PQQ_mon = grpstats(PQQ,{data(Time,2),data(Time,3)});
[stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
% yearly stats
QQ_year = grpstats(QQ,{data(Time,2)});
PQQ_year = grpstats(PQQ,{data(Time,2)});
[stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);

xlswrite('baselinestats.xlsx',[stats_daily'],'Martis','B2:B22');
xlswrite('baselinestats.xlsx',[stats_mon'],'Martis','C2:C22');
xlswrite('baselinestats.xlsx',[stats_yearly'],'Martis','D2:D22');