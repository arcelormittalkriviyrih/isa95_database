--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByCommOrder
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByCommOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByCommOrder]
@MaterialLotID   INT,
@COMM_ORDER      NVARCHAR(50),
@MEASURE_TIME    NVARCHAR(50),
@AUTO_MANU_VALUE NVARCHAR(50)
AS
BEGIN

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT ps.[Value],pt.[ID]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
        INNER JOIN [dbo].[v_ParameterSpecification_Order] pso ON (pso.WorkDefinitionID=ps.[WorkDefinitionID] AND pso.[Value]=@COMM_ORDER)
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO
