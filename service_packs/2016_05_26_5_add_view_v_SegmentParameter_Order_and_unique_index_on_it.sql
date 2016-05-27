IF OBJECT_ID ('dbo.v_SegmentParameter_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_SegmentParameter_Order];
GO

CREATE VIEW [dbo].[v_SegmentParameter_Order] WITH SCHEMABINDING
AS
SELECT sp.ID, sp.[Value], sp.[Description], sp.OperationsSegment, sp.Parameter, sp.OpSegmentRequirement, sp.PropertyType
FROM [dbo].[SegmentParameter] sp
     INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'ORDER')
GO

CREATE UNIQUE CLUSTERED INDEX [u_SegmentParameter_Order] ON [dbo].[v_SegmentParameter_Order] (Value)
GO