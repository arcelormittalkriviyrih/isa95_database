--------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------

/*
	Procedure: ins_MaterialLotByEquipment
	Используется для тестовой печати и для ручной печати с вводом кол-ва.

	Parameters:

		EquipmentID     - ID весов,
		Quantity        - Значение веса.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID   INT,
@Quantity      INT = NULL
AS
BEGIN

DECLARE @MaterialLotID    INT,
        @WorkDefinitionID INT,
        @AUTO_MANU_VALUE [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50),
        @Status          [NVARCHAR](250),
	    @JobOrderID      INT,
        @WorkType	     [NVARCHAR](50),
		@CREATE_MODE	 [NVARCHAR](50);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';
SET @WorkType = [dbo].[get_CurrentWorkType](@EquipmentID);
SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SET @CREATE_MODE = N'Тестовая печать';

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      SET @AUTO_MANU_VALUE=N'1';
      SET @Quantity=dbo.get_RoundedWeightByEquipment(@Quantity,@EquipmentID);
	  SET @CREATE_MODE = N'Печать с ручным вводом веса'; --Используется в интерфейсе на странице построения статистики для фильтрации бирок введенных вручную
   END;

IF @WorkType IN (N'Sort',N'Reject')	     
    SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');	   
ELSE 
    SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);

IF @WorkType IN(N'Separate')
    BEGIN
        DECLARE @LinkFactoryNumber NVARCHAR(12);
        SET @LinkFactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
        SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
        EXEC dbo.ins_MaterialLotWithLinks
            @FactoryNumber = @FactoryNumber,
            @Status = @Status,
            @Quantity = @Quantity,
            @LinkFactoryNumber = @LinkFactoryNumber,
            @MaterialLotID = @MaterialLotID OUTPUT;
                                             
									
    END;
ELSE
    BEGIN        
        EXEC dbo.ins_MaterialLot
            @FactoryNumber = @FactoryNumber,
            @Status = @Status,
            @Quantity = @Quantity,
            @MaterialLotID = @MaterialLotID OUTPUT;
    END;    

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50),
              @NEMERA       NVARCHAR(50);
      SET @MEASURE_TIME=FORMAT(CURRENT_TIMESTAMP, 'dd.MM.yyyy HH:mm:ss');
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');      
      SET @NEMERA=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'NEMERA');
      
	 EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID,
                                                           @NEMERA           = @NEMERA,
														   @CREATE_MODE		 = @CREATE_MODE;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;

IF @WorkType = N'Separate'
    EXEC [dbo].[set_DecreasePacksLeft] @EquipmentID=@EquipmentID;
IF @WorkType IN (N'Sort',N'Reject')
    EXEC dbo.set_StandardMode @EquipmentID=@EquipmentID; 

END;
GO
