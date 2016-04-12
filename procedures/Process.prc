IF OBJECT_ID ('dbo.gen_ProcessSegment',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ProcessSegment AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу ProcessSegment
IF OBJECT_ID ('dbo.ins_ProcessSegment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ProcessSegment;
GO

CREATE PROCEDURE dbo.ins_ProcessSegment
   @Description                 NVARCHAR(50),
   @OperationsType              NVARCHAR(50),
   --@Location                    NVARCHAR(50),
   --@HierarchyScope              INT,
   @PublishedDate               DATETIMEOFFSET(7),
   --@Duration                    NVARCHAR(50),
   --@SegmentDependency           NVARCHAR(50),
   --@ProcessSegment              INT,
   --@SegmentResponse             INT,
   --@OperationsSegment           INT,
   --@ProductDefinition           INT,
   --@OpProcessSegmentCapability  INT,
   --@ProcessSegmentInformation   INT,
   --@OpSegmentResponse           INT,
   @ProductSegmentID            INT,
   @ProcessSegmentID            INT OUTPUT
AS
BEGIN

  IF @ProcessSegmentID IS NULL
    SET @ProcessSegmentID=NEXT VALUE FOR dbo.gen_ProcessSegment;

  INSERT INTO dbo.ProcessSegment(ID,
                                 Description,
                                 OperationsType,
                                 --Location,
                                 --HierarchyScope,
                                 PublishedDate,
                                 --Duration,
                                 --SegmentDependency,
                                 --ProcessSegment,
                                 --SegmentResponse,
                                 --OperationsSegment,
                                 --ProductDefinition,
                                 --OpProcessSegmentCapability,
                                 --ProcessSegmentInformation,
                                 --OpSegmentResponse,
                                 ProductSegmentID)
                         VALUES (@ProcessSegmentID,
                                 @Description,
                                 @OperationsType,
                                 --@Location,
                                 --@HierarchyScope,
                                 @PublishedDate,
                                 --@Duration,
                                 --@SegmentDependency,
                                 --@ProcessSegment,
                                 --@SegmentResponse,
                                 --@OperationsSegment,
                                 --@ProductDefinition,
                                 --@OpProcessSegmentCapability,
                                 --@ProcessSegmentInformation,
                                 --@OpSegmentResponse,
                                 @ProductSegmentID);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы ProcessSegment
IF OBJECT_ID ('dbo.upd_ProcessSegment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_ProcessSegment;
GO

CREATE PROCEDURE dbo.upd_ProcessSegment
   @ID                          INT,
   @Description                 NVARCHAR(50),
   @OperationsType              NVARCHAR(50),
   --@Location                    NVARCHAR(50),
   --@HierarchyScope              INT,
   @PublishedDate               DATETIMEOFFSET(7),
   --@Duration                    NVARCHAR(50),
   --@SegmentDependency           NVARCHAR(50),
   --@ProcessSegment              INT,
   --@SegmentResponse             INT,
   --@OperationsSegment           INT,
   --@ProductDefinition           INT,
   --@OpProcessSegmentCapability  INT,
   --@ProcessSegmentInformation   INT,
   --@OpSegmentResponse           INT,
   @ProductSegmentID            INT
AS
BEGIN

  UPDATE dbo.ProcessSegment
  SET Description=@Description,
      OperationsType=@OperationsType,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      PublishedDate=@PublishedDate,
      --Duration=@Duration,
      --SegmentDependency=@SegmentDependency,
      --ProcessSegment=@ProcessSegment,
      --SegmentResponse=@SegmentResponse,
      --OperationsSegment=@OperationsSegment,
      --ProductDefinition=@ProductDefinition,
      --OpProcessSegmentCapability=@OpProcessSegmentCapability,
      --ProcessSegmentInformation=@ProcessSegmentInformation,
      --OpSegmentResponse=@OpSegmentResponse,
      ProductSegmentID=@ProductSegmentID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы ProcessSegment
IF OBJECT_ID ('dbo.del_ProcessSegment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_ProcessSegment;
GO

CREATE PROCEDURE dbo.del_ProcessSegment
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProcessSegment
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы ProcessSegment
IF OBJECT_ID ('dbo.get_ProcessSegment', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_ProcessSegment;
GO

CREATE FUNCTION dbo.get_ProcessSegment(@ID INT)
RETURNS @retProcessSegment TABLE (ID                   INT PRIMARY KEY NOT NULL,
                                  Description                 NVARCHAR(50),
                                  OperationsType              NVARCHAR(50),
                                  --Location                    NVARCHAR(50),
                                  --HierarchyScope              INT,
                                  PublishedDate               DATETIMEOFFSET(7),
                                  --Duration                    NVARCHAR(50),
                                  --SegmentDependency           NVARCHAR(50),
                                  --ProcessSegment              INT,
                                  --SegmentResponse             INT,
                                  --OperationsSegment           INT,
                                  --ProductDefinition           INT,
                                  --OpProcessSegmentCapability  INT,
                                  --ProcessSegmentInformation   INT,
                                  --OpSegmentResponse           INT,
                                  ProductSegmentID            INT)
AS
BEGIN

  INSERT @retProcessSegment
  SELECT ID,
         Description,
         OperationsType,
         --Location,
         --HierarchyScope,
         PublishedDate,
         --Duration,
         --SegmentDependency,
         --ProcessSegment,
         --SegmentResponse,
         --OperationsSegment,
         --ProductDefinition,
         --OpProcessSegmentCapability,
         --ProcessSegmentInformation,
         --OpSegmentResponse,
         ProductSegmentID
  FROM dbo.ProcessSegment
  WHERE ID=@ID;

  RETURN;

END;
GO
