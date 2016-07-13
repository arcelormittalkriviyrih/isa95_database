echo %WORKSPACE%
CD "%WORKSPACE%\tests"
FOR %%i IN ("*.sql") DO sqlcmd -S KRR-SQL-PACLX02 -d KRR-PA-ISA95_PRODUCTION -v FileName="%%i" -i "%WORKSPACE%\tests\apply_test_scripts.prc"