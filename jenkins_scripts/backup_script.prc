SET NOCOUNT ON

:On Error exit

DECLARE @DatabaseName NVARCHAR(100) -- database name
--DECLARE @filepath VARCHAR(256) -- path for backup files
DECLARE @backupFileName VARCHAR(256) -- filename for backup
--DECLARE @fileDate NVARCHAR(100) -- used for file name

-- specify database backup directory
--SET @filepath = N'$(BackupPath)';

-- specify filename format
--SELECT @fileDate = N'$(DBName)' + N'_' + CONVERT(VARCHAR(20),GETDATE(),112) + REPLACE(CONVERT(VARCHAR(20),GETDATE(),108),':','');

DECLARE db_cursor CURSOR FOR SELECT name
                             FROM master.dbo.sysdatabases
                             WHERE name IN (N'$(backupDb)')

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS=0
BEGIN
   SET @backupFileName = N'$(backupPath)' + N'\' + N'$(backupFile)';
   BACKUP DATABASE @DatabaseName TO DISK = @backupFileName

   FETCH NEXT FROM db_cursor INTO @DatabaseName
END

CLOSE db_cursor
DEALLOCATE db_cursor
