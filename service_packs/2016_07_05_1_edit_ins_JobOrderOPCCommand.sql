--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeightByCommOrder
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeightByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeightByCommOrder;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTaraByCommOrder
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeight;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeight]
@EquipmentID     INT
AS
BEGIN

DECLARE @JobOrderID    INT,
        @WorkRequestID INT;

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

SELECT @WorkRequestID=jo.[WorkRequest]
FROM [dbo].[JobOrder] jo
WHERE jo.[ID]=@JobOrderID;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_WEIGHT',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTara
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTara',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTara;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTara]
@EquipmentID     INT
AS
BEGIN

DECLARE @JobOrderID    INT,
        @WorkRequestID INT;

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

SELECT @WorkRequestID=jo.[WorkRequest]
FROM [dbo].[JobOrder] jo
WHERE jo.[ID]=@JobOrderID;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_TARA',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
