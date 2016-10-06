CD "%1\service_packs\DML"
FOR %%i IN ("*.sql") DO sqlcmd -S %2 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%1\jenkins_scripts\apply_service_packs.prc" -o "%1\jenkins_scripts\dml.log"