SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintJobOrders', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobOrders];
GO
/*
   View: v_PrintJobOrders
   Возвращает список JobOrder for Printiig.
*/
CREATE VIEW [dbo].[v_PrintJobOrders]
AS
SELECT jo.ID,
            DispatchStatus,		
		  Command,
		  CommandRule,		  
		  ep.[Value] PrinterIP
     FROM dbo.JobOrder jo, OpEquipmentRequirement oer, dbo.EquipmentProperty ep, dbo.EquipmentClassProperty ecp
	 Where WorkType=N'Print'
	 and jo.ID=oer.JobOrderID
	 and ep.EquipmentID=oer.EquipmentID
	 and ecp.ID = ep.ClassPropertyID
	 and ecp.[Value]=N'PRINTER_IP';
GO