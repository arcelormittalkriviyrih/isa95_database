--------------------------------------------------------------
-- Процедура v_DiagramNode_update
IF OBJECT_ID ('dbo.v_DiagramNode_update',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramNode_update;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramNode_update]
@ID                INT,
@json              NVARCHAR(MAX),
--@NodeType          INT = NULL,
@DiagramID         INT = NULL,
--@WorkDefinition    INT = NULL,
@Description       NVARCHAR(50) = NULL
AS
BEGIN

UPDATE [dbo].[WorkflowSpecificationNode]
SET [Description]=ISNULL(@Description,[Description]),
    --[NodeType]=ISNULL(@NodeType,[NodeType]),
    [WorkflowSpecification]=ISNULL(@DiagramID,[WorkflowSpecification])
    --[WorkDefinition]=ISNULL(@WorkDefinition,[WorkDefinition])
WHERE [ID]=@ID;

IF @json IS NULL
   DELETE FROM [dbo].[WorkflowSpecificationProperty]
   WHERE [WorkflowSpecificationNode]=@ID
     AND EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] pt WHERE (pt.[ID]=[PropertyType]) AND (pt.[Value]=N'JSON'));
ELSE
   BEGIN
      DECLARE @PropertyTypeID INT;

      SELECT @PropertyTypeID=pt.[ID] 
      FROM [dbo].[PropertyTypes] pt
      WHERE (pt.[Value]=N'JSON');

      IF EXISTS (SELECT NULL FROM [dbo].[WorkflowSpecificationProperty] WHERE [WorkflowSpecificationNode]=@ID AND [PropertyType]=@PropertyTypeID)
         UPDATE [dbo].[WorkflowSpecificationProperty]
         SET [Value]=@json
         WHERE [WorkflowSpecificationNode]=@ID
           AND [PropertyType]=@PropertyTypeID;
      ELSE
         INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationNode])
         VALUES (@PropertyTypeID,@json,@ID);
   END;

END;
GO
