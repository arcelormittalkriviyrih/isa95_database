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
