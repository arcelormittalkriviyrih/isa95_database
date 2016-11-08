USE [KRR-PA-ISA95_PRODUCTION]
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_PackagingUnitsProperty',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_PackagingUnitsProperty;
GO

SET ANSI_PADDING OFF
GO
 

CREATE VIEW [dbo].[v_KP4_PackagingUnitsProperty]
AS

select top (100) percent
	pu.ID,
	pu.[Description]	as [Wagon],
	pup.[Description]	as [Parameter],
	pup.Value
from 
	dbo.PackagingUnits pu,
	dbo.PackagingUnitsProperty pup
where 
	pu.ID = pup.PackagingUnitsID
and pup.PackagingDefinitionPropertyID in (2)
order by pup.ID

GO


