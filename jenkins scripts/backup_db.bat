@echo on
cd "C:\Nikama\jenkins_workspace\isa95_database\jenkins scripts"
@setlocal
@set backupDb=B2MML-BatchML
@set restoreDb=B2MML-BatchML_QA
@set backupPath=C:\Nikama\jenkins_workspace\isa95_database\jenkins scripts\Backups
@set restoreDbPath="C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER2012\MSSQL\DATA\"
for /f "tokens=1-4 delims=: " %%a in ('echo %time:~0,8%') do set backupTime=%%a%%b%%c
for /f "tokens=1-4 delims=. " %%a in ('echo %date:~0%') do set backupDate=%%c%%b%%a
@set backupFile=%backupDb%_%backupDate%%backupTime%.BAK
if ERRORLEVEL 1 exit 1
sqlcmd -S MSSQL2014SRV -i backup_script.prc
if ERRORLEVEL 1 exit 1
