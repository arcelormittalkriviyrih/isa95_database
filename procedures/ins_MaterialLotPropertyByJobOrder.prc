--------------------------------------------------------------
-- Процедура ins_MaterialLotPropertyByJobOrder
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByJobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByJobOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByJobOrder]
@MaterialLotID   INT,
@JobOrderID      INT,
@MEASURE_TIME    NVARCHAR(50),
@AUTO_MANU_VALUE NVARCHAR(50)
AS
BEGIN

   DECLARE @COMM_ORDER   NVARCHAR(50);

   SELECT @COMM_ORDER=pso.[Value]
   FROM [dbo].[v_Parameter_Order] pso
   WHERE pso.[JobOrder]=@JobOrderID;

   EXEC [dbo].[ins_MaterialLotPropertyByCommOrder] @MaterialLotID   = @MaterialLotID,
                                                   @COMM_ORDER      = @COMM_ORDER,
                                                   @MEASURE_TIME    = @MEASURE_TIME,
                                                   @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

END;
GO
