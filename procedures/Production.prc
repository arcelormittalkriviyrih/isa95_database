USE [B2MML-BatchML]
GO

IF OBJECT_ID ('dbo.gen_ProductionResponse',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ProductionResponse AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу ProductionResponse
IF OBJECT_ID ('dbo.ins_ProductionResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ProductionResponse;
GO

CREATE PROCEDURE dbo.ins_ProductionResponse
    @ProductionRequestID  INT,
    --@Location             NVARCHAR(50),
    --@HierarchyScope       HIERARCHYID,
    @StartTime            DATETIME,
    @EndTime              DATETIME,
    @ResponseState        NVARCHAR(50),
    --@ProductionPerfomance INT
    @ProductionResponseID INT OUTPUT
AS
BEGIN

  IF @ProductionResponseID IS NULL
    SET @ProductionResponseID=NEXT VALUE FOR dbo.gen_ProductionResponse;

  INSERT INTO dbo.ProductionResponse(ID,
                                     ProductionRequestID,
                                     Location,
                                     HierarchyScope,
                                     StartTime,
                                     EndTime,
                                     ResponseState,
                                     ProductionPerfomance)
                             VALUES (@ProductionResponseID,
                                     @ProductionRequestID,
                                     --@Location,
                                     --@HierarchyScope,
                                     N'Location',
                                     hierarchyid::GetRoot(),
                                     @StartTime,
                                     @EndTime,
                                     @ResponseState,
                                     --@ProductionPerfomance
                                     NULL);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы ProductionResponse
IF OBJECT_ID ('dbo.upd_ProductionResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_ProductionResponse;
GO

CREATE PROCEDURE dbo.upd_ProductionResponse
    @ID                   INT,
    @ProductionRequestID  INT,
    --@Location             NVARCHAR(50),
    --@HierarchyScope       HIERARCHYID,
    @StartTime            DATETIME,
    @EndTime              DATETIME,
    @ResponseState        NVARCHAR(50)--,
    --@ProductionPerfomance INT
AS
BEGIN

  UPDATE dbo.ProductionResponse
  SET ProductionRequestID=@ProductionRequestID,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      StartTime=@StartTime,
      EndTime=@EndTime,
      ResponseState=@ResponseState--,
      --ProductionPerfomance=@ProductionPerfomance
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы ProductionResponse
IF OBJECT_ID ('dbo.del_ProductionResponse',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_ProductionResponse;
GO

CREATE PROCEDURE dbo.del_ProductionResponse
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionResponse
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы ProductionResponse
IF OBJECT_ID ('dbo.get_ProductionResponse', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_ProductionResponse;
GO

CREATE FUNCTION dbo.get_ProductionResponse(@ID INT)
RETURNS @retProductionResponse TABLE (ID                   INT PRIMARY KEY NOT NULL,
                                      ProductionRequestID  INT,
                                      --Location             NVARCHAR(50),
                                      --HierarchyScope       HIERARCHYID,
                                      StartTime            DATETIME,
                                      EndTime              DATETIME,
                                      ResponseState        NVARCHAR(50)--,
                                      --ProductionPerfomance INT
                                     )
AS
BEGIN

  INSERT @retProductionResponse
  SELECT ID,
         ProductionRequestID,
         --Location,
         --HierarchyScope,
         StartTime,
         EndTime,
         ResponseState--,
         --ProductionPerfomance
  FROM dbo.ProductionResponse
  WHERE ID=@ID;

  RETURN;

END;
GO

IF OBJECT_ID ('dbo.gen_ProductionRequest',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ProductionRequest AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу ProductionRequest
IF OBJECT_ID ('dbo.ins_ProductionRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ProductionRequest;
GO

CREATE PROCEDURE dbo.ins_ProductionRequest
   @Description         NVARCHAR(50),
   --@Location            NVARCHAR(50),
   --@HierarchyScope      HIERARCHYID,
   @StartTime           DATETIME,
   @EndTime             DATETIME,
   @Priority            NVARCHAR(50),
   @RequestState        NVARCHAR(50),
   @ProductionSchedule  INT,
   @ProductionRequestID INT OUTPUT
AS
BEGIN

  IF @ProductionRequestID IS NULL
    SET @ProductionRequestID=NEXT VALUE FOR dbo.gen_ProductionRequest;

  INSERT INTO dbo.ProductionRequest(ID,
                                    Description,
                                    Location,
                                    HierarchyScope,
                                    StartTime,
                                    EndTime,
                                    Priority,
                                    RequestState,
                                    ProductionSchedule)
                            VALUES (@ProductionRequestID,
                                    @Description,
                                    --@Location,
                                    --@HierarchyScope,
                                     N'Location',
                                     hierarchyid::GetRoot(),
                                    @StartTime,
                                    @EndTime,
                                    @Priority,
                                    @RequestState,
                                    @ProductionSchedule);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы ProductionRequest
IF OBJECT_ID ('dbo.upd_ProductionRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_ProductionRequest;
GO

CREATE PROCEDURE dbo.upd_ProductionRequest
   @ID                   INT,
   @Description         NVARCHAR(50),
   --@Location            NVARCHAR(50),
   --@HierarchyScope      HIERARCHYID,
   @StartTime           DATETIME,
   @EndTime             DATETIME,
   @Priority            NVARCHAR(50),
   @RequestState        NVARCHAR(50),
   @ProductionSchedule  INT
AS
BEGIN

  UPDATE dbo.ProductionRequest
  SET Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      StartTime=@StartTime,
      EndTime=@EndTime,
      Priority=@Priority,
      RequestState=@RequestState,
      ProductionSchedule=@ProductionSchedule
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы ProductionRequest
IF OBJECT_ID ('dbo.del_ProductionRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_ProductionRequest;
GO

CREATE PROCEDURE dbo.del_ProductionRequest
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionRequest
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы ProductionRequest
IF OBJECT_ID ('dbo.get_ProductionRequest', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_ProductionRequest;
GO

CREATE FUNCTION dbo.get_ProductionRequest(@ID INT)
RETURNS @retProductionRequest TABLE (ID                 INT PRIMARY KEY NOT NULL,
                                     Description        NVARCHAR(50),
                                     Location           NVARCHAR(50),
                                     HierarchyScope     HIERARCHYID,
                                     StartTime          DATETIME,
                                     EndTime            DATETIME,
                                     Priority           NVARCHAR(50),
                                     RequestState       NVARCHAR(50),
                                     ProductionSchedule INT)
AS
BEGIN

  INSERT @retProductionRequest
  SELECT ID,
         Description,
         Location,
         HierarchyScope,
         StartTime,
         EndTime,
         Priority,
         RequestState,
         ProductionSchedule
  FROM dbo.ProductionRequest
  WHERE ID=@ID;

  RETURN;

END;
GO

IF OBJECT_ID ('dbo.gen_ProductionParameter',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ProductionParameter AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу ProductionParameter
IF OBJECT_ID ('dbo.ins_ProductionParameter',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ProductionParameter;
GO

CREATE PROCEDURE dbo.ins_ProductionParameter
    @ProductSegmentID      INT,
    @ProcessSegmentID      INT,
    @Parameter             NVARCHAR(50),
    @ProductionParameterID INT OUTPUT
AS
BEGIN

  IF @ProductionParameterID IS NULL
    SET @ProductionParameterID=NEXT VALUE FOR dbo.gen_ProductionParameter;

  INSERT INTO dbo.ProductionParameter(ID,
                                      ProductSegmentID,
                                      ProcessSegmentID,
                                      Parameter)
                              VALUES (@ProductionParameterID,
                                      @ProductSegmentID,
                                      @ProcessSegmentID,
                                      @Parameter);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы ProductionParameter
IF OBJECT_ID ('dbo.upd_ProductionParameter',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_ProductionParameter;
GO

CREATE PROCEDURE dbo.upd_ProductionParameter
    @ID               INT,
    @ProductSegmentID INT,
    @ProcessSegmentID INT,
    @Parameter        NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.ProductionParameter
  SET ProductSegmentID=@ProductSegmentID,
      ProcessSegmentID=@ProcessSegmentID,
      Parameter=@Parameter
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы ProductionParameter
IF OBJECT_ID ('dbo.del_ProductionParameter',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_ProductionParameter;
GO

CREATE PROCEDURE dbo.del_ProductionParameter
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionParameter
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы ProductionParameter
IF OBJECT_ID ('dbo.get_ProductionParameter', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_ProductionParameter;
GO

CREATE FUNCTION dbo.get_ProductionParameter(@ID INT)
RETURNS @retProductionParameter TABLE (ID               INT PRIMARY KEY NOT NULL,
                                       ProductSegmentID INT,
                                       ProcessSegmentID INT,
                                       Parameter        NVARCHAR(50))
AS
BEGIN

  INSERT @retProductionParameter
  SELECT ID,
         ProductSegmentID,
         ProcessSegmentID,
         Parameter
  FROM dbo.ProductionParameter
  WHERE ID=@ID;

  RETURN;

END;
GO

