ALTER VIEW [dbo].[v_KP4_PackagingUnitsProperty]
AS

select top (100) percent
	pu.ID,
	pu.[Description]	as [Wagon],
	pup.[Description]	as [Parameter],
	pup.Value,
	pup.ValueTime

from 
	dbo.PackagingUnits pu,
	dbo.PackagingUnitsProperty pup
where 
	pu.ID = pup.PackagingUnitsID
    and pup.[Description]=N'Вес тары' 
order by pup.ID