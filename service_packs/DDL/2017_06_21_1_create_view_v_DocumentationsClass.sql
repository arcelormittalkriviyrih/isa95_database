SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_DocumentationsClass',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_DocumentationsClass];
GO

/*
   View: v_DocumentationsClass
   Виды документов
*/
create view [dbo].[v_DocumentationsClass]
as
select
	 DC.[ID]
	,DC.[Description]
	,DC.[ParentID]
	,DC1.[Description] as [ParentDescription]
from [dbo].[DocumentationsClass] DC
inner join [dbo].[DocumentationsClass] DC1
on DC.ParentID = DC1.ID
--order by PC.[ParentID], PC.[ID]

GO