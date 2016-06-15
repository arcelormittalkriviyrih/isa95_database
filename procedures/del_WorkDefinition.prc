--------------------------------------------------------------
-- Процедура del_WorkDefinition
IF OBJECT_ID ('dbo.del_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_WorkDefinition]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @WorkDefinitionID   INT,
           @err_message        NVARCHAR(255);

   IF @COMM_ORDER IS NULL
      THROW 60001, N'COMM_ORDER param required', 1;

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.Value=@COMM_ORDER;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DELETE FROM [dbo].[ParameterSpecification]
   WHERE WorkDefinitionID=@WorkDefinitionID;

   DELETE FROM [dbo].[WorkDefinition]
   WHERE ID=@WorkDefinitionID;

END;
GO
