SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_ExportJobOrderToSAP',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ExportJobOrderToSAP;
GO

IF OBJECT_ID ('dbo.ins_JobOrderSAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderSAPExport;
GO
--------------------------------------------------------------
-- Используется для создания задания на отправку бирки в САП
CREATE PROCEDURE [dbo].[ins_JobOrderSAPExport]
@MaterialLotID   INT,
@WorkRequestID   INT = NULL
AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255);


   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[WorkRequest])
   VALUES (@JobOrderID,N'SAPExport',N'TODO',CURRENT_TIMESTAMP,@WorkRequestID);
 
   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;

--------------------------------------------------------------
-- Процедура ins_JobOrderToPrint
IF OBJECT_ID ('dbo.ins_JobOrderToPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderToPrint;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderToPrint]
@EquipmentID     INT,
@MaterialLotID   INT,
@Command         NVARCHAR(50),
@CommandRule     NVARCHAR(50) = NULL,
@WorkRequestID   INT = NULL

AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255);

   IF NOT EXISTS (SELECT NULL 
                  FROM [dbo].[Equipment] eq INNER JOIN [dbo].[EquipmentClass] eqc ON (eqc.[ID] = eq.[EquipmentClassID] AND eqc.[Code]=N'PRINTER')
                  WHERE eq.[ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment ID=[' + CAST(@EquipmentID AS NVARCHAR) + N'] is not a PRINTER';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

	 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@EquipmentID;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

   IF @Command = N'Print'
    EXEC dbo.[ins_JobOrderSAPExport]
         @MaterialLotID = @MaterialLotID,
         @WorkRequestID = @WorkRequestID;

END;
GO


--------------------------------------------------------------
-- Процедура upd_MaterialLotProdOrder
IF OBJECT_ID ('dbo.upd_MaterialLotProdOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotProdOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_MaterialLotProdOrder]
@MaterialLotIDs   NVARCHAR(MAX),
@PROD_ORDER       NVARCHAR(50)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID     INT,
        @LinkMaterialLotID INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @LinkMaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   (SELECT @LinkMaterialLotID,[FactoryNumber],N'1',[Quantity]
    FROM [dbo].[MaterialLot] ml
    WHERE ml.[ID]=@MaterialLotID);

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@MaterialLotID,@LinkMaterialLotID,1);

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT mlp.[Value],@LinkMaterialLotID,mlp.[PropertyType]
   FROM [dbo].[MaterialLotProperty] mlp
   WHERE mlp.[MaterialLotID]=@MaterialLotID

   MERGE [dbo].[MaterialLotProperty] mlp
   USING (SELECT pt.ID
          FROM [dbo].[PropertyTypes] pt 
          WHERE (pt.value=N'PROD_ORDER')) pt
   ON (mlp.[MaterialLotID]=@LinkMaterialLotID AND pt.[ID]=mlp.[PropertyType])
   WHEN MATCHED THEN
      UPDATE SET mlp.[Value]=@PROD_ORDER
   WHEN NOT MATCHED THEN
      INSERT ([Value],[MaterialLotID],[PropertyType])
      VALUES (@PROD_ORDER,@LinkMaterialLotID,pt.[ID]);

   EXEC DBO.[ins_JobOrderSAPExport] @MaterialLotID=@LinkMaterialLotID;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_SAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.exec_SAPExport;
GO
--------------------------------------------------------------
-- Используется для выполнения экспорта бирок в САП
CREATE PROCEDURE [dbo].[exec_SAPExport]
AS
BEGIN

	DECLARE @MaterialLotID int, @JobOrderID int;


	DECLARE selMaterialLots CURSOR
	FOR SELECT p.[Value], o.ID
		FROM [dbo].JobOrder AS o, [dbo].[Parameter] AS p, [dbo].[PropertyTypes] AS pt
		WHERE o.ID = p.JobOrder AND 
			  p.PropertyType = pt.ID AND 
			  pt.[Value] = N'MaterialLotID' AND 
			  o.WorkType = N'SAPExport' AND
			  o.DispatchStatus = N'TODO';
	OPEN selMaterialLots;
	FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID = @MaterialLotID;
			update [dbo].JobOrder set DispatchStatus=N'Done' where id=@JobOrderID;
		END TRY
		BEGIN CATCH

			EXEC [dbo].[ins_ErrorLog];
		END CATCH;

		FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID;
	END;
	CLOSE selMaterialLots;
	DEALLOCATE selMaterialLots;
END;

GO


