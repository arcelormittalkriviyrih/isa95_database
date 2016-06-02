@echo on
cd "C:\Nikama\database_scripts"
@setlocal
@set restoreDb=KRR-PA-ISA95_PRODUCTION
@set backupPath=\\krr-sql-paclx02\KRR-SQL-PACLX02-Backups\Full\KRR-PA-ISA95_PRODUCTION
@set restoreDbPath=c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\
for /f %%i in ('dir "%backupPath%" /b/a-d/od/t:c') do set backupFile=%%i
rem echo DB dump name %backupFile%
if ERRORLEVEL 1 exit 1
rem sqlcmd -S krr-tst-pahwl02 -i backup_script.prc
rem if ERRORLEVEL 1 exit 1
rem sqlcmd -S KRR-SQL-PACLX02 -d KRR-PA-ISA95_PRODUCTION -i restore_script.prc
sqlcmd -S krr-tst-pahwl02 -i restore_script.prc 
rem del /S /Q C:\Nikama\database_scripts\Backups\*
if ERRORLEVEL 1 exit 1
