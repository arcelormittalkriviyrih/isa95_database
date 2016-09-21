
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

DECLARE @DiagramID INT;

INSERT INTO [dbo].[WorkflowSpecification] ([Description])
VALUES (@Description);

SELECT SCOPE_IDENTITY() as ID;

SELECT @DiagramID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecification])
SELECT pt.[ID],@json,@DiagramID
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


INSERT INTO [dbo].[WorkflowSpecificationConnection] ([Description],[ConnectionType],[FromNodeID],[ToNodeID],[WorkflowSpecification])
VALUES (@Description,1,@FromNodeID,@ToNodeID,@DiagramID);

SELECT SCOPE_IDENTITY() as ID;

SELECT @DiagramConnectionID=SCOPE_IDENTITY();

INSERT INTO [dbo].[WorkflowSpecificationProperty]([PropertyType],[Value],[WorkflowSpecificationConnection])
SELECT pt.[ID],@json,@DiagramConnectionID
FROM [dbo].[PropertyTypes] pt WHERE pt.[Value]=N'JSON';

END;
GO