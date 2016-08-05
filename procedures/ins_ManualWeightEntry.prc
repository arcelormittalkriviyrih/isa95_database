SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_ManualWeightEntry',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ManualWeightEntry;
GO
--------------------------------------------------------------

/*
	Procedure: ins_ManualWeightEntry
	Используется для ручного ввода веса.

	Parameters:

		EquipmentID     - ID весов,
		Quantity        - Значение веса.

*/
CREATE PROCEDURE [dbo].[ins_ManualWeightEntry] @EquipmentID INT,
                                               @Quantity    INT
AS
     BEGIN
         IF @Quantity IS NULL THROW 60001, N'Параметр "Вес" обязательный', 1;
         IF @EquipmentID IS NULL THROW 60001, N'Параметр "EquipmentID" обязательный', 1;
         EXEC dbo.ins_MaterialLotByEquipment
              @EquipmentID = @EquipmentID,
              @Quantity = @Quantity;
     END;
GO