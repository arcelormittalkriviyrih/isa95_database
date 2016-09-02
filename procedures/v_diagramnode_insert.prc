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

DECLARE @DiagramNodeID INT;

SET @DiagramNodeID=NEXT VALUE FOR dbo.gen_WorkflowSpecificationNode;

INSERT INTO [dbo].[WorkflowSpecificationNode] ([ID],[Description],[NodeType],[WorkflowSpecification],[WorkDefinition])
VALUES (@DiagramNodeID,@Description,1,@DiagramID,NULL);

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationNode])
SELECT pt.[ID],@json,@DiagramNodeID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO
