--------------------------------------------------------------
-- Процедура del_CreateOrder
IF OBJECT_ID ('dbo.del_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_CreateOrder;
GO

CREATE PROCEDURE [dbo].[del_CreateOrder]
@ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID    int,
           @OpSegmentRequirementID int;

   IF @ORDER IS NULL
      RAISERROR ('ORDER param required',16,1);

   SELECT @OpSegmentRequirementID=sreq.ID,
          @OperationsRequestID=sreq.OperationsRequest
   FROM [dbo].[OpSegmentRequirement] sreq
        INNER JOIN  [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'ORDER' AND sp.Value=@ORDER);

   IF @OpSegmentRequirementID IS NULL
      RAISERROR ('Order [%s] not found',16,1,@ORDER);

   DELETE FROM [dbo].[SegmentParameter]
   WHERE OpSegmentRequirement=@OpSegmentRequirementID;

   DELETE [dbo].[OpSegmentRequirement]
   WHERE ID=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OperationsRequest]
   WHERE ID=@OperationsRequestID;

END;
GO
