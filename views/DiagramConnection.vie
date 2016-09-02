IF OBJECT_ID ('dbo.v_DiagramConnection', N'V') IS NOT NULL
   DROP VIEW dbo.v_DiagramConnection;
GO
/*
   View: v_DiagramConnection
    Возвращает список диаграмм
*/
CREATE VIEW dbo.v_DiagramConnection
AS
SELECT d.ID,
       d.Description,
       d.FromNodeID,
       d.ToNodeID,
       d.WorkflowSpecification DiagramID,
       p.Value json       
FROM [dbo].[WorkflowSpecificationConnection] d
     LEFT OUTER JOIN [dbo].[WorkflowSpecificationProperty] p ON (p.WorkflowSpecificationConnection=d.ID)
     LEFT OUTER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=N'JSON')
GO
