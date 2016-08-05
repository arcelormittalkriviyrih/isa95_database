SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelChangeStatus',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelChangeStatus;
GO
--------------------------------------------------------------

/*
	Procedure: upd_JobOrderPrintLabelChangeStatus
	Используется для смены статуса задания на печать.

	Parameters:
		
		MaterialLotIDs - Айдишники бирок для измениния,
		Status		   - Статус.
		
*/
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


