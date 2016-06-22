--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTara
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTara',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTara;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTara]
@WorkRequestID   INT,
@EquipmentID     INT
AS
BEGIN

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_TARA',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
