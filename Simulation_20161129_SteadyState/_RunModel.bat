REM  Preprocessing routines

REM  Interpolate Kh, SurfK (all contained in one batch routine)
cd    .\INPUT\pest++\
call  00_MF_Call_Array_Build.bat
cd    ..\..\

REM  Call model runfile
MF_NWT.exe Carmel.nam

REM  Perform post-processing routine #1
cd    .\OUTPUT\
call  obs2obs.exe obs2obs.in obs2obs.out
cd    ..\




