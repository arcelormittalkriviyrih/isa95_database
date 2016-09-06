ALTER TABLE [dbo].[WorkflowSpecificationConnection] ALTER COLUMN [FromNodeID] INT NOT NULL;

ALTER TABLE [dbo].[WorkflowSpecificationConnection] ALTER COLUMN [ToNodeID] INT NOT NULL;

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
@FromNodeID         INT,
@ToNodeID           INT,
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

DECLARE @DiagramConnectionID INT;

SET @DiagramConnectionID=NEXT VALUE FOR dbo.gen_WorkflowSpecificationConnection;

INSERT INTO [dbo].[WorkflowSpecificationConnection] ([ID],[Description],[ConnectionType],[FromNodeID],[ToNodeID],[WorkflowSpecification])
VALUES (@DiagramConnectionID,@Description,1,@FromNodeID,@ToNodeID,@DiagramID);

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationConnection])
SELECT pt.[ID],@json,@DiagramConnectionID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO

