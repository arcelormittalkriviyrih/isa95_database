SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_JobOrderSAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderSAPExport;
GO
--------------------------------------------------------------

/*
	Procedure: ins_JobOrderSAPExport
	Используется для создания задания на отправку бирки в САП.

	Parameters:

		MaterialLotID  - MaterialLot ID,
		WorkRequestID  - WorkRequest ID

	
*/
CREATE PROCEDURE [dbo].[ins_JobOrderSAPExport]
@MaterialLotID   INT,
@WorkRequestID   INT = NULL
AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255),
		   @LinkedServer  NVARCHAR(50);

   SET @LinkedServer=(SELECT top 1 Parameter from WorkDefinition where WORKType='SAPExport' order by ID desc);

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[WorkRequest],CommandRule)
   VALUES (@JobOrderID,N'SAPExport',N'TODO',CURRENT_TIMESTAMP,@WorkRequestID,@LinkedServer);
 
   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;

GO

