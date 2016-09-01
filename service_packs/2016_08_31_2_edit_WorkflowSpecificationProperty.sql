ALTER TABLE [dbo].[WorkflowSpecificationProperty] ADD [WorkflowSpecification] INT NULL
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecification]
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
       d.Description,
       p.Value json
FROM dbo.WorkflowSpecification d
     LEFT OUTER JOIN [dbo].[WorkflowSpecificationProperty] p ON (p.WorkflowSpecification=d.ID)
GO
