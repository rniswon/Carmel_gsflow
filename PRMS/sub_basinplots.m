function sub_basinplots(Statvar_date,Statvar_data,Statvar_vars,Statvar_elem,Obs_date,Obs_data,Obs_vars,Gauge_Name,Gauge_SubbasinID,Gauge_Type)
% sub_basinplots called to create figure with plots for entire basin
%

% Statvar basin summary water balance components:
%    ppt        in column 1
%    cfs        in column 2
%    gwflow     in column 3
%    sroff      in column 4
%    ssflow     in column 5
%    actet      in column 6
%    potet      in column 7
%    soil_moist in column 8

% Statvar subbasin summary water balance components
%    cfs        in columns 9  - 25
%    precip     in columns 26 - 42
%    actet      in columns 43 - 59
%    potet      in columns 60 - 76

% Subbasin Names and numbers
%    BelowLosPadresReservoir	1
%    DonJuanBridge	            2
%    Highway1Bridge	            3
%    SleepyHollowWeir	        4
%    RoblesdelRio(USGS)	        5
%    NearCarmel(USGS)	        6
%    Carmel River at Lagoon     7
%    AboveLosPadresReservoir	8
%    CachaguaCreek	            9
%    SanClementeCreek	        10
%    GarzasCreekatGarzasRoad	11
%    PineCreek	                12
%    RobinsonCanyonCreek	    13
%    TularcitosCreek	        14
%    GarzasCreek(Canyon)	    15
%    HitchcockCreek	            16
%    PotreroCreek	            17

% Obs components:
%    041534 Carmel Valley COOP      tasmax      in column 1         
%    DAYMET at Hastings RAWS        tasmax      in column 2 
%    041534 Carmel Valley COOP      tasmin      in column 3 
%    DAYMET at Hastings RAWS        tasmin      in column 4 
%    047731 San Clemente COOP       precip      in column 5 
%    1  Carmel River at Lagoon      runoff      in column 6 
%    2  Highway1Bridge              runoff      in column 7 
%    3  NearCarmel(USGS)            runoff      in column 8 
%    4  DonJuanBridge               runoff      in column 9 
%    5  RoblesdelRio(USGS)          runoff      in column 10 
%    6  PotreroCreek                runoff      in column 11 
%    7  RobinsonCanyonCreek         runoff      in column 12 
%    8  GarzasCreek(Canyon)         runoff      in column 13 
%    9  GarzasCreekatGarzasRoad     runoff      in column 14 
%    10 HitchcockCreek              runoff      in column 15 
%    11 TularcitosCreek             runoff      in column 16 
%    12 SleepyHollowWeir            runoff      in column 17 
%    13 SanClementeCreek            runoff      in column 18 
%    14 PineCreek                   runoff      in column 19 
%    15 CachaguaCreek               runoff      in column 20 
%    16 BelowLosPadresReservoir     runoff      in column 21 
%    17 AboveLosPadresReservoir     runoff      in column 22


% ----- BASIN PLOT ----- %
figure(1); clf; orient tall
set(gcf,'name','BASIN PLOTS')
% basin statvar ppt
ax(1) = subplot(411);
plot(Statvar_date,Statvar_data(:,1));
datetick('x',2,'keepticks');
title(Statvar_vars{1,1},'Interpreter', 'none');

% basin statvar cfs (blue) and basin obs (red)
% Basin obs is based on Gauge Key
a = find(strcmp(Gauge_Type,'basin')==1);
Current_Gauge_Name = Gauge_Name(a);
a = strfind(Obs_vars,cell2mat(Current_Gauge_Name));
i=1;
while i<=length(a);
    if ~isempty(cell2mat(a(i)))
        Obs_data_position = i;
    end
    i=i+1;
end

ax(2) =subplot(412);
plot(Statvar_date,Statvar_data(:,2),'b');hold on;
plot(Obs_date,Obs_data(:,Obs_data_position),'r');
datetick('x',2,'keepticks');
title([Statvar_vars{2,1},' (blue) OBS at ',cell2mat(Current_Gauge_Name),' (red)'],'Interpreter', 'none');


