cd "C:\Nikama\database_scripts"
rem echo %WORKSPACE%
for /f "tokens=1-4 delims=: " %%a in ('echo %time:~0,8%') do set mytime=%%a-%%b-%%c
rem @set LOGFILE="log.%DATE%_%mytime%.txt"

rem FOR %%i IN ("%WORKSPACE%\service_packs\*.sql") DO sqlcmd -U vimas -P mercury -S MSSQL2014SRV -d B2MML-BatchML -v FileName="%%i" -i C:\Nikama\database_scripts\start.prc >> %LOGFILE%
FOR %%i IN ("C:\Nikama\jenkins_workspace\isa95_database\service_packs\*.sql") DO sqlcmd -S krr-tst-pahwl02 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i C:\Nikama\database_scripts\apply_service_packs.prc 
