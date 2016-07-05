IF OBJECT_ID ('dbo.InsKepWeigthFix',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsKepWeigthFix];
GO

CREATE TRIGGER [dbo].[InsKepWeigthFix] ON [dbo].[KEP_weigth_fix]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @AUTO_MANU       BIT, --AUTO_MANU_VALUE,
           @NUMBER_POCKET   INT, --WEIGHT__FIX_NUMERICID
           @TIMESTAMP       DATETIME, --WEIGHT__FIX_TIMESTAMP
           @WEIGHT_FIX      INT, --WEIGHT__FIX_VALUE
           @WEIGHT_OK       BIT; --WEIGHT_OK_VALUE

   SELECT @AUTO_MANU=[AUTO_MANU],
          @NUMBER_POCKET=[NUMBER_POCKET],
          @TIMESTAMP=[TIMESTAMP],
          @WEIGHT_FIX=[WEIGHT_FIX],
          @WEIGHT_OK=[WEIGHT_OK]
   FROM INSERTED;

   IF @WEIGHT_OK=1
      EXEC [KRR-SQL-PACLX02-PALBP].[KRR-PA-ISA95_PRODUCTION].[dbo].[ins_JobOrderPrintLabelByControllerNo] @CONTROLLER_NO = @NUMBER_POCKET,
                                                                                                          @TIMESTAMP     = @TIMESTAMP,
                                                                                                          @WEIGHT_FIX    = @WEIGHT_FIX,
                                                                                                          @AUTO_MANU     = @AUTO_MANU;
END
GO

EXEC sp_settriggerorder @triggername=N'[dbo].[InsKepWeigthFix]', @order=N'Last', @stmttype=N'INSERT'
