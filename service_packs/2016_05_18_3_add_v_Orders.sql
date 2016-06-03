-- создаем view
CREATE VIEW [dbo].[v_Orders]
AS
select opr.id,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='STD') as STD,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='LEN') as [LEN],
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='QMIN') as QMIN,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CONTR') as CONTR,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='DIR') as DIR,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='PROD') as PROD,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CLASS') as CLASS,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='STCLASS') as STCLASS,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CHEM') as CHEM,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='DIAM') as DIAM,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='ADR') as ADR,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='ORDER') as [ORDER],
(select f.Name from SegmentParameter sp, PropertyTypes pt, Files f where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='TMPL' and pt.value=f.ID) as TMPL,
(select md.Description from OpMaterialRequirement mr, MaterialDefinition as md where mr.SegmenRequirementID=sr.ID and md.ID=mr.MaterialDefinitionID) as [PROFILE]
from OperationsRequest as opr,
OpSegmentRequirement sr
where opr.ID=sr.OperationsRequest
GO


CREATE VIEW [dbo].[v_OrderProperties]
AS
select sp.ID,pt.Description,sp.Value, sr.OperationsRequest
from SegmentParameter sp, PropertyTypes pt, OpSegmentRequirement sr where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value in ('STD','LED','QMIN','PROD','CLASS','STCLASS','CHEM','DIAM','ADR')
GO