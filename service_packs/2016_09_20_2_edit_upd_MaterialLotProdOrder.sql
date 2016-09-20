--------------------------------------------------------------
-- Процедура upd_MaterialLotProdOrder
IF OBJECT_ID ('dbo.upd_MaterialLotProdOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotProdOrder;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_MaterialLotProdOrder
	Процедура изменения призводственного заказа.

	Parameters:

		MaterialLotIDs - Айдишники бирок для изменения,
		PROD_ORDER     - Производственный заказ.
		
*/
CREATE PROCEDURE [dbo].[upd_MaterialLotProdOrder]
@MaterialLotIDs   NVARCHAR(MAX),
@PROD_ORDER       NVARCHAR(50)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID      INT,
        @LinkMaterialLotID1 INT,
        @LinkMaterialLotID2 INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @LinkMaterialLotID1=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   (SELECT @LinkMaterialLotID1,[FactoryNumber],N'5',-[Quantity]
    FROM [dbo].[MaterialLot] ml
    WHERE ml.[ID]=@MaterialLotID);

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@MaterialLotID,@LinkMaterialLotID1,5);

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT mlp.[Value],@LinkMaterialLotID1,mlp.[PropertyType]
   FROM [dbo].[MaterialLotProperty] mlp
   WHERE mlp.[MaterialLotID]=@MaterialLotID;

   EXEC DBO.[ins_JobOrderSAPExport] @MaterialLotID=@LinkMaterialLotID1;

   SET @LinkMaterialLotID2=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   (SELECT @LinkMaterialLotID2,[FactoryNumber],N'5',[Quantity]
    FROM [dbo].[MaterialLot] ml
    WHERE ml.[ID]=@MaterialLotID);

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@LinkMaterialLotID1,@LinkMaterialLotID2,5);

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT mlp.[Value],@LinkMaterialLotID2,mlp.[PropertyType]
   FROM [dbo].[MaterialLotProperty] mlp
   WHERE mlp.[MaterialLotID]=@LinkMaterialLotID1;

   MERGE [dbo].[MaterialLotProperty] mlp
   USING (SELECT pt.ID
          FROM [dbo].[PropertyTypes] pt 
          WHERE (pt.value=N'PROD_ORDER')) pt
   ON (mlp.[MaterialLotID]=@LinkMaterialLotID2 AND pt.[ID]=mlp.[PropertyType])
   WHEN MATCHED THEN
      UPDATE SET mlp.[Value]=@PROD_ORDER
   WHEN NOT MATCHED THEN
      INSERT ([Value],[MaterialLotID],[PropertyType])
      VALUES (@PROD_ORDER,@LinkMaterialLotID2,pt.[ID]);

   EXEC DBO.[ins_JobOrderSAPExport] @MaterialLotID=@LinkMaterialLotID2;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;
GO
