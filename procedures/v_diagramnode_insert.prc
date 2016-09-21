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

INSERT INTO [dbo].[WorkflowSpecificationNode] ([Description],[NodeType],[WorkflowSpecification],[WorkDefinition])
VALUES (@Description,1,@DiagramID,NULL);

SELECT SCOPE_IDENTITY() as ID;

SELECT @DiagramNodeID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationNode])
SELECT pt.[ID],@json,@DiagramNodeID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO
