
DECLARE @sql1 VARCHAR(1024);
DECLARE selTables1 CURSOR FOR SELECT N'ALTER TABLE [dbo].[WorkflowSpecificationNode] DROP CONSTRAINT ['+dc.NAME+N']'
                              FROM sys.default_constraints dc
                                   INNER JOIN sys.columns c ON c.default_object_id = dc.object_id
                              WHERE dc.parent_object_id IN (OBJECT_ID('WorkflowSpecificationNode'))
                                AND c.name = N'ID';
OPEN selTables1

FETCH NEXT FROM selTables1 INTO @sql1
WHILE @@FETCH_STATUS = 0
BEGIN
 PRINT @sql1
 EXEC(@sql1)
 FETCH NEXT FROM selTables1 INTO @sql1
END
CLOSE selTables1;
DEALLOCATE selTables1;
GO



ALTER TABLE [dbo].[WorkflowSpecificationProperty] DROP CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNode]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeFrom]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeTo]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] DROP CONSTRAINT [PK_WorkflowSpecificationNode]
GO

ALTER TABLE [dbo].[WorkflowSpecificationNode] DROP COLUMN ID
GO

ALTER TABLE [dbo].[WorkflowSpecificationNode] ADD ID INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[WorkflowSpecificationNode] ADD CONSTRAINT [PK_WorkflowSpecificationNode] PRIMARY KEY ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNode] FOREIGN KEY([WorkflowSpecificationNode])
REFERENCES [dbo].[WorkflowSpecificationNode] ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationNode]
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeFrom] FOREIGN KEY([FromNodeID])
REFERENCES [dbo].[WorkflowSpecificationNode] ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection] CHECK CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeFrom]
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeTo] FOREIGN KEY([ToNodeID])
REFERENCES [dbo].[WorkflowSpecificationNode] ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection] CHECK CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecificationNodeTo]
GO