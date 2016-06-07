--------------------------------------------------------------
-- Процедура по номеру контролера на ходит ProductionRequest (в состоянии RequestState=InProgress) 
-- и для него создает запись в следующем наборе таблиц: ProductionResponce, SegmentResponce, MaterialActual, MaterialLot
IF OBJECT_ID ('dbo.ins_MaterialLotByController',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByController;
GO

CREATE PROCEDURE dbo.ins_MaterialLotByController
   @ControllerID   INT
AS
BEGIN
  DECLARE
    @ProductionRequestID  INT,
    @SegmentResponseID    INT,
    @ProductionResponseID INT,
    @MaterialLotID        INT,
    @MaterialActualID     INT,
    @Quantity             INT,
    @now                  DATETIMEOFFSET = CURRENT_TIMESTAMP,
    @err_message          NVARCHAR(255);

  SELECT @ProductionRequestID=sreq.ProductionRequest,
         @Quantity=kl.WEIGHT_CURRENT_VALUE
  FROM dbo.v_kep_logger kl
       INNER JOIN dbo.EquipmentRequirement ereq ON (ereq.EquipmentID=kl.EquipmentID)
       INNER JOIN dbo.SegmentRequirement sreq ON (sreq.ID=ereq.SegmentRequirementID)
       INNER JOIN dbo.ProductionRequest preq ON (preq.ID=sreq.ProductionRequest AND preq.RequestState=N'InProgress')
  WHERE kl.Controller_ID=@ControllerID;

  IF @ProductionRequestID IS NULL
    BEGIN
      SET @err_message = N'Для контроллера №' + CAST(@ControllerID AS NVARCHAR) + ' не найден ProductionRequest в состоянии "InProgress"';
      THROW 60010, @err_message, 1;
    END;

  EXEC dbo.ins_ProductionResponse @ProductionRequestID  = @ProductionRequestID,
                                  @StartTime            = @now,
                                  @EndTime              = @now,
                                  @ResponseState        = N'ToPrint',
                                  @ProductionResponseID = @ProductionResponseID OUTPUT;

  EXEC dbo.ins_SegmentResponse @Description        = NULL,
                               @ActualStartTime    = @now,
                               @ActualEndTime      = @now,
                               @SegmentState       = NULL,
                               @ProductionRequest  = @ProductionRequestID,
                               @ProductionResponse = @ProductionResponseID,
                               @SegmentResponseID  = @SegmentResponseID OUTPUT;

  EXEC dbo.ins_MaterialLot @Description          = NULL,
                           @Status               = NULL,
                           @Quantity             = @Quantity,
                           @MaterialLotID        = @MaterialLotID OUTPUT;

  EXEC dbo.ins_MaterialActual @MaterialLotID     = @MaterialLotID,
                              @Description       = NULL,
                              @Quantity          = NULL,
                              @SegmentResponseID = @SegmentResponseID,
                              @MaterialActualID  = @MaterialActualID OUTPUT
END;
GO
