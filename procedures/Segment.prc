
IF OBJECT_ID ('dbo.gen_SegmentResponse',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_SegmentResponse AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу SegmentResponse
IF OBJECT_ID ('dbo.ins_SegmentResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_SegmentResponse;
GO

CREATE PROCEDURE dbo.ins_SegmentResponse
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   @ActualStartTime                    DATETIME,
   @ActualEndTime                      DATETIME,
   --@SegmentResponse                    INT,
   --@RequiredByRequestedSegmentResponse NVARCHAR(50),
   @SegmentState                       NVARCHAR(50),
   @ProductionRequest                  INT,
   @ProductionResponse                 INT,
   @SegmentResponseID                  INT OUTPUT
AS
BEGIN

  IF @SegmentResponseID IS NULL
    SET @SegmentResponseID=NEXT VALUE FOR dbo.gen_SegmentResponse;

  INSERT INTO dbo.SegmentResponse(ID,
                                  Description,
                                  Location,
                                  HierarchyScope,
                                  ActualStartTime,
                                  ActualEndTime,
                                  SegmentResponse,
                                  RequiredByRequestedSegmentResponse,
                                  SegmentState,
                                  ProductionRequest,
                                  ProductionResponse)
                          VALUES (@SegmentResponseID,
                                  @Description,
                                  --@Location,
                                  --@HierarchyScope,
                                  NULL,
                                  NULL,
                                  @ActualStartTime,
                                  @ActualEndTime,
                                  --@SegmentResponse,
                                  --@RequiredByRequestedSegmentResponse,
                                  NULL,
                                  NULL,
                                  @SegmentState,
                                  @ProductionRequest,
                                  @ProductionResponse);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы SegmentResponse
IF OBJECT_ID ('dbo.upd_SegmentResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_SegmentResponse;
GO

CREATE PROCEDURE dbo.upd_SegmentResponse
    @ID                                 INT,
    @Description                        NVARCHAR(50),
    --@Location                           NVARCHAR(50),
    --@HierarchyScope                     HIERARCHYID,
    @ActualStartTime                    DATETIME,
    @ActualEndTime                      DATETIME,
    --@SegmentResponse                    INT,
    --@RequiredByRequestedSegmentResponse NVARCHAR(50),
    @SegmentState                       NVARCHAR(50),
    @ProductionRequest                  INT,
    @ProductionResponse                 INT
AS
BEGIN

  UPDATE dbo.SegmentResponse
  SET Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      ActualStartTime=@ActualStartTime,
      ActualEndTime=@ActualEndTime,
      --SegmentResponse=@SegmentResponse,
      --RequiredByRequestedSegmentResponse=@RequiredByRequestedSegmentResponse,
      SegmentState=@SegmentState,
      ProductionRequest=@ProductionRequest,
      ProductionResponse=@ProductionResponse
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы SegmentResponse
IF OBJECT_ID ('dbo.del_SegmentResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_SegmentResponse;
GO

CREATE PROCEDURE dbo.del_SegmentResponse
    @ID INT
AS
BEGIN

  DELETE FROM dbo.SegmentResponse
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы SegmentResponse
IF OBJECT_ID ('dbo.get_SegmentResponse', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_SegmentResponse;
GO

CREATE FUNCTION dbo.get_SegmentResponse(@ID INT)
RETURNS @retSegmentResponse TABLE (ID                                 INT,
                                   Description                        NVARCHAR(50),
                                   --Location                           NVARCHAR(50),
                                   --HierarchyScope                     HIERARCHYID,
                                   ActualStartTime                    DATETIME,
                                   ActualEndTime                      DATETIME,
                                   --SegmentResponse                    INT,
                                   --RequiredByRequestedSegmentResponse NVARCHAR(50),
                                   SegmentState                       NVARCHAR(50),
                                   ProductionRequest                  INT,
                                   ProductionResponse                 INT)
AS
BEGIN

  INSERT @retSegmentResponse
  SELECT ID,
         Description,
         --Location,
         --HierarchyScope,
         ActualStartTime,
         ActualEndTime,
         --SegmentResponse,
         --RequiredByRequestedSegmentResponse,
         SegmentState,
         ProductionRequest,
         ProductionResponse
  FROM dbo.SegmentResponse
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_SegmentRequirement',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_SegmentRequirement AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу SegmentRequirement
IF OBJECT_ID ('dbo.ins_SegmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_SegmentRequirement;
GO

CREATE PROCEDURE dbo.ins_SegmentRequirement
   @ProductSegmentID                   INT,
   @ProcessSegmentID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   @EarliestStartTime                  DATETIME,
   @LatestEndTime                      DATETIME,
   @Duration                           NVARCHAR(50),
   @ProductionParameter                INT,
   @SegmentRequirement                 INT,
   --@RequiredByRequestedSegmentResponce NVARCHAR(50),
   @SeqmentState                       NVARCHAR(50),
   @ProductionRequest                  INT,
   @SegmentRequirementID               INT OUTPUT
AS
BEGIN

  IF @SegmentRequirementID IS NULL
    SET @SegmentRequirementID=NEXT VALUE FOR dbo.gen_SegmentRequirement;

  INSERT INTO dbo.SegmentRequirement(ID,
                                     ProductSegmentID,
                                     ProcessSegmentID,
                                     Description,
                                     --Location,
                                     --HierarchyScope,
                                     EarliestStartTime,
                                     LatestEndTime,
                                     Duration,
                                     ProductionParameter,
                                     SegmentRequirement,
                                     --RequiredByRequestedSegmentResponce,
                                     SeqmentState,
                                     ProductionRequest)
                             VALUES (@SegmentRequirementID,
                                     @ProductSegmentID,
                                     @ProcessSegmentID,
                                     @Description,
                                     --@Location,
                                     --@HierarchyScope,
                                     @EarliestStartTime,
                                     @LatestEndTime,
                                     @Duration,
                                     @ProductionParameter,
                                     @SegmentRequirement,
                                     --@RequiredByRequestedSegmentResponce,
                                     @SeqmentState,
                                     @ProductionRequest);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы SegmentRequirement
IF OBJECT_ID ('dbo.upd_SegmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_SegmentRequirement;
GO

CREATE PROCEDURE dbo.upd_SegmentRequirement
   @ID                                 INT,
   @ProductSegmentID                   INT,
   @ProcessSegmentID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   @EarliestStartTime                  DATETIME,
   @LatestEndTime                      DATETIME,
   @Duration                           NVARCHAR(50),
   @ProductionParameter                INT,
   @SegmentRequirement                 INT,
   --@RequiredByRequestedSegmentResponce NVARCHAR(50),
   @SeqmentState                       NVARCHAR(50),
   @ProductionRequest                  INT
AS
BEGIN

  UPDATE dbo.SegmentRequirement
  SET ProductSegmentID=@ProductSegmentID,
      ProcessSegmentID=@ProcessSegmentID,
      Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      EarliestStartTime=@EarliestStartTime,
      LatestEndTime=@LatestEndTime,
      Duration=@Duration,
      ProductionParameter=@ProductionParameter,
      SegmentRequirement=@SegmentRequirement,
      --RequiredByRequestedSegmentResponce=@RequiredByRequestedSegmentResponce,
      SeqmentState=@SeqmentState,
      ProductionRequest=@ProductionRequest
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы SegmentRequirement
IF OBJECT_ID ('dbo.del_SegmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_SegmentRequirement;
GO

CREATE PROCEDURE dbo.del_SegmentRequirement
    @ID INT
AS
BEGIN

  DELETE FROM dbo.SegmentRequirement
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы SegmentRequirement
IF OBJECT_ID ('dbo.get_SegmentRequirement', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_SegmentRequirement;
GO

CREATE FUNCTION dbo.get_SegmentRequirement(@ID INT)
RETURNS @retSegmentRequirement TABLE (ID                                 INT,
                                      ProductSegmentID                   INT,
                                      ProcessSegmentID                   INT,
                                      Description                        NVARCHAR(50),
                                      Location                           NVARCHAR(50),
                                      HierarchyScope                     HIERARCHYID,
                                      EarliestStartTime                  DATETIME,
                                      LatestEndTime                      DATETIME,
                                      Duration                           NVARCHAR(50),
                                      ProductionParameter                INT,
                                      SegmentRequirement                 INT,
                                      RequiredByRequestedSegmentResponce NVARCHAR(50),
                                      SeqmentState                       NVARCHAR(50),
                                      ProductionRequest                  INT)
AS
BEGIN

  INSERT @retSegmentRequirement
  SELECT ID,
         ProductSegmentID,
         ProcessSegmentID,
         Description,
         Location,
         HierarchyScope,
         EarliestStartTime,
         LatestEndTime,
         Duration,
         ProductionParameter,
         SegmentRequirement,
         RequiredByRequestedSegmentResponce,
         SeqmentState,
         ProductionRequest
  FROM dbo.SegmentRequirement
  WHERE ID=@ID;

  RETURN;

END;
GO
