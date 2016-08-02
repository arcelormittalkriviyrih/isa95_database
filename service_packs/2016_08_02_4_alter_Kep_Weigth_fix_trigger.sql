IF OBJECT_ID ('dbo.InsKepWeigthFix',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepWeigthFix];
GO

CREATE TRIGGER [dbo].[InsKepWeigthFix] ON [dbo].[KEP_weigth_fix]
AFTER INSERT
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT OFF;

BEGIN TRY

   DECLARE @AUTO_MANU       BIT, --AUTO_MANU_VALUE,
           @NUMBER_POCKET   INT, --WEIGHT__FIX_NUMERICID
           @TIMESTAMP       DATETIME, --WEIGHT__FIX_TIMESTAMP
           @WEIGHT_FIX      INT, --WEIGHT__FIX_VALUE
           @WEIGHT_OK       BIT, --WEIGHT_OK_VALUE
		   @IDENT		   INT; --WEIGHT__FIX_VALUE

   SELECT @AUTO_MANU=[AUTO_MANU],
          @NUMBER_POCKET=[NUMBER_POCKET],
          @TIMESTAMP=[TIMESTAMP],
          @WEIGHT_FIX=[WEIGHT_FIX],
          @WEIGHT_OK=[WEIGHT_OK],
		@IDENT=[IDENT]
   FROM INSERTED;

   SAVE TRANSACTION insJobOrderPrintLabel;
   IF @WEIGHT_OK=1
      EXEC [dbo].[ins_JobOrderPrintLabelByScalesNo] @SCALES_NO  = @NUMBER_POCKET,
                                                    @TIMESTAMP  = @TIMESTAMP,
                                                    @WEIGHT_FIX = @WEIGHT_FIX,
                                                    @AUTO_MANU  = '0',
													@IDENT	    = @IDENT;
END TRY

BEGIN CATCH
   ROLLBACK TRANSACTION insJobOrderPrintLabel;
   BEGIN TRY
      SAVE TRANSACTION InsErr;
      EXEC [dbo].[ins_ErrorLog];
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION InsErr;
   END CATCH
END CATCH

END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKepWeigthFix]', @order=N'Last', @stmttype=N'INSERT'