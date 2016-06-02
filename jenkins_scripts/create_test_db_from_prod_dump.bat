@echo on
cd %WORKSPACE%
@setlocal
@set restoreDb=KRR-PA-ISA95_PRODUCTION
@set backupPath=\\krr-sql-paclx02\KRR-SQL-PACLX02-Backups\Full\KRR-PA-ISA95_PRODUCTION
@set restoreDbPath=c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\
for /f %%i in ('dir "%backupPath%" /b/a-d/od/t:c') do set backupFile=%%i
rem echo DB dump name %backupFile%
if ERRORLEVEL 1 exit 1
sqlcmd -S krr-tst-pahwl02 -i restore_script.prc 
if ERRORLEVEL 1 exit 1
