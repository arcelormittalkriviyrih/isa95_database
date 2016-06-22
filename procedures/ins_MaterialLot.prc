--------------------------------------------------------------
-- Процедура ins_MaterialLot
IF OBJECT_ID ('dbo.ins_MaterialLot',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLot;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLot]
@FactoryNumber   NVARCHAR(250),
@Status          NVARCHAR(250),
@Quantity        INT,
@MaterialLotID   INT OUTPUT
AS
BEGIN

   SET @MaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   VALUES (@MaterialLotID,@FactoryNumber,@Status,@Quantity);

END;
GO
