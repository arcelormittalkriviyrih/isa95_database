--------------------------------------------------------------
-- Процедура v_DiagramConnection_update
IF OBJECT_ID ('dbo.v_DiagramConnection_update',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramConnection_update;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramConnection_update]
@ID                 INT,
@json               NVARCHAR(MAX),
--@ConnectionType     INT,
@FromNodeID         NVARCHAR(50),
@ToNodeID           NVARCHAR(50),
@DiagramID          INT,
@Description        NVARCHAR(50) = NULL
AS
BEGIN

UPDATE [dbo].[WorkflowSpecificationConnection]
SET [Description]=ISNULL(@Description,[Description]),
    --[ConnectionType]=ISNULL(@ConnectionType,[ConnectionType]),
    [FromNodeID]=ISNULL(@FromNodeID,[FromNodeID]),
    [ToNodeID]=ISNULL(@ToNodeID,[ToNodeID]),
    [WorkflowSpecification]=ISNULL(@DiagramID,[WorkflowSpecification])
WHERE [ID]=@ID;

IF @json IS NULL
   DELETE FROM [dbo].[WorkflowSpecificationProperty]
   WHERE [WorkflowSpecificationConnection]=@ID
     AND EXISTS (SELECT NULL FROM [dbo].[PropertyTypes] pt WHERE (pt.[ID]=[PropertyType]) AND (pt.[Value]=N'JSON'));
ELSE
   BEGIN
      DECLARE @PropertyTypeID INT;

      SELECT @PropertyTypeID=pt.[ID] 
      FROM [dbo].[PropertyTypes] pt
      WHERE (pt.[Value]=N'JSON');

      IF EXISTS (SELECT NULL FROM [dbo].[WorkflowSpecificationProperty] WHERE [WorkflowSpecificationConnection]=@ID AND [PropertyType]=@PropertyTypeID)
         UPDATE [dbo].[WorkflowSpecificationProperty]
         SET [Value]=@json
         WHERE [WorkflowSpecificationConnection]=@ID
           AND [PropertyType]=@PropertyTypeID;
      ELSE
         INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationConnection])
         VALUES (@PropertyTypeID,@json,@ID);
   END;

END;
GO
