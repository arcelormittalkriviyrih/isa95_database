SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_TakeWeight',N'P') IS NOT NULL
  DROP PROCEDURE [dbo].[ins_KP4_TakeWeight]

GO

-- Call from program Odata (button "Take weight")
-- =============================================
CREATE PROCEDURE [dbo].[ins_KP4_TakeWeight]
   @WorkPerformanceID int,                 --  ID WeightSheet 
   @WeightBridgeID    int,                 --  ID Equipment
   @WeightSheetNumber nvarchar(50),        --  Number WeightSheet 
   @WagonNumber    nvarchar(50),           --  Number wagon
   @WorkResponseDescription  nvarchar(50), --  Number waybill
   @Value      real,		               --  Weight
   @WeightMode nvarchar(20),               --  Mode operation brutto\tara
   @MaterialDefinitionID int,              -- Code scrap (CSH)
   @ReceiverID int,            
   @SenderID int           


AS
BEGIN

 IF @WeightSheetNumber IS NULL or @WeightBridgeID is NULL
      THROW  16, 'Description param required',1;
	  ---RAISERROR ('Description param required',16,1);

     declare @WorkPerform_old int

     IF @WorkPerformanceID=0   --  First weighting, create  WeightSheet
     BEGIN
	     SET @WorkPerform_old=0
		 EXEC [dbo].[ins_KP4_WorkPerformance] @WorkPerformanceID OUTPUT, @WeightSheetNumber, @WeightBridgeID

      --   if @WorkPerformanceID=0  -- если новая отвесная не была создана (была ошибка в проц [ins_KP4_WorkPerformance])
		    --return
	 END

  BEGIN TRANSACTION insKP4_TakeWeight;

  BEGIN TRY 

     IF @WeightMode='Weighting'   ---  operation brutto
     BEGIN
		  EXEC [dbo].[ins_KP4_WeightBrutto]  @WorkPerformanceID, @WagonNumber, @WorkResponseDescription,  @Value, @WeightMode, @MaterialDefinitionID,  @ReceiverID,  @SenderID, @WeightBridgeID
	 END

     IF @WeightMode='Taring'      ---  operation tara
     BEGIN
		  EXEC [dbo].[ins_KP4_WeightTara]    @WorkPerformanceID, @WagonNumber, @WorkResponseDescription,  @Value, @WeightMode
	 END


  COMMIT TRANSACTION  insKP4_TakeWeight; 
  END TRY


  BEGIN CATCH
      ROLLBACK TRANSACTION insKP4_TakeWeight;
	  THROW 16,'Error transaction TakeWeight',1;
	  select 'rollback'                                   ---!!!!!!!!! change!!!

	  IF @WorkPerform_old=0 
		 DELETE FROM  [WorkPerformance] WHERE ID=@WorkPerformanceID

  END CATCH


END


GO