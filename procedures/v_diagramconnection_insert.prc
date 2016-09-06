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
