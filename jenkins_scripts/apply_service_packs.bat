echo %WORKSPACE%
FOR %%i IN ("%WORKSPACE%\service_packs\*.sql") DO sqlcmd -S krr-tst-pahwl02 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i %WORKSPACE%\jenkins_scripts\apply_service_packs.prc 