% basin statvar potential et (blue) and actual et (red)
ax(3) =subplot(413);
plot(Statvar_date,Statvar_data(:,7)); hold on;
plot(Statvar_date,Statvar_data(:,6),'r');
datetick('x',2,'keepticks');
title([Statvar_vars{7,1},' (blue) ',Statvar_vars{6,1},' (red)'],'Interpreter', 'none');

% basin statvar actual et
%ax(4) =subplot(514);
%plot(Statvar_date,Statvar_data(:,6));
%datetick('x',2,'keepticks');
%title(Statvar_vars{6,1},'Interpreter', 'none');

% basin statvar soil moisture
ax(4) =subplot(414);
plot(Statvar_date,Statvar_data(:,8));
datetick('x',2,'keepticks');
title(Statvar_vars{8,1},'Interpreter', 'none');

linkaxes([ax(1) ax(2) ax(3) ax(4)],'x');
dynamicDateTicks([ax(1) ax(2) ax(3) ax(4)], 'linked')

% ----- SUBBASIN PLOTS, names by Stream Gauge ----- %
subbasin_names = {'BelowLosPadresReservoir',...
    'DonJuanBridge',...
    'Highway1Bridge',...
    'SleepyHollowWeir',...
    'RoblesdelRio(USGS)',...
    'NearCarmel(USGS)',...
    'Carmel River at Lagoon',...
    'AboveLosPadresReservoir',...
    'CachaguaCreek',...
    'SanClementeCreek',...
    'GarzasCreekatGarzasRoad',...
    'PineCreek',...
    'RobinsonCanyonCreek',...
    'TularcitosCreek',...
    'GarzasCreek(Canyon)',...
    'HitchcockCreek',...
    'PotreroCreek'};
% Loop to plot
i = 1;
while i<=length(subbasin_names);
    
    sub_number = i;
    Namestr = ['sub-',int2str(sub_number),' : ',cell2mat(subbasin_names(i))];
    figure(i+1); clf; orient tall
    set(gcf,'name',Namestr);
    
    % subbasin statvar precip
    ax(1) = subplot(311);
    plot(Statvar_date,Statvar_data(:,25+i));
    datetick('x',2,'keepticks');
    titlestr=([Namestr,' : precip']);
    title(titlestr,'Interpreter', 'none');

    % subbasin statvar cfs (blue) and basin obs (red)
    % Basin obs is based on Gauge Key
    a = find(strcmp(Gauge_Type,'subbasin')==1);
    b = find(Gauge_SubbasinID==i);
    Current_Gauge_Name = Gauge_Name(intersect(a,b));
    a = strfind(Obs_vars,cell2mat(Current_Gauge_Name));
    j=1;
    while j<=length(a);
        if ~isempty(cell2mat(a(j)))
            Obs_data_position = j;
        end
        j=j+1;
    end
    ax(2) =subplot(312);
    plot(Statvar_date,Statvar_data(:,8+i),'b');hold on;
    plot(Obs_date,Obs_data(:,Obs_data_position),'r');
    datetick('x',2,'keepticks');
    titlestr=([Namestr,' : cfs (blue)  OBS at ',cell2mat(Current_Gauge_Name),' (red)']);
    title(titlestr,'Interpreter', 'none');

    % subbasin statvar potential et
    ax(3) =subplot(313);
    plot(Statvar_date,Statvar_data(:,59+i),'b'); hold on;
    plot(Statvar_date,Statvar_data(:,42+i),'r');
    datetick('x',2,'keepticks');
    titlestr=([Namestr,' : potential et (blue)  actual et (red)']);
    title(titlestr,'Interpreter', 'none');

    % subbasin statvar actual et
    %ax(4) =subplot(414);
    %plot(Statvar_date,Statvar_data(:,42+i));
    %datetick('x',2,'keepticks');
    %titlestr=([Namestr,' : actual et'])
    %title(titlestr,'Interpreter', 'none');

    linkaxes([ax(1) ax(2) ax(3)],'x');
    dynamicDateTicks([ax(1) ax(2) ax(3)], 'linked')
    
    i=i+1;
end

% Print all figures
%nfigs = i;
%i=1;
%while i<=nfigs
%    figure(i);
%    disp(['printing figure ',int2str(i)])
%    fn = ['figure_',int2str(i)];
%    eval(['print ',fn,' -djpeg75']);
%    pause(2);
%    i=i+1;
%end


    
