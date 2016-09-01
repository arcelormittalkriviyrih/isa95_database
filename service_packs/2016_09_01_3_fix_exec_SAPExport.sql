SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_SAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.exec_SAPExport;
GO
--------------------------------------------------------------
/*
	Procedure: exec_SAPExport
	Используется для выполнения экспорта бирок в САП.
*/

CREATE PROCEDURE [dbo].[exec_SAPExport]
AS
BEGIN

	DECLARE @MaterialLotID int, @JobOrderID int, @LinkedServer NVARCHAR(50);


	DECLARE selMaterialLots CURSOR
	FOR SELECT p.[Value], o.ID, o.CommandRule
		FROM [dbo].JobOrder AS o, [dbo].[Parameter] AS p, [dbo].[PropertyTypes] AS pt
		WHERE o.ID = p.JobOrder AND 
			  p.PropertyType = pt.ID AND 
			  pt.[Value] = N'MaterialLotID' AND 
			  o.WorkType = N'SAPExport' AND
			  o.DispatchStatus = N'TODO';
	OPEN selMaterialLots;
	FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID = @MaterialLotID, @LinkedServer = @LinkedServer;
			update [dbo].JobOrder set DispatchStatus=N'Done',EndTime=CURRENT_TIMESTAMP where id=@JobOrderID;
		END TRY
		BEGIN CATCH

			EXEC [dbo].[ins_ErrorLog];
		END CATCH;

		FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
	END;
	CLOSE selMaterialLots;
	DEALLOCATE selMaterialLots;
END;

GO


