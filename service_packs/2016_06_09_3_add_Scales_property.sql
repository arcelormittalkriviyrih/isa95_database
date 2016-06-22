SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE @PrinterEquipmentClassID INT;
		
SELECT @ScalesEquipmentClassID=[ID] FROM [dbo].[EquipmentClass] WHERE [Code]=N'SCALES';

INSERT INTO dbo.EquipmentClassProperty([Description],[Value],[EquipmentClassID]) VALUES (N'Имя OPC устройства в KEP',N'OPC_DEVICE_NAME',@ScalesEquipmentClassID);

