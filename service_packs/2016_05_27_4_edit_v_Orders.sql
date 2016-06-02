SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--тест
IF OBJECT_ID ('dbo.v_Orders', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_Orders];
GO

CREATE VIEW [dbo].[v_Orders]
AS
select opr.id,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='ORDER') as [ORDER],
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CONTR') as CONTR,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='DIR') as DIR,
(select f.Name from SegmentParameter sp, PropertyTypes pt, Files f where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='TEMPLATE' and sp.value=f.ID) as TMPL
from OperationsRequest as opr,
OpSegmentRequirement sr
where opr.ID=sr.OperationsRequest


GO

update PropertyTypes set [Value]='TEMPLATE' where [Value]='TMPL';
GO