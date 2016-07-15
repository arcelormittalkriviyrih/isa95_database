SET NOCOUNT ON

:ON ERROR EXIT

DECLARE @sql VARCHAR(1024);
DECLARE selTables CURSOR FOR SELECT N'EXEC ' + ROUTINE_NAME + N';'
                             FROM INFORMATION_SCHEMA.ROUTINES
                             WHERE SPECIFIC_SCHEMA = N'dbo'
                               AND ROUTINE_CATALOG=  N'KRR-PA-ISA95_PRODUCTION'
                               AND ROUTINE_TYPE = N'PROCEDURE'
                               AND UPPER(SPECIFIC_NAME) LIKE 'TEST_%';
OPEN selTables

FETCH NEXT FROM selTables INTO @sql
WHILE @@FETCH_STATUS = 0
BEGIN
 EXEC(@sql)
 --PRINT @sql
 FETCH NEXT FROM selTables INTO @sql
END
CLOSE selTables;
DEALLOCATE selTables;
GO
