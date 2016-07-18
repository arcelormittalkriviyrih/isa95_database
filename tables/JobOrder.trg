IF OBJECT_ID ('dbo.InsJobOrder',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsJobOrder];
GO


CREATE TRIGGER [dbo].[InsJobOrder] ON [dbo].[JobOrder]
AFTER INSERT
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @JobOrderID        INT,
           @WorkType          NVARCHAR(50),
           @Command           NVARCHAR(50);
           --@DispatchStatus    NVARCHAR(50),
           --@OldDispatchStatus NVARCHAR(50)
		   

   SELECT @JobOrderID=[ID],
          @WorkType=[WorkType],
          @Command=[Command]
		  --,@DispatchStatus=[DispatchStatus]
   FROM INSERTED;

   /*SELECT @OldDispatchStatus=[DispatchStatus]
   FROM DELETED*/

   IF @WorkType=N'Print' AND @Command=N'Print'-- AND (@OldDispatchStatus<>N'Done' AND @DispatchStatus=N'Done')
      EXEC [KRR-SQL-PACLX02-PALBP].[KRR-PA-ISA95_PRODUCTION].[dbo].[ins_ExportJobOrderToSAP] @JobOrderID=@JobOrderID;
END

GO

