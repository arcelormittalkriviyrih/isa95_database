echo %WORKSPACE%
CD "%WORKSPACE%\service_packs\DML"
FOR %%i IN ("*.sql") DO sqlcmd -S %SERVER_NAME% -d KRR-PA-ISA95_PRODUCTION -U %DML_USER% -P %DML_PASSWORD% -v FileName="%%i" -i "%WORKSPACE%\jenkins_scripts\apply_service_packs.prc"