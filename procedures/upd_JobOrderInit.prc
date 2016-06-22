--------------------------------------------------------------
-- Процедура upd_JobOrderInit
IF OBJECT_ID ('dbo.upd_JobOrderInit',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderInit;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_JobOrderInit]
@WorkRequestID   INT,
@EquipmentID     INT,
@ProfileID       INT,
@COMM_ORDER      NVARCHAR(50),
@LENGTH          NVARCHAR(50),
@BAR_WEIGHT      NVARCHAR(50),
@BAR_QUANTITY    NVARCHAR(50),
@MAX_WEIGHT      NVARCHAR(50),
@MIN_WEIGHT      NVARCHAR(50),
@SAMPLE_WEIGHT   NVARCHAR(50),
@SAMPLE_LENGTH   NVARCHAR(50),
@DEVIATION       NVARCHAR(50),
@SANDWICH_MODE   NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50)


AS
BEGIN

   EXEC [dbo].[ins_JobOrderInit] @WorkRequestID   = @WorkRequestID,
                                 @EquipmentID     = @EquipmentID,
                                 @ProfileID       = @ProfileID,
                                 @COMM_ORDER      = @COMM_ORDER,
                                 @LENGTH          = @LENGTH,
                                 @BAR_WEIGHT      = @BAR_WEIGHT,
                                 @BAR_QUANTITY    = @BAR_QUANTITY,
                                 @MAX_WEIGHT      = @MAX_WEIGHT,
                                 @MIN_WEIGHT      = @MIN_WEIGHT,
                                 @SAMPLE_WEIGHT   = @SAMPLE_WEIGHT,
                                 @SAMPLE_LENGTH   = @SAMPLE_LENGTH,
                                 @DEVIATION       = @DEVIATION,
                                 @SANDWICH_MODE   = @SANDWICH_MODE,
                                 @AUTO_MANU_VALUE = @AUTO_MANU_VALUE;

END;
GO

