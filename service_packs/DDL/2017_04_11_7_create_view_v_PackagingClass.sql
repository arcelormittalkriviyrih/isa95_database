

IF OBJECT_ID ('dbo.v_PackagingClass',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_PackagingClass];
GO

/*
   View: v_PackagingClass
   Виды вагонов
*/
create view [dbo].[v_PackagingClass]
as
select
	 PC.[ID]
	,PC.[Description]
	,PC.[ParentID]
	,PC1.[Description] as [ParentDescription]
from [dbo].[PackagingClass] PC
inner join [dbo].[PackagingClass] PC1
on PC.ParentID = PC1.ID
--order by PC.[ParentID], PC.[ID]

GO