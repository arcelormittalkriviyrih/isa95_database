echo %WORKSPACE%
CD "%WORKSPACE%\service_packs\DML"
FOR %%i IN ("*.sql") DO runas %DDL_USER%\%DDL_PASSWORD% sqlcmd -S %SERVER_NAME% -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%WORKSPACE%\jenkins_scripts\apply_service_packs.prc"