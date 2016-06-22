--------------------------------------------------------------
-- Процедура ins_MaterialLotByCommOrder
IF OBJECT_ID ('dbo.ins_MaterialLotByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByCommOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotByCommOrder]
@COMM_ORDER      NVARCHAR(50),
@EquipmentID     INT
AS
BEGIN

DECLARE @MaterialLotID   INT,
        @MEASURE_TIME    [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50);

SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);
EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = N'0',
                             @Quantity      = NULL,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
EXEC [dbo].[ins_MaterialLotPropertyByCommOrder] @MaterialLotID   = @MaterialLotID,
                                                @COMM_ORDER      = @COMM_ORDER,
                                                @MEASURE_TIME    = @MEASURE_TIME,
                                                @AUTO_MANU_VALUE = N'0';

SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                    @MaterialLotID = @MaterialLotID,
                                    @Command       = N'Print';

END;
GO
