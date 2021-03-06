CD "%1\service_packs\DML"
del "%1\jenkins_scripts\failed_dmls.log"
SET SQLCMD_ERROR_LEVEL=0;
FOR %%i IN ("*.sql") DO (sqlcmd -S %2 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%1\jenkins_scripts\apply_service_packs.prc" -o "%1\jenkins_scripts\dml_%%i.log" || (echo Failed script: %%i >> "%1\jenkins_scripts\failed_dmls.log" & SET SQLCMD_ERROR_LEVEL=1))
copy /Y /b "%1\jenkins_scripts\dml_*.log" "%1\jenkins_scripts\output_dml.log"
del "%1\jenkins_scripts\dml_*.log"
IF %SQLCMD_ERROR_LEVEL% EQU 1 exit /b 1