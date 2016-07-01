echo %WORKSPACE%
CD "%WORKSPACE%\service_packs"
FOR %%i IN ("*.sql") DO sqlcmd -S krr-tst-pahwl02 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%WORKSPACE%\jenkins_scripts\apply_service_packs.prc"