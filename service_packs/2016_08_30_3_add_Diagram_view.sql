ALTER TABLE  dbo.WorkflowSpecificationProperty ALTER COLUMN [Value] nvarchar(MAX)
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'JSON',N'JSON');

COMMIT;
GO

IF OBJECT_ID ('dbo.v_Diagram', N'V') IS NOT NULL
   DROP VIEW dbo.v_Diagram;
GO
/*
   View: v_Diagram
    Возвращает список диаграмм
*/
CREATE VIEW dbo.v_Diagram
AS
SELECT d.ID,
       d.Description
FROM dbo.WorkflowSpecification d
GO

IF OBJECT_ID ('dbo.v_DiagramNode', N'V') IS NOT NULL
   DROP VIEW dbo.v_DiagramNode;
GO
/*
   View: v_DiagramNode
    Возвращает список диаграмм.
*/
CREATE VIEW dbo.v_DiagramNode
AS
SELECT d.ID,
       d.Description,
       d.WorkflowSpecification DiagramID,
       p.Value json
FROM [dbo].[WorkflowSpecificationNode] d
     LEFT OUTER JOIN [dbo].[WorkflowSpecificationProperty] p ON (p.WorkflowSpecificationNode=d.ID)
GO

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
GO
