--------------------------------------------------------------
-- Процедура del_CreateOrder
IF OBJECT_ID ('dbo.del_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_Order;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_Order]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID    int,
           @OpSegmentRequirementID int;

   IF @COMM_ORDER IS NULL
      RAISERROR ('COMM_ORDER param required',16,1);

   SELECT @OpSegmentRequirementID=sreq.ID,
          @OperationsRequestID=sreq.OperationsRequest
   FROM [dbo].[OpSegmentRequirement] sreq
        INNER JOIN  [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER' AND sp.Value=@COMM_ORDER);

   IF @OpSegmentRequirementID IS NULL
      RAISERROR ('Order [%s] not found',16,1,@COMM_ORDER);

   DELETE FROM [dbo].[SegmentParameter]
   WHERE OpSegmentRequirement=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OpMaterialRequirement]
   WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

   DELETE [dbo].[OpSegmentRequirement]
   WHERE ID=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OperationsRequest]
   WHERE ID=@OperationsRequestID;

END;
GO
