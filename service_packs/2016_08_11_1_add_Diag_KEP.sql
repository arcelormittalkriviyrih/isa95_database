SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'kep_logger'
                AND column_name = 'ALARM')
   ALTER TABLE [dbo].[kep_logger] ADD [ALARM] bit  NULL
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'kep_logger_archive'
                AND column_name = 'ALARM')
   ALTER TABLE [dbo].kep_logger_archive ADD [ALARM] bit  NULL
GO

IF OBJECT_ID('[dbo].[KEP_controller_diag]') IS NULL
BEGIN
	CREATE TABLE [dbo].[KEP_controller_diag](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[Controller_ID] [INT] NOT NULL,	
		[UPS_FAIL] [bit] NOT NULL,		
		[Controller_Last_Connect] [datetime] NOT NULL
	PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END;

GO

IF OBJECT_ID ('dbo.InsKepControllerDiag',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepControllerDiag];
GO

CREATE TRIGGER [dbo].[InsKepControllerDiag] ON [dbo].[KEP_controller_diag]
AFTER INSERT
AS
     BEGIN
         -- SET NOCOUNT ON added to prevent extra result sets from
         -- interfering with SELECT statements.
         SET NOCOUNT ON;

         DECLARE @insertedID INT, @Controller_ID INT;

         SELECT @insertedID = id,
                @Controller_ID = Controller_ID
         FROM INSERTED;

         DELETE FROM [dbo].[KEP_controller_diag]
         WHERE Controller_ID = @Controller_ID
               AND ID != @insertedID;
     END;
GO