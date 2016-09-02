--------------------------------------------------------------
-- Процедура v_Diagram_update
IF OBJECT_ID ('dbo.v_Diagram_update',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_Diagram_update;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_Diagram_update]
@ID            INT,
@json          NVARCHAR(MAX),
@Description   NVARCHAR(50)
AS
BEGIN

UPDATE [dbo].[WorkflowSpecification]
SET [Description]=ISNULL(@Description,[Description])
WHERE ID=@ID;

IF @json IS NULL
   DELETE FROM [dbo].[WorkflowSpecificationProperty]
   WHERE [WorkflowSpecification]=@ID
     AND EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] pt WHERE (pt.[ID]=[PropertyType]) AND (pt.[Value]=N'JSON'));
ELSE
   BEGIN
      DECLARE @PropertyTypeID INT;

      SELECT @PropertyTypeID=pt.[ID] 
      FROM [dbo].[PropertyTypes] pt
      WHERE (pt.[Value]=N'JSON');

      IF EXISTS (SELECT NULL FROM [dbo].[WorkflowSpecificationProperty] WHERE [WorkflowSpecification]=@ID AND [PropertyType]=@PropertyTypeID)
         UPDATE [dbo].[WorkflowSpecificationProperty]
         SET [Value]=@json
         WHERE [WorkflowSpecification]=@ID
           AND [PropertyType]=@PropertyTypeID;
      ELSE
         INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecification])
         VALUES (@PropertyTypeID,@json,@ID);
   END;

END;
GO
