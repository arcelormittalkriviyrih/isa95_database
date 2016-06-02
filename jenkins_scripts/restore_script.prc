DECLARE @restoreFileName VARCHAR(256) -- filename for backup
DECLARE @restoreDatabaseName NVARCHAR(100) -- database name to restore
DECLARE @restoreDbPath NVARCHAR(255) -- database name to restore
--SET @restoreDatabaseName = @DatabaseName + N'_QA';
SET @restoreDatabaseName = N'$(restoreDb)';
SET @restoreDbPath = N'$(restoreDbPath)';
SET @restoreFileName = N'$(backupPath)' + N'\' + N'$(backupFile)'

-- Get the backup file list as a table variable
DECLARE @BackupFiles TABLE(LogicalName nvarchar(128),
                           PhysicalName nvarchar(260),
                           Type char(1),
                           FileGroupName nvarchar(128),
                           Size numeric(20,0),
                           MaxSize numeric(20,0),
                           FileId tinyint,
                           CreateLSN numeric(25,0),
                           DropLSN numeric(25, 0),
                           UniqueID uniqueidentifier,
                           ReadOnlyLSN numeric(25,0),
                           ReadWriteLSN numeric(25,0),
                           BackupSizeInBytes bigint,
                           SourceBlockSize int,
                           FileGroupId int,
                           LogGroupGUID uniqueidentifier,
                           DifferentialBaseLSN numeric(25,0),
                           DifferentialBaseGUID uniqueidentifier,
                           IsReadOnly bit,
                           IsPresent bit,
                           TDEThumbprint varbinary(32));
INSERT @BackupFiles EXEC('RESTORE FILELISTONLY FROM DISK = ''' + @restoreFileName + '''');
--SELECT * FROM  @BackupFiles

-- Create the backup file list as a table variable
DECLARE @NewDatabaseData VARCHAR(MAX);
DECLARE @NewDatabaseLog VARCHAR(MAX);
--DECLARE @tempFileName VARCHAR(MAX)

SELECT @NewDatabaseData = PhysicalName FROM @BackupFiles WHERE Type = 'D';
SELECT @NewDatabaseLog = PhysicalName FROM @BackupFiles WHERE Type = 'L';

--SET @tempFileName = REVERSE(SUBSTRING(REVERSE(@NewDatabaseData),CHARINDEX('.',REVERSE(@NewDatabaseData))+1,CHARINDEX('\',REVERSE(@NewDatabaseData))-CHARINDEX('.',REVERSE(@NewDatabaseData))-1));
--SET @NewDatabaseData = REPLACE(@NewDatabaseData,@tempFileName,@restoreDatabaseName);
SET @NewDatabaseData = @restoreDbPath+@restoreDatabaseName+REVERSE(SUBSTRING(REVERSE(@NewDatabaseData),1,CHARINDEX('.',REVERSE(@NewDatabaseData))));
--SET @tempFileName = REVERSE(SUBSTRING(REVERSE(@NewDatabaseLog),CHARINDEX('.',REVERSE(@NewDatabaseLog))+1,CHARINDEX('\',REVERSE(@NewDatabaseLog))-CHARINDEX('.',REVERSE(@NewDatabaseLog))-1));
--SET @NewDatabaseLog = REPLACE(@NewDatabaseLog,@tempFileName,@restoreDatabaseName + N'_log');
SET @NewDatabaseLog = @restoreDbPath+@restoreDatabaseName+REVERSE(SUBSTRING(REVERSE(@NewDatabaseLog),1,CHARINDEX('.',REVERSE(@NewDatabaseLog))));

DECLARE @LogicalNameData NVARCHAR(128);
DECLARE @LogicalNameLog NVARCHAR(128);

SELECT @LogicalNameData = LogicalName FROM @BackupFiles WHERE Type = 'D';
SELECT @LogicalNameLog = LogicalName FROM @BackupFiles WHERE Type = 'L';

DECLARE @SQL_SCRIPT VARCHAR(MAX);
SET @SQL_SCRIPT = 'IF EXISTS (SELECT NULL FROM master.dbo.sysdatabases WHERE name = N''{NewDatabase}'') ' + char(10) +
                  'BEGIN ' + char(10) +
                  'ALTER DATABASE [{NewDatabase}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE ' + char(10) +
                  'DROP DATABASE [{NewDatabase}] ' + char(10) +
                  'END';
SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{NewDatabase}', @restoreDatabaseName);
PRINT @SQL_SCRIPT
EXECUTE (@SQL_SCRIPT);

PRINT  @restoreFileName

RESTORE DATABASE @restoreDatabaseName FROM DISK = @restoreFileName
WITH REPLACE, RECOVERY,
     MOVE @LogicalNameData TO @NewDatabaseData,
     MOVE @LogicalNameLog TO @NewDatabaseLog

-- Change Logical File Name
SET @SQL_SCRIPT ='
    ALTER DATABASE [{NewDatabase}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    ALTER DATABASE [{NewDatabase}] MODIFY FILE (NAME=N''{DatabaseDataFile}'', NEWNAME=N''{NewDatabase}'');
    ALTER DATABASE [{NewDatabase}] MODIFY FILE (NAME=N''{DatabaseLogFile}'', NEWNAME=N''{NewDatabase}_log'');
    ALTER DATABASE [{NewDatabase}] SET MULTI_USER WITH ROLLBACK IMMEDIATE;';
--SELECT name AS logical_name, physical_name FROM SYS.MASTER_FILES WHERE database_id = DB_ID(N''{NewDatabase}'');

SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{DatabaseDataFile}', @LogicalNameData);
SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{DatabaseLogFile}', @LogicalNameLog);
SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{NewDatabase}', @restoreDatabaseName);
EXECUTE (@SQL_SCRIPT);
