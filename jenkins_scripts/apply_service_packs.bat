@echo on
cd "%WORKSPACE%\service_packs"
dir DDL\ /B > "%WORKSPACE%\jenkins_scripts\all_files_scripts.txt" && ^
dir DML\ /B >> "%WORKSPACE%\jenkins_scripts\all_files_scripts.txt" && ^
sort "%WORKSPACE%\jenkins_scripts\all_files_scripts.txt" > "%WORKSPACE%\jenkins_scripts\all_files_scripts_sort.log" && ^
del "%WORKSPACE%\jenkins_scripts\all_files_scripts.txt"
if ERRORLEVEL 1 exit 1

SET CMD_ERROR_LEVEL=0;
for /f "tokens=*" %%a in (%WORKSPACE%\jenkins_scripts\all_files_scripts_sort.log) do (
	IF EXIST DDL\%%a (C:\Nikama\SysinternalsSuite\psexec.exe -accepteula -f ^
					  -u %DDL_USER% -p %DDL_PASSWORD% -c "%WORKSPACE%\jenkins_scripts\apply_service_packs_all.bat" %WORKSPACE% %1 ddl %%a || SET CMD_ERROR_LEVEL=1)
	IF EXIST DML\%%a (C:\Nikama\SysinternalsSuite\psexec.exe -accepteula -f ^
					  -u %DML_USER% -p %DML_PASSWORD% -c "%WORKSPACE%\jenkins_scripts\apply_service_packs_all.bat" %WORKSPACE% %1 dml %%a || SET CMD_ERROR_LEVEL=1)
)
IF %CMD_ERROR_LEVEL% EQU 1 exit /b 1
del "%WORKSPACE%\jenkins_scripts\all_files_scripts_sort.log"
if ERRORLEVEL 1 exit 1