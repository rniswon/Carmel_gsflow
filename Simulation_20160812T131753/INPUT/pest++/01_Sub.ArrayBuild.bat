@echo off
REM echo colrow=no           > settings.fig
REM echo date=mm/dd/yyyy    >> settings.fig
REM copy settings.fig    .\Arrays  > nul
REM copy t.GridSpecs.txt .\Arrays  >  nul

REM __________________________________________________________________________________________________

REM  The following is a key for what parameters were passed to this file.
REM  %1  :: Lay_2_and_3
REM  %2  :: Lay_4_and_5
REM  %3  :: Lay_6
REM  %4  :: HydK_L_2_3
REM  %5  :: HydK_L_4_5
REM  %6  :: HydK_L_6
REM  %7  :: SY_L_2_3
REM  %8  :: SY_L_4_5
REM  %9  :: SY_L_6

REM  Next, specify the parameters required by the called upon batch file.
REM   %1    Enter name of interpolation factor file:                                 
REM   %2    Enter name of pilot points file [points.dat]:  ---  File altered by PEST 
REM   %3    Enter name for output real array file:                                   

REM For Hydraulic conductivity of layer 1
REM ------------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%2_By_ppk2fac.txt    .\%5_K_PP_List.txt      ..\modflow\upw_support\Kh_%5.txt 
cd    ..\modflow\upw_support\
echo  406  328      >   RefArr_In.txt
echo  Kh_%5.txt    >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\

REM For Hydraulic conductivity of layer 2
REM ------------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%3_By_ppk2fac.txt    .\%6_K_PP_List.txt      ..\modflow\upw_support\Kh_%6.txt  
cd    ..\modflow\upw_support\
echo  406  328      >   RefArr_In.txt
echo  Kh_%6.txt    >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\

REM For Hydraulic conductivity of layer 3
REM -------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%4_By_ppk2fac.txt    .\%7_K_PP_List.txt      ..\modflow\upw_support\Kh_%7.txt 
cd    ..\modflow\upw_support\
echo  406  328      >   RefArr_In.txt
echo  Kh_%7.txt    >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\



REM For SurfK (regulate infiltration)
REM -------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%8_By_ppk2fac.txt    .\%8_PP_List.txt       ..\modflow\uzf_support\%8.txt  
cd    ..\modflow\uzf_support\
echo  406  328      >   RefArr_In.txt
echo  %8.txt       >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\





REM REM For Specific Yield of layers 2 & 3
REM REM ----------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\%1_SY_PP_List.txt     ..\%1_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For Specific Yield of layers 4 & 5
REM REM ----------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%8_By_Pest.txt    ..\%2_SY_PP_List.txt     ..\%2_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For Specific Yield of layer 6
REM REM -----------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%9_By_Pest.txt    ..\%3_SY_PP_List.txt     ..\%3_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For THTS (Theta_Sat) of Unsaturated Zone
REM REM ----------------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\UnsatZn_THTS_PP_List.txt     ..\THTS_UZF_Input_Array.txt  THTS
REM 
REM REM For THTR (Theta_Residual) of Unsaturated Zone
REM REM ---------------------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\UnsatZn_THTR_PP_List.txt     ..\THTR_UZF_Input_Array.txt  THTR
REM 