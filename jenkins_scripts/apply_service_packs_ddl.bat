echo %WORKSPACE%
CD "%WORKSPACE%\service_packs\DDL"
FOR %%i IN ("*.sql") DO sqlcmd -S %SERVER_NAME% -d KRR-PA-ISA95_PRODUCTION -U %DDL_USER% -P %DDL_PASSWORD% -v FileName="%%i" -i "%WORKSPACE%\jenkins_scripts\apply_service_packs.prc"