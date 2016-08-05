--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandTakeWeight
	Процедура отправки Взять вес на контроллер.

	Parameters:

		EquipmentID     - ID весов.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeight]
@EquipmentID     INT
AS
BEGIN

DECLARE @JobOrderID    INT,
        @WorkRequestID INT,
	   @TakeWeightLocked [NVARCHAR](50);

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

SELECT @WorkRequestID=jo.[WorkRequest]
FROM [dbo].[JobOrder] jo
WHERE jo.[ID]=@JobOrderID;

SET @TakeWeightLocked=dbo.get_EquipmentPropertyValue(@EquipmentID,N'TAKE_WEIGHT_LOCKED');

IF @TakeWeightLocked NOT IN (N'1')
    EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
								@EquipmentClassPropertyValue = N'TAKE_WEIGHT_LOCKED',
								@EquipmentPropertyValue = N'1';

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_WEIGHT',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
