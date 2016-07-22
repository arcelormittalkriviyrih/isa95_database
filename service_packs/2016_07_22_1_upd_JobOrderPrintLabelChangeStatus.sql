SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelChangeStatus',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelChangeStatus;
GO
--------------------------------------------------------------
-- Используется для смены статуса задания на печать
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelChangeStatus]
@MaterialLotIDs   NVARCHAR(MAX),
@Status NVARCHAR(50)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID     INT,
	   @JobOrderID	    INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @JobOrderID = (SELECT max(p.JobOrder)
         FROM Parameter p,
              PropertyTypes pt,
              JobOrder jo
         WHERE pt.ID = p.PropertyType
               AND pt.[Value] = N'MaterialLotID'
               AND jo.ID = p.JobOrder			   
			   and jo.WorkType=N'Print'
				and p.[Value]=cast(@MaterialLotID as nvarchar));

    IF @JobOrderID IS NOT NULL
	   update dbo.JobOrder set DispatchStatus=@Status where ID=@JobOrderID;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;

GO


SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelReprint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelReprint;
GO
--------------------------------------------------------------
-- Используется повторной отправки бирок на печать
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelReprint] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'ToPrint';
     END;

GO


SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelCancel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelCancel;
GO
--------------------------------------------------------------
-- Используется для отмены задания на печать
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelCancel] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'Done';
     END;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

DROP VIEW [dbo].[v_MaterialLot]
GO

CREATE VIEW [dbo].[v_MaterialLot]
AS
WITH PrintStatus
     AS (SELECT MAX(jo.DispatchStatus) DispatchStatus,
                p.[Value] MaterialLotID
         FROM Parameter p,
              PropertyTypes pt,
              JobOrder jo
         WHERE pt.ID = p.PropertyType
               AND pt.[Value] = N'MaterialLotID'
               AND jo.ID = p.JobOrder			   	
			   AND jo.WorkType=N'Print'	
         GROUP BY p.[Value])
     SELECT *,
            CASE [Status]
                WHEN '0'
                THEN N'Печать'
                WHEN '1'
                THEN N'Перемаркировка'
                WHEN '2'
                THEN N'Сортировка'
                WHEN '3'
                THEN N'Отбраковка'
                WHEN '4'
                THEN N'Разделение пачки'
            END StatusName,
            (CASE ps.DispatchStatus
                 WHEN N'Done'
                 THEN CAST(1 AS BIT)
                 WHEN N'ToPrint'
                 THEN CAST(0 AS BIT)
                 ELSE NULL
             END) isPrinted
     FROM [dbo].[MaterialLot] mlp
          LEFT OUTER JOIN PrintStatus ps ON ps.MaterialLotID = cast(mlp.ID as nvarchar);
GO