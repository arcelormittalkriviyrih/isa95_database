--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMinWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMinWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMinWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandMinWeight
	Процедура отправки минимального веса на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandMinWeight]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF ISNUMERIC(@TagValue)=0
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'WEIGHT_SP_MIN',
                                    @TagType       = N'Float',
                                    @TagValue      = @TagValue;

END;
GO
