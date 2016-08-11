SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID('dbo.upd_PrinterStatus', N'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.upd_PrinterStatus;
    END;
GO

/*
	Procedure: upd_PrinterStatus
	Процедура обновляет статус принтера

	Parameters:
		PrinterNo	    - идентификатор принтера,
		PrinterStatus - статус принтера.

		
*/

CREATE PROCEDURE [dbo].[upd_PrinterStatus]
@PrinterNo   NVARCHAR(50),
@PrinterStatus        NVARCHAR(50)
AS
BEGIN
   DECLARE @PrinterID          INT;

   SET @PrinterID = (SELECT ID from Equipment e where dbo.get_EquipmentPropertyValue(e.id,N'PRINTER_NO') = @PrinterNo);

   IF @PrinterID IS NOT NULL  
     EXEC dbo.[upd_EquipmentProperty] @EquipmentID = @PrinterID,
                                      @EquipmentClassPropertyValue = N'PRINTER_STATUS',
                                      @EquipmentPropertyValue = @PrinterStatus;

END;

GO


