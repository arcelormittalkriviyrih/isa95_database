
IF OBJECT_ID ('dbo.v_WGT_PackagingUnitsProperty',N'V') IS NOT NULL
  DROP VIEW dbo.v_WGT_PackagingUnitsProperty;
GO

/*
   View: v_WGT_PackagingUnitsProperty
   Возвращает свойства вагонов (тара, грузоподъемность и т.д.)
*/

create view [dbo].[v_WGT_PackagingUnitsProperty]
as

select
	 PUP.[ID]
	,PU.[ID]			as [PackagingUnitsID]
	,PU.[Description]	as [Wagon]
	,PUP.[Description]	as [Parameter]
	,PUP.[Value]
	,PUP.[ValueTime]
from [dbo].[PackagingUnits] PU
join [dbo].[PackagingUnitsProperty] PUP
on PU.[ID] = PUP.[PackagingUnitsID]

GO


