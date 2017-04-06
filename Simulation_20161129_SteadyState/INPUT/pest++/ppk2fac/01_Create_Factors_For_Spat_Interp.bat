@echo off

REM   %1    Model name 
REM   %2    Structure name and final array label in file name
REM   %3    Layer number

Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKh_L_1   1
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 1 Horz. K
echo **************************************************************************************
echo .

REM Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKv_L_1   1
REM echo .
REM echo **************************************************************************************
REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 1 Vert. K
REM echo **************************************************************************************
REM echo .

Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKh_L_2   2
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 2 Horz. K
echo **************************************************************************************
echo .


REM Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKv_L_2   2
REM echo .
REM echo **************************************************************************************
REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 2 Horz. K
REM echo **************************************************************************************
REM echo .


Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKh_L_3   3
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 3 Horz. K
echo **************************************************************************************
echo .


REM Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Carmel_GridSpecification.txt    HydKv_L_3   3
REM echo .
REM echo **************************************************************************************
REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 2 Horz. K
REM echo **************************************************************************************
REM echo .

Call  02_Sub.Create_Factors_For_Spat_Interp_surfK.bat  ..\Carmel_GridSpecification.txt    SurfK   1
echo .
echo *******************************************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Surface K (partition infiltration/recharge)
echo *******************************************************************************************************************
echo .



REM Call  02_Sub.Create_Factors_For_Spatial_Interpolation_Lays_4_and_5_Kh.bat  ..\Carmel_GridSpecification.txt    HydK_L_4_5     HCond_4_5
REM Call  02_Sub.Create_Factors_For_Spatial_Interpolation_Lay_6_Kh.bat         ..\Carmel_GridSpecification.txt    HydK_L_6       HCond_6  
REM Call  02_Sub.Create_Factors_For_Spatial_Interpolation_Lays_2_and_3_SY.bat  ..\Carmel_GridSpecification.txt    SY_L_2_3       SpYld_2_3
REM Call  02_Sub.Create_Factors_For_Spatial_Interpolation_Lays_4_and_5_SY.bat  ..\Carmel_GridSpecification.txt    SY_L_4_5       SpYld_4_5
REM Call  02_Sub.Create_Factors_For_Spatial_Interpolation_Lay_6_SY.bat         ..\Carmel_GridSpecification.txt    SY_L_6         SpYld_6  
