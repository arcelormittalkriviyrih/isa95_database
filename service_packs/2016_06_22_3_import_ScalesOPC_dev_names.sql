SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE @ScalesEquipmentID INT;

-- MS 250-1 LEFT SIDE
select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='17';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-L.POCKET1',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='18';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-L.POCKET2',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='19';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-L.POCKET3',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='20';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-L.POCKET4',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

-- MS 250-1 RIGHT SIDE
select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='21';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-R.POCKET1',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='22';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-R.POCKET2',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='23';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-R.POCKET3',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

select @ScalesEquipmentID=EquipmentID from dbo.EquipmentProperty p where p.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO') and [Value]='24';
INSERT INTO [dbo].[EquipmentProperty]([Value],[EquipmentID],[ClassPropertyID]) VALUES (N'OPC_LABEL.SPC-1-R.POCKET4',@ScalesEquipmentID,dbo.get_EquipmentClassPropertyByValue(N'OPC_DEVICE_NAME'));

