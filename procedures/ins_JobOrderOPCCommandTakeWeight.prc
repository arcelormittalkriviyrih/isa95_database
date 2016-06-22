--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeight;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeight]
@WorkRequestID   INT,
@EquipmentID     INT
AS
BEGIN

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_WEIGHT',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
