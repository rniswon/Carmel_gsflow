
**The following infomration is from Justin Huntington and describes added data in the /GIS folder and /MODFLOW/OUTPUT/budget folder


ftp - /carmel_git_overvlow  files too bit to put on repo -find them at ftp://pubfiles.dri.edu/pub/justinh/carmel_git_overflow/

-hru_params.shp are the model cells with model parameters in attribute table. Some parameter attributes are not up to date due to calibration within model files.
-ned_10m_nad83z10_hillshade is the 10m dem hillshade



following files added to repo

GIS/wells
-CVmons062308.shp are the Carmel Valley monitoring wells used for the HOBS file

-LogsWithWLdata.shp are the well logs with water level data, but the location of these wells is sketchy..

-wds_parameter_summary_matrix-v2-MHFR_updated2011_JL.xls is pump test data that goes with FR_WL_wtshd.shp

-Curry1997Wells.shp are wells that go with the Curry 1997 study.

-springs.shp are some identified springs

-merged_dtw_obs_v8_utm_dem_hru_identity_v1_obs_minus_sim.shp - wells and heads origionally used to develop the HOBS file

-ss_calib_v1.1.xlsx file showing stead state calibration depth to water and head residuals 


***note***

GIS and HOBS file heads/dtw values were adjusted according to the following

observed depth to water was adjusted based on the difference between the model cell elevation and the 10m dem cell elevation interpolated to the well

adj_obs_dtw = obs_dtw - (DEM_adj - DEM_10m)   (DEM_adj is the model cell elevation)

adjusted observed heads is computed by taking the different between the model cell elevation and the adjusted observed depth to water

adj_obs_head = DEM_adj - adj_obs_dtw



GIS/geology

GEOLOGY.shp - 30 x 60 Wright Geology - Lew Rosenberg compiled in 2001 for Monterey County General Plan

CVAlogansmoth.shp is the bathymetery map of alluvium (ft)

alluvium.shp is the interpretation of alluviul fill extent within Carmel Valley

cageol_poly_dd_clip is the state geology map clipped to the Carmel WS boundary


GIS/streams

iseg_v7.shp are the modflow stream cells used in sfr and match iseg in the hru_parms_v10.shp attribute table

riparian_plus_stream_cells.shp are the riparian and sfr cells where ETg is simulated

sfr_v7_input_all_clean_and_sort.xlsx are the formatted sfr inputs derived from iseg_v7.shp

width_depth_relationship_sfr_v7.xlsx are the stream incission and width relationships with model cell flow accumulation (assumed relationships)

sfr_input.txt - .txt file format of file above for input to custom fortran code to format to .sfr file 

Carmel_xsections.sfr - output file from custom fortran code - with cross section information included

streamflow_datafile.xlsx - streamflow data for each gage (in cfs)

/Create_SFR_input/xxxx are the fortran project files used to create SFR file



GIS/gages

stream_gages_dd83.shp gage locations based on reported lat and longs.

stream_gages_dd83_mod.shp is the same as above but many gage locations have been modified (but not actual lat and longs in table) to coorospond to upscalled 100m stream cell locations



GIS/watersheds

Wtrshd_20120227_nad83z10.shp - carmel watershed

subbasin.img - subbasins based on gage locations



MODFLOW/OUTPUT/budget

Budget.xlsx - steady state water budget comparing simulated and measured/reported streamflow and ETg




