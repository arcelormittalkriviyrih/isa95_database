IF EXISTS (SELECT NULL
           FROM information_schema.columns
           WHERE table_name = 'KEP_logger'
             AND column_name = 'WEIGHT_FIX')
   ALTER TABLE [dbo].[KEP_logger] DROP COLUMN [WEIGHT_FIX];
GO

IF EXISTS (SELECT NULL
           FROM information_schema.columns
           WHERE table_name = 'KEP_logger'
             AND column_name = 'WEIGHT_OK')
   ALTER TABLE [dbo].[KEP_logger] DROP COLUMN [WEIGHT_OK];
GO

IF OBJECT_ID ('dbo.InsKeplogger',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKeplogger];
GO

IF OBJECT_ID('[dbo].[KEP_weigth_fix]') IS NOT NULL
   DROP TABLE [dbo].[KEP_weigth_fix]
GO

/****** Object:  Table [dbo].[KEP_weigth_fix]    Script Date: 01.07.2016 12:05:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[KEP_weigth_fix](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[AUTO_MANU] [bit] NOT NULL,
	[NUMBER_POCKET] [int] NOT NULL,
	[TIMESTAMP] [datetime] NOT NULL,
	[WEIGHT_FIX] [int] NOT NULL,
	[WEIGHT_OK] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_KEP_weigth_fix' AND object_id = OBJECT_ID('[dbo].[KEP_weigth_fix]'))
   DROP INDEX [i1_KEP_weigth_fix] ON [dbo].[KEP_weigth_fix]
GO

CREATE INDEX [i1_KEP_weigth_fix] ON [dbo].[KEP_weigth_fix] ([NUMBER_POCKET]) INCLUDE ([TIMESTAMP],[ID])
GO

CREATE TRIGGER [dbo].[InsKepWeigthFix] ON [dbo].[KEP_weigth_fix]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @AUTO_MANU       BIT, --AUTO_MANU_VALUE,
           @NUMBER_POCKET   INT, --WEIGHT__FIX_NUMERICID
           @TIMESTAMP       DATETIME, --WEIGHT__FIX_TIMESTAMP
           @WEIGHT_FIX      INT, --WEIGHT__FIX_VALUE
           @WEIGHT_OK       BIT,
           @WEIGHT_OK_PREV  BIT; --WEIGHT_OK_VALUE

   SELECT @AUTO_MANU=[AUTO_MANU],
          @NUMBER_POCKET=[NUMBER_POCKET],
          @TIMESTAMP=[TIMESTAMP],
          @WEIGHT_FIX=[WEIGHT_FIX],
          @WEIGHT_OK=[WEIGHT_OK]
   FROM INSERTED;

   SELECT @WEIGHT_OK_PREV=ww.[WEIGHT_OK]
   FROM (SELECT ROW_NUMBER() OVER (PARTITION BY wf.[NUMBER_POCKET] ORDER BY wf.[TIMESTAMP] DESC, wf.[ID] DESC) RowNumber,
                [WEIGHT_OK]
         FROM [dbo].[KEP_weigth_fix] wf
         WHERE wf.[NUMBER_POCKET]=@NUMBER_POCKET) ww
   WHERE ww.RowNumber=1;

   IF @WEIGHT_OK_PREV IS NOT NULL AND @WEIGHT_OK<>@WEIGHT_OK_PREV AND @WEIGHT_OK=1
      EXEC [KRR-SQL-PACLX02-PALBP].[KRR-PA-ISA95_PRODUCTION].[dbo].[ins_JobOrderPrintLabelByControllerNo] @CONTROLLER_NO = @NUMBER_POCKET,
                                                                                                          @TIMESTAMP     = @TIMESTAMP,
                                                                                                          @WEIGHT_FIX    = @WEIGHT_FIX,
                                                                                                          @AUTO_MANU     = @AUTO_MANU;
END
GO