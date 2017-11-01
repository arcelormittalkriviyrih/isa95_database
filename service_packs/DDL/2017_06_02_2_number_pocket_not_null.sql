SET NUMERIC_ROUNDABORT OFF;
GO

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_kep_logger_timestamp' AND object_id = OBJECT_ID('[dbo].[KEP_logger]'))
   DROP INDEX [i1_kep_logger_timestamp] ON [dbo].[KEP_logger]
GO

IF EXISTS (SELECT NULL  FROM information_schema.TABLES
              WHERE table_name = 'KEP_logger'
                AND table_type = 'BASE TABLE')
ALTER TABLE [dbo].[KEP_logger] ALTER COLUMN [NUMBER_POCKET] INT NOT NULL;
GO

  
IF EXISTS (SELECT NULL  FROM information_schema.TABLES
              WHERE table_name = 'KEP_logger'
                AND table_type = 'BASE TABLE')
CREATE NONCLUSTERED INDEX [i1_kep_logger_timestamp] ON [dbo].[KEP_logger]
(
	[TIMESTAMP] ASC,
	[NUMBER_POCKET] ASC
)
INCLUDE ( 	[WEIGHT_CURRENT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
    

  