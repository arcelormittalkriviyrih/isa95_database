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


