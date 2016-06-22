--------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTaraByCommOrder
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTaraByCommOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTaraByCommOrder]
@COMM_ORDER    NVARCHAR(50),
@EquipmentID   INT
AS
BEGIN

   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[v_Parameter_Order] po
        INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
   WHERE po.[Value]=@COMM_ORDER
     AND po.[EquipmentID]=@EquipmentID;

   EXEC [dbo].[ins_JobOrderOPCCommandTakeTara] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID;

END;
GO
