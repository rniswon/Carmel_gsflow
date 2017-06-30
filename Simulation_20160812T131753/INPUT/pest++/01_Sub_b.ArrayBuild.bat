@echo off
REM echo colrow=no           > settings.fig
REM echo date=mm/dd/yyyy    >> settings.fig
REM copy settings.fig    .\Arrays  > nul
REM copy t.GridSpecs.txt .\Arrays  >  nul

REM __________________________________________________________________________________________________

REM  The following is a key for what parameters were passed to this file.
REM  %1  :: HydKh/SY
REM  %2  :: L_1
REM  %3  :: L_2
REM  %4  :: L_3
REM  %5  :: Lay_1
REM  %6  :: Lay_2
REM  %7  :: Lay_3
REM  %8  :: SurfK
REM  %9  :: VKS

REM  Next, specify the parameters required by the called upon batch file.
REM   %1    Enter name of interpolation factor file:                                 
REM   %2    Enter name of pilot points file [points.dat]:  ---  File altered by PEST 
REM   %3    Enter name for output real array file:                                   

REM For Hydraulic conductivity of layer 1
REM ------------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%2_By_ppk2fac.txt    .\%5_SY_PP_List.txt      ..\modflow\upw_support\SY_%5.txt 
cd    ..\modflow\upw_support\
echo  406  328      >   RefArr_In.txt
echo  SY_%5.txt    >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\

REM For Hydraulic conductivity of layer 2
REM ------------------------------------------

call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%3_By_ppk2fac.txt    .\%6_SY_PP_List.txt      ..\modflow\upw_support\SY_%6.txt  
cd    ..\modflow\upw_support\
echo  406  328      >   RefArr_In.txt
echo  SY_%6.txt    >>   RefArr_In.txt
call  ReformArray.exe < RefArr_In.txt
cd    ..\..\pest++\

REM REM For Hydraulic conductivity of layer 3
REM REM -------------------------------------
REM 
REM call 02_Sub.PP2Layer.bat      .\Carmel-Interpolated_%1_%4_By_ppk2fac.txt    .\%7_SY_PP_List.txt      ..\modflow\upw_support\SY_%7.txt 
REM cd    ..\modflow\upw_support\
REM echo  406  328      >   RefArr_In.txt
REM echo  SY_%7.txt    >>   RefArr_In.txt
REM call  ReformArray.exe < RefArr_In.txt
REM cd    ..\..\pest++\




