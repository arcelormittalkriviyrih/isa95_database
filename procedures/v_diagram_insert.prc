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
