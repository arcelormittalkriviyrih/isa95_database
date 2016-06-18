--------------------------------------------------------------
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_WorkRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequest;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkRequest]
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
@DEVIATION       NVARCHAR(50)

AS
BEGIN

   DECLARE @WorkRequestID INT;

   SET @WorkRequestID=NEXT VALUE FOR [dbo].[gen_WorkRequest];
   INSERT INTO [dbo].[WorkRequest] ([ID],[StartTime])
   VALUES (@WorkRequestID,CURRENT_TIMESTAMP);

   EXEC [dbo].[ins_JobOrderInit] @WorkRequestID = @WorkRequestID,
                                 @EquipmentID   = @EquipmentID,
                                 @ProfileID     = @ProfileID,
                                 @COMM_ORDER    = @COMM_ORDER,
                                 @LENGTH        = @LENGTH,
                                 @BAR_WEIGHT    = @BAR_WEIGHT,
                                 @BAR_QUANTITY  = @BAR_QUANTITY,
                                 @MAX_WEIGHT    = @MAX_WEIGHT,
                                 @MIN_WEIGHT    = @MIN_WEIGHT,
                                 @SAMPLE_WEIGHT = @SAMPLE_WEIGHT,
                                 @SAMPLE_LENGTH = @SAMPLE_LENGTH,
                                 @DEVIATION     = @DEVIATION;


END;
GO
