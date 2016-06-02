rem cd "C:\Nikama\database_scripts"
rem echo %WORKSPACE%

FOR %%i IN ("C:\Nikama\jenkins_workspace\isa95_database\service_packs\*.sql") DO sqlcmd -S krr-tst-pahwl02 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i C:\Nikama\jenkins_workspace\isa95_database\jenkins scripts\apply_service_packs.prc 
