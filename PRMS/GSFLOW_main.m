function GSFLOW_Working
% GSFLOW_Working creates plots and output files for PRMS / GSFLOW
% simulations
%
% Based on m-files provided by J. Huntington
%
%


% ---------------------------------------------------------------------- %
% DATA INPUT

% Read in the statvar.dat file (model output)
[Statvar_date,Statvar_data,Statvar_vars,Statvar_elem,Statvar_yr,Statvar_mo,Statvar_dy] = sub_read_statvar;

% Read in the Carmel_2sta.data (observations)
[Obs_date,Obs_data,Obs_vars,Obs_type,Obs_yr,Obs_mo,Obs_dy] = sub_read_obs;

% Read in the Key linking Stream Gauges with Basins/Subbasins
[Gauge_Name,Gauge_SubbasinID,Gauge_Type] = sub_read_gauge_key;


% ---------------------------------------------------------------------- %
% PLOTTING - Basin and Subbasin
sub_basinplots(Statvar_date,Statvar_data,Statvar_vars,Statvar_elem,Obs_date,Obs_data,Obs_vars,Gauge_Name,Gauge_SubbasinID,Gauge_Type)

% ---------------------------------------------------------------------- %
% Save matfile with variables
disp(' Saving GSFLOW.mat with variables and data ...')
save GSFLOW.mat
disp('   done.')

% ---------------------------------------------------------------------- %
% Compute Stats
sub_ComputeStats(Obs_date,Obs_data,Obs_vars,Obs_type,Obs_yr,Obs_mo,Statvar_date,Statvar_yr,Statvar_mo,Statvar_data,Statvar_vars,Statvar_elem,Gauge_Name,Gauge_SubbasinID,Gauge_Type);


