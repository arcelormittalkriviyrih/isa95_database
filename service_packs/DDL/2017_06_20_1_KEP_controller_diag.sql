SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.KEP_controller_diag',N'U') IS NOT NULL
   exec sp_rename 'KEP_controller_diag', 'KEP_controller_diag_table';
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u1_KEP_controller_diag' AND object_id = OBJECT_ID('[dbo].[KEP_controller_diag_table]'))
  DROP INDEX [u1_KEP_controller_diag] ON [dbo].[KEP_controller_diag_table]
GO

CREATE UNIQUE INDEX [u1_KEP_controller_diag] ON [dbo].[KEP_controller_diag_table] ([Controller_ID])
GO

IF OBJECT_ID ('dbo.InsKepControllerDiag',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepControllerDiag];
GO

IF OBJECT_ID('dbo.KEP_controller_diag', N'V') IS NOT NULL
    DROP VIEW [dbo].[KEP_controller_diag];
GO

/*
   View: KEP_controller_diag
*/
CREATE VIEW [dbo].[KEP_controller_diag]
AS 
SELECT [id],
       [Controller_ID],
       [UPS_FAIL],
       [Controller_Last_Connect]
FROM [dbo].[KEP_controller_diag_table];
GO


CREATE TRIGGER [dbo].[InsKepControllerDiag_UPDATE] ON [dbo].[KEP_controller_diag]
INSTEAD OF INSERT
AS
BEGIN

   SET NOCOUNT ON;

   MERGE [dbo].[KEP_controller_diag_table] kp
   USING (SELECT * FROM INSERTED) ins ON (ins.[Controller_ID] = kp.[Controller_ID])
   WHEN MATCHED THEN
    UPDATE SET kp.[UPS_FAIL] = ins.[UPS_FAIL],
               kp.[Controller_Last_Connect] = ins.[Controller_Last_Connect]
   WHEN NOT MATCHED THEN
    INSERT ([Controller_ID],[UPS_FAIL],[Controller_Last_Connect])
    VALUES (ins.[Controller_ID],ins.[UPS_FAIL],ins.[Controller_Last_Connect]);

END
GO
