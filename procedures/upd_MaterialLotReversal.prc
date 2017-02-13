--------------------------------------------------------------
-- Процедура upd_MaterialLotReversal
IF OBJECT_ID ('dbo.upd_MaterialLotReversal',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotReversal;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_MaterialLotReversal
	Процедура сторнирования бирок.

	Parameters:

		MaterialLotIDs - Айдишники бирок для сторнирования.
		
*/
CREATE PROCEDURE [dbo].[upd_MaterialLotReversal]
@MaterialLotIDs   NVARCHAR(MAX)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID      INT,
        @LinkMaterialLotID1 INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @LinkMaterialLotID1=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   (SELECT @LinkMaterialLotID1,[FactoryNumber],N'6',-[Quantity]
    FROM [dbo].[MaterialLot] ml
    WHERE ml.[ID]=@MaterialLotID);

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@MaterialLotID,@LinkMaterialLotID1,6);

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT mlp.[Value],@LinkMaterialLotID1,mlp.[PropertyType]
   FROM [dbo].[MaterialLotProperty] mlp
   WHERE mlp.[MaterialLotID]=@MaterialLotID;

   EXEC DBO.[ins_JobOrderSAPExport] @MaterialLotID=@LinkMaterialLotID1;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;
GO
