@echo off
echo colrow=no           > settings.fig
echo date=mm/dd/yyyy    >> settings.fig
REM copy settings.fig .\Arrays  > nul
REM echo  328  406    > t.GridSpecs.txt

REM echo xx > t.crap
REM copy t.crap .\Arrays  > nul

REM __________________________________________________________________________________________________
REM
REM  

REM                            %1    %2    %3    %4     %5      %6      %7          %8      %9
REM                            --    --    --    --     --      --      --          --      --
call 01_Sub.ArrayBuild.bat    HydKh  L_1   L_2   L_3   Lay_1   Lay_2   Lay_3      SurfK    vks


REM                            %1    %2    %3    %4     %5      %6      %7  
REM                            --    --    --    --     --      --      --  
call 01_Sub_b.ArrayBuild.bat   SY    L_1   L_2   L_3   Lay_1   Lay_2   Lay_3

echo .
echo *********************************************
echo Finished Interpolating Pilot Points to Arrays
echo *********************************************
echo .
