DECLARE @sql VARCHAR(1024);
DECLARE selTables CURSOR FOR SELECT N'ALTER TABLE [dbo].[WorkflowSpecification] DROP CONSTRAINT ['+dc.NAME+N']'
                             FROM sys.default_constraints dc INNER JOIN sys.columns c ON c.default_object_id = dc.object_id
                             WHERE dc.parent_object_id IN (OBJECT_ID('WorkflowSpecification'))
                               AND c.name = N'ID';
OPEN selTables

FETCH NEXT FROM selTables INTO @sql
WHILE @@FETCH_STATUS = 0
BEGIN
 PRINT @sql
 EXEC(@sql)
 FETCH NEXT FROM selTables INTO @sql
END
CLOSE selTables;
DEALLOCATE selTables;
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty] DROP CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecification]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecification]
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] DROP CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecification]
GO
ALTER TABLE [dbo].[WorkflowSpecification] DROP CONSTRAINT [PK_WorkflowSpecification]
GO

ALTER TABLE [dbo].[WorkflowSpecification] DROP COLUMN ID
GO

ALTER TABLE [dbo].[WorkflowSpecification] ADD ID INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[WorkflowSpecification] ADD CONSTRAINT [PK_WorkflowSpecification] PRIMARY KEY ([ID])
GO

DELETE FROM [dbo].[WorkflowSpecificationProperty]
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecification]
GO

DELETE FROM [dbo].[WorkflowSpecificationConnection]
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] CHECK CONSTRAINT [FK_WorkflowSpecificationConnection_WorkflowSpecification]
GO

DELETE FROM [dbo].[WorkflowSpecificationNode]
GO

ALTER TABLE [dbo].[WorkflowSpecificationNode]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecification] FOREIGN KEY([WorkflowSpecification])
REFERENCES [dbo].[WorkflowSpecification] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationNode] CHECK CONSTRAINT [FK_WorkflowSpecificationNode_WorkflowSpecification]
GO

DECLARE @sql1 VARCHAR(1024);
DECLARE selTables1 CURSOR FOR SELECT N'ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP CONSTRAINT ['+dc.NAME+N']'
                              FROM sys.default_constraints dc
                                   INNER JOIN sys.columns c ON c.default_object_id = dc.object_id
                              WHERE dc.parent_object_id IN (OBJECT_ID('WorkflowSpecificationConnection'))
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

ALTER TABLE [dbo].[WorkflowSpecificationProperty] DROP CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnection]
GO
ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP CONSTRAINT [PK_WorkflowSpecificationConnection]
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection] DROP COLUMN ID
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection] ADD ID INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[WorkflowSpecificationConnection] ADD CONSTRAINT [PK_WorkflowSpecificationConnection] PRIMARY KEY ([ID])
GO

ALTER TABLE [dbo].[WorkflowSpecificationProperty]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnection] FOREIGN KEY([WorkflowSpecificationConnection])
REFERENCES [dbo].[WorkflowSpecificationConnection] ([ID])
GO
ALTER TABLE [dbo].[WorkflowSpecificationProperty] CHECK CONSTRAINT [FK_WorkflowSpecificationProperty_WorkflowSpecificationConnection]
GO


--------------------------------------------------------------
-- Процедура v_Diagram_insert
IF OBJECT_ID ('dbo.v_Diagram_insert',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_Diagram_insert;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_Diagram_insert]
@json          NVARCHAR(MAX),
@Description   NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @ID INT;

INSERT INTO [dbo].[WorkflowSpecification] ([Description])
VALUES (@Description);

SELECT @ID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecification])
SELECT pt.[ID],@json,@ID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO

--------------------------------------------------------------
-- Процедура v_DiagramNode_insert
IF OBJECT_ID ('dbo.v_DiagramNode_insert',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramNode_insert;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramNode_insert]
--@NodeType              INT,
@DiagramID INT,
@json                  NVARCHAR(MAX),
--@WorkDefinition        INT = NULL,
@Description           NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @ID INT;

INSERT INTO [dbo].[WorkflowSpecificationNode] ([Description],[NodeType],[WorkflowSpecification],[WorkDefinition])
VALUES (@Description,1,@DiagramID,NULL);

SELECT @ID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationNode])
SELECT pt.[ID],@json,@ID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO

--------------------------------------------------------------
-- Процедура v_DiagramConnection_insert
IF OBJECT_ID ('dbo.v_DiagramConnection_insert',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramConnection_insert;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramConnection_insert]
--@ConnectionType          INT,
@FromNodeID              INT,
@ToNodeID                INT,
@DiagramID               INT,
@json                    NVARCHAR(MAX),
@Description             NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @ID INT;


INSERT INTO [dbo].[WorkflowSpecificationConnection] ([Description],[ConnectionType],[FromNodeID],[ToNodeID],[WorkflowSpecification])
VALUES (@Description,1,@FromNodeID,@ToNodeID,@DiagramID);

SELECT @ID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationConnection])
SELECT pt.[ID],@json,@ID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO
