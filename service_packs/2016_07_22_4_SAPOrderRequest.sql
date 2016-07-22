SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop view [dbo].[v_SAPOrderRequest]
GO 

CREATE VIEW [dbo].[v_SAPOrderRequest]
WITH ENCRYPTION
AS
SELECT p.ID,
	   pt.[Value] PropertyType,
       case pt.[Value]
	   when N'SAP_SERVICE_LOGIN' then DecryptByPassPhrase (N'arcelor',p.[Value])
	   when N'SAP_SERVICE_PASS' then DecryptByPassPhrase (N'arcelor',p.[Value])
	   ELSE p.[Value]
	   end [Value]
FROM JobOrder o,
     [Parameter] p,
     dbo.PropertyTypes pt
WHERE WorkType = 'SAPOrderRequest'
      AND p.JobOrder = o.ID
      AND pt.ID = p.PropertyType;
GO

DROP VIEW [dbo].[v_Parameter_Order]
Go
alter TABLE [dbo].[Parameter] ALTER COLUMN [Value] nVARCHAR(500) NULL;
GO

CREATE VIEW [dbo].[v_Parameter_Order] WITH SCHEMABINDING
AS
SELECT p.[ID], p.[Value], p.[Description], p.[JobOrder], p.[Parameter], p.[PropertyType], er.[EquipmentID]
FROM [dbo].[Parameter] p
     INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=p.[JobOrder] AND jo.[WorkType]=N'Standard')
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=p.[PropertyType] AND pt.[Value]=N'COMM_ORDER')
     INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=p.[JobOrder])

GO