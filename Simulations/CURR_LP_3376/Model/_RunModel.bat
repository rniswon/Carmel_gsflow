REM  Preprocessing routines

REM  Interpolate Kh, SurfK (all contained in one batch routine)
cd    .\INPUT\pest++\
call  00_MF_Call_Array_Build.bat
cd    ..\..\

REM  Adjust the PRMS input file with the latest scaled ssr2gw scaled values
cd    .\INPUT\prms\
call  scale_params.exe
cd    ..\..\

cd    .\INPUT\modflow\
call  par2par.exe par2par_vks.in
cd    ..\..\

REM  Call model runfile
GSFLOW.exe Carmel.control

REM  Perform post-processing routine #1
cd    .\tsproc\
call  tsproc.exe tsproc_CL.in tsproc_CL.out
call  tsproc.exe tsproc_DJ.in tsproc_DJ.out
call  tsproc.exe tsproc_GA.in tsproc_GA.out
call  tsproc.exe tsproc_H1.in tsproc_H1.out
call  tsproc.exe tsproc_NC.in tsproc_NC.out
call  tsproc.exe tsproc_RR.in tsproc_RR.out
REM call  tsproc.exe tsproc_SH.in tsproc_SH.out

call obs2obs.exe obs2obs_CL.in obs2obs_CL.out
call obs2obs.exe obs2obs_DJ.in obs2obs_DJ.out
call obs2obs.exe obs2obs_GA.in obs2obs_GA.out
call obs2obs.exe obs2obs_H1.in obs2obs_H1.out
call obs2obs.exe obs2obs_NC.in obs2obs_NC.out
call obs2obs.exe obs2obs_RR.in obs2obs_RR.out
REM call obs2obs.exe obs2obs_SH.in obs2obs_SH.out

cd .\..\OUTPUT\
call obs2obs.exe gsflow_obs2obs.in gsflow_obs2obs.out

cd ..\

