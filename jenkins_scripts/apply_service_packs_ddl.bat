CD "%1\service_packs\DDL"
FOR %%i IN ("*.sql") DO sqlcmd -S %2 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%1\jenkins_scripts\apply_service_packs.prc" -o "%1\jenkins_scripts\ddl_%%i.log"
copy /Y /b "%1\jenkins_scripts\ddl_*.log" "%1\jenkins_scripts\ddl.log"
del "%1\jenkins_scripts\ddl_*.log"