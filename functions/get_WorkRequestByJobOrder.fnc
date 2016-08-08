--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_WorkRequestByJobOrder', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_WorkRequestByJobOrder;
GO

/*
   Function: get_WorkRequestByJobOrder
   
   Получает Work Request по Job Order.

   Parameters:

      JobOrderID - Job Order ID
     
   Returns:

      Work Request ID.

*/
CREATE FUNCTION dbo.get_WorkRequestByJobOrder(@JobOrderID INT)
RETURNS INT
AS
BEGIN
   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[JobOrder] jo
   WHERE jo.[ID]=@JobOrderID;

   RETURN @WorkRequestID;
END
GO