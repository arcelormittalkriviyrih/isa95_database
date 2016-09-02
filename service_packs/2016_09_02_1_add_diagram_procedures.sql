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
     LEFT OUTER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=N'JSON')
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
     LEFT OUTER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=N'JSON')
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
     LEFT OUTER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=N'JSON')
GO

--------------------------------------------------------------
-- Процедура v_Diagram_insert
IF OBJECT_ID ('dbo.v_Diagram_insert',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_Diagram_insert;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_Diagram_insert]
@Json          NVARCHAR(MAX),
@Description   NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @DiagramID INT;

SET @DiagramID=NEXT VALUE FOR dbo.gen_WorkflowSpecification;

INSERT INTO [dbo].[WorkflowSpecification] ([ID],[Description])
VALUES (@DiagramID,@Description);

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecification])
SELECT pt.[ID],@Json,@DiagramID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO

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

--------------------------------------------------------------
-- Процедура v_Diagram_delete
IF OBJECT_ID ('dbo.v_Diagram_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_Diagram_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_Diagram_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecification]
WHERE [ID]=@ID;

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecification]=@ID;

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
@FromNodeID              NVARCHAR(50),
@ToNodeID                NVARCHAR(50),
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

--------------------------------------------------------------
-- Процедура v_DiagramConnection_delete
IF OBJECT_ID ('dbo.v_DiagramConnection_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramConnection_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramConnection_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecificationConnection]
WHERE [ID]=@ID;

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecificationConnection]=@ID;

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

DECLARE @DiagramNodeID INT;

SET @DiagramNodeID=NEXT VALUE FOR dbo.gen_WorkflowSpecificationNode;

INSERT INTO [dbo].[WorkflowSpecificationNode] ([ID],[Description],[NodeType],[WorkflowSpecification],[WorkDefinition])
VALUES (@DiagramNodeID,@Description,1,@DiagramID,NULL);

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationNode])
SELECT pt.[ID],@json,@DiagramNodeID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO

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

--------------------------------------------------------------
-- Процедура v_DiagramNode_delete
IF OBJECT_ID ('dbo.v_DiagramNode_delete',N'P') IS NOT NULL
   DROP PROCEDURE dbo.v_DiagramNode_delete;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[v_DiagramNode_delete]
@ID   INT
AS
BEGIN

DELETE FROM [dbo].[WorkflowSpecificationNode]
WHERE [ID]=@ID;

DELETE FROM [dbo].[WorkflowSpecificationProperty]
WHERE [WorkflowSpecificationNode]=@ID;

END;
GO
