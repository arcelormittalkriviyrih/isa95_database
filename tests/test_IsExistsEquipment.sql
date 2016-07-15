--------------------------------------------------------------
-- Процедура test_IsExistsEquipment
IF OBJECT_ID ('dbo.test_IsExistsEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.test_IsExistsEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[test_IsExistsEquipment]
AS
BEGIN

   SET NOCOUNT ON;

   IF NOT EXISTS (SELECT NULL FROM [dbo].[Equipment])
      THROW 60010, '[dbo].[Equipment] table is empty', 1;

END;
GO

