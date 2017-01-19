pushd "%1\service_packs\%3"
SET SQLCMD_ERROR_LEVEL=0;
sqlcmd -S %2 -d KRR-PA-ISA95_PRODUCTION -v FileName="%4" -i "%1\jenkins_scripts\apply_service_packs.prc" -o "%1\jenkins_scripts\%3_%4.log" || (echo Failed script: %3\%4 >> "%1\jenkins_scripts\failed_%3s.log" & SET SQLCMD_ERROR_LEVEL=1)
popd
type "%1\jenkins_scripts\%3_%4.log" >> "%1\jenkins_scripts\output_%3.log"
del "%1\jenkins_scripts\%3_%4.log"
IF %SQLCMD_ERROR_LEVEL% EQU 1 exit /b 1
