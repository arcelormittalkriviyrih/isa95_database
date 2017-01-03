SET ANSI_NULLS ON;
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON;
GO

update dbo.EquipmentClassProperty set Description=N'SAP linked server' where [Value]=N'SAP_LINKED_SERVER';

GO