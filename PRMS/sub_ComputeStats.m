function sub_ComputeStats(Obs_date,Obs_data,Obs_vars,Obs_type,Obs_yr,Obs_mo,Statvar_date,Statvar_yr,Statvar_mo,Statvar_data,Statvar_vars,Statvar_elem,Gauge_Name,Gauge_SubbasinID,Gauge_Type)
% sub_ComputeStats computes statistics between Observation Data and Statvar
% data
% 
%
% based on compute_stats.m provided by J.H

disp(' Computing stats... ');

% Set flag for overwriting output file first time through
FirstTimeFlag = 1;
% Operate on Statvar data where vars = "sub_cfs"/"basin_cfs" and elem = 1->17
i=1;
while i<=length(Statvar_vars);
    CurrentVar  = cell2mat(Statvar_vars(i));
    CurrentID   = Statvar_elem(i);
    CurrentType = cell2mat(Statvar_vars(i));
    if strcmp(CurrentVar,'sub_cfs') | strcmp(CurrentVar,'basin_cfs') ;
        
        % Matching gauge
        a = find(Gauge_SubbasinID==CurrentID);      
        if length(a)>1
            % Match based on basin or subbasin -> key is "sub"
            if isempty(strfind(CurrentVar,'sub'))
                % BASIN
                % HARDWIRE FOR CARMEL RIVER AT LAGOON UNTIL J.H PROVIDES
                % FURTHER GUIDANCE
                a = a(1);
            else
                % SUBBASIN
                b = strcmp(Gauge_Type(a),'subbasin');
                b = find(b==1);
                a = a(b);
            end
        end
        
        % Display for user
        CurrentGauge = cell2mat(Gauge_Name(a));   
        %disp(' Statvar Data Name : Basin/Subbasin ID : Obs Gauge from Key')
        %disp([CurrentVar,'            : ',int2str(CurrentID),'                :  ',CurrentGauge ]) 
        
        
        % Find column in obs data that matches gauge 
        j=1;
        while j<=length(Obs_vars);
            a = strfind(cell2mat(Obs_vars(j)),CurrentGauge);
            if ~isempty(a)
                col(j) = 1;
            else
                col(j) = 0;
            end
            j=j+1;
        end
        col = find(col==1);
        % Display for QC
        %disp([' Observation Data  : ',cell2mat(Obs_vars(col)),'  ',cell2mat(Obs_type(col)),' in Obs_data column ',int2str(col)]);
        %disp(' ');
        
        % -- Observation data (all)
        a       = find(~isnan(Obs_data(:,col)));
        QQ      = Obs_data(a,col);
        QQ_time = Obs_date(a);
        QQ_yr   = Obs_yr(a);
        QQ_mo   = Obs_mo(a);
                
        % -- Statvar data (all)
        a        = find(~isnan(Statvar_data(:,i)));
        PQQ      = Statvar_data(a,i);
        PQQ_time = Statvar_date(a);
        PQQ_yr   = Statvar_yr(a);
        PQQ_mo   = Statvar_mo(a);
        
        % -- Common data (all) determined by time
        [C,IA,IB] = intersect(QQ_time,PQQ_time);
        QQ        = QQ(IA);
        QQ_time   = QQ_time(IA);
        QQ_yr     = QQ_yr(IA);
        QQ_mo     = QQ_mo(IA);
        PQQ       = PQQ(IB);
        PQQ_time  = PQQ_time(IB);
        PQQ_yr    = PQQ_yr(IB);
        PQQ_mo    = PQQ_mo(IB);
        
        
        % There may not be any observation data
        
        % STATS
        if ~isempty(QQ)
            % Daily Stats
            [stats_daily,statsname]=FuncMeasures(QQ,PQQ);
            % Monthly Stats
            QQ_mon  = grpstats(QQ,{QQ_yr,QQ_mo});
            PQQ_mon = grpstats(PQQ,{PQQ_yr,PQQ_mo});
            [stats_mon,statsname]=FuncMeasures(QQ_mon,PQQ_mon);
            % Yearly Stats
            QQ_year  = grpstats(QQ,{QQ_yr});
            PQQ_year = grpstats(PQQ,{PQQ_yr}); 
            [stats_yearly,statsname]=FuncMeasures(QQ_year,PQQ_year);
        else
            %disp(' NO DATA in QQ');
            %disp(' ');
            
            stats_daily  = zeros(1,21);
            stats_mon    = zeros(1,21);
            stats_yearly = zeros(1,21); 
            
            stats_name = {  'MSE         ',...         
                            'MSE Log10   ',...
                            'MSE TrLam   ',...
                            'PBias       ',...
                            'PBias Log10 ',...
                            'PBias TrLam ',...
                            'NSE         ',...
                            'NSE Log10   ',...
                            'NSE TrLam   ',...
                            'MSE FDC     ',...
                            'MSE FDCLog10',...
                            'MSE FDCTrLam',...
                            'QPCorr      ',...
                            'MaxAbs PBias',...
                            'MaxAbsPBiasL',...
                            'Pct Mean Dif',...
                            'Pct Var Diff',...
                            'Pct L10MeanD',...
                            'Pct L10VarDf',...
                            'Pct LTrMeanD',...
                            'Pct LTrVarDf'};
        end
        
        % Write Output - Overwrite first time through
        if FirstTimeFlag==1;
            FirstTimeFlag=0;
            fido = fopen('baselinestats.csv','wt');
            fprintf(fido,'Basin_Subbasin ID   ,   Type  ,       Gauge             ,  Statistic  ,     Daily    ,    Monthly   ,   Yearly    \n');
        else
            fido = fopen('baselinestats.csv','a');
        end
        j=1;
        while j<=length(stats_daily);
            outstr = sprintf('%12.0f , %s , %s , %s , %6.6f , %6.6f , %6.6f',CurrentID,CurrentType,CurrentGauge,char(stats_name(j)),stats_daily(j),stats_mon(j),stats_yearly(j));
            fprintf(fido,'%s\n',outstr);
            j=j+1;
        end
        fclose(fido);
    end
    i=i+1;
end

disp(' Creating file baselinestats.csv ...');
disp('    done.');
        
        
    