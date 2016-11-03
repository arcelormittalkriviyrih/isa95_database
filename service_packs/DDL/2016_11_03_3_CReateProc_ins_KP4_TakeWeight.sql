USE [KRR-PA-ISA95_PRODUCTION]
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_KP4_TakeWeight',N'P') IS NOT NULL
  DROP PROCEDURE dbo.ins_KP4_TakeWeight;
GO



/****** Object:  StoredProcedure [dbo].[ins_KP4_TakeWeight]    Script Date: 31.10.2016 16:43:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	  RAISERROR ('Description param required',16,1);

 
  BEGIN TRANSACTION insKP4_TakeWeight;

  BEGIN TRY 

     ---- получить вес контроллера???
  --   SELECT TOP 1 Value=[Weight]   
	 --FROM [KRR-PA-ISA95_SteelSchedule1].[dbo].[KEP_Analytics_Weight]
  --   WHERE [ID_Scales]=@WeightBridgeID  and [stabilizing_weight]=1 and [Weight_OK]=1
  --   order by id desc
   
     IF @WorkPerformanceID=0   --  First weighting, create  WeightSheet
     BEGIN
		EXEC [dbo].[ins_KP4_WorkPerformance] @WorkPerformanceID OUTPUT, @WeightSheetNumber, @WeightBridgeID
	 END

     IF @WeightMode='Weighting'   ---  operation brutto
     BEGIN
		  EXEC [dbo].[ins_KP4_WeightBrutto]  @WorkPerformanceID, @WagonNumber, @WorkResponseDescription,  @Value, @WeightMode, @MaterialDefinitionID,  @ReceiverID,  @SenderID 
	 END

     IF @WeightMode='Taring'      ---  operation tara
     BEGIN
		  EXEC [dbo].[ins_KP4_WeightTara]    @WorkPerformanceID, @WagonNumber, @WorkResponseDescription,  @Value, @WeightMode
	 END


  COMMIT TRANSACTION  insKP4_TakeWeight; 
  END TRY


  BEGIN CATCH
      ROLLBACK TRANSACTION insKP4_TakeWeight;
	  RAISERROR ('Error transaction TakeWeight',16,1);
	  select 'rollback' ---!!!!!!!!! change!!!
  END CATCH


END
GO