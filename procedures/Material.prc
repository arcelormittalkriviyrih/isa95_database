
IF OBJECT_ID ('dbo.gen_MaterialLot',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_MaterialLot AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу MaterialLot
IF OBJECT_ID ('dbo.ins_MaterialLot',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLot;
GO

CREATE PROCEDURE dbo.ins_MaterialLot
   --@FactoryNumber        NVARCHAR(250),
   --@MaterialDefinitionID INT,
   @Description          NVARCHAR(250),
   @Status               NVARCHAR(250),
   --@StorageLocation      NVARCHAR(250),
   @Quantity             INT,
   --@Location             NVARCHAR(250),
   --@AssemblyLotID        INT,
   --@AssemblyType         NVARCHAR(250),
   --@AssemblyRelationship NVARCHAR(250),
   @MaterialLotID        INT OUTPUT
AS
BEGIN

  IF @MaterialLotID IS NULL
    SET @MaterialLotID=NEXT VALUE FOR dbo.gen_MaterialLot;

  INSERT INTO dbo.MaterialLot(ID,
                              --FactoryNumber,
                              --MaterialDefinitionID,
                              Description,
                              Status,
                              --StorageLocation,
                              Quantity--,
                              --Location,
                              --AssemblyLotID,
                              --AssemblyType,
                              --AssemblyRelationship
                             )
                      VALUES (@MaterialLotID,
                              --@FactoryNumber,
                              --@MaterialDefinitionID,
                              @Description,
                              @Status,
                              --@StorageLocation,
                              @Quantity--,
                              --@Location,
                              --@AssemblyLotID,
                              --@AssemblyType,
                              --@AssemblyRelationship
                             );

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы MaterialLot
IF OBJECT_ID ('dbo.upd_MaterialLot',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLot;
GO

CREATE PROCEDURE dbo.upd_MaterialLot
   @ID                   INT,
   --@FactoryNumber        NVARCHAR(250),
   --@MaterialDefinitionID INT,
   @Description          NVARCHAR(250),
   @Status               NVARCHAR(250),
   --@StorageLocation      NVARCHAR(250),
   @Quantity             INT--,
   --@Location             NVARCHAR(250),
   --@AssemblyLotID        INT,
   --@AssemblyType         NVARCHAR(250),
   --@AssemblyRelationship NVARCHAR(250)
AS
BEGIN

  UPDATE dbo.MaterialLot
  SET --FactoryNumber=@FactoryNumber,
      --MaterialDefinitionID=@MaterialDefinitionID,
      Description=@Description,
      Status=@Status,
      --StorageLocation=@StorageLocation,
      Quantity=@Quantity--,
      --Location=@Location,
      --AssemblyLotID=@AssemblyLotID,
      --AssemblyType=@AssemblyType,
      --AssemblyRelationship=@AssemblyRelationship
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы MaterialLot
IF OBJECT_ID ('dbo.del_MaterialLot',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_MaterialLot;
GO

CREATE PROCEDURE dbo.del_MaterialLot
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialLot
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы MaterialLot
IF OBJECT_ID ('dbo.get_MaterialLot', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_MaterialLot;
GO

CREATE FUNCTION dbo.get_MaterialLot(@ID INT)
RETURNS @retMaterialLot TABLE (ID                   INT,
                               FactoryNumber        NVARCHAR(250),
                               MaterialDefinitionID INT,
                               Description          NVARCHAR(250),
                               Status               NVARCHAR(250),
                               StorageLocation      NVARCHAR(250),
                               Quantity             INT,
                               Location             NVARCHAR(250),
                               AssemblyLotID        INT,
                               AssemblyType         NVARCHAR(250),
                               AssemblyRelationship NVARCHAR(250))
AS
BEGIN

  INSERT @retMaterialLot
  SELECT ID,
         FactoryNumber,
         MaterialDefinitionID,
         Description,
         Status,
         StorageLocation,
         Quantity,
         Location,
         AssemblyLotID,
         AssemblyType,
         AssemblyRelationship
  FROM dbo.MaterialLot
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу MaterialLotProperty
IF OBJECT_ID ('dbo.ins_MaterialLotProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotProperty;
GO

CREATE PROCEDURE dbo.ins_MaterialLotProperty
   @Description                 NVARCHAR(50),
   @Value                       NVARCHAR(50),
   @MaterialLotProperty         INT,
   --@MaterialTestSpecificationID NVARCHAR(50),
   --@TestResult                  NVARCHAR(50),
   @MaterialLotID               INT,
   --@MaterialSubLotID            INT,
   @DefinitionPropertyID        INT,
   @PropertyType                INT,
   @MaterialLotPropertyID       INT OUTPUT
AS
BEGIN

  IF @MaterialLotPropertyID IS NULL
    SET @MaterialLotPropertyID=NEXT VALUE FOR dbo.gen_Property;

  INSERT INTO dbo.MaterialLotProperty(ID,
                                      Description,
                                      Value,
                                      MaterialLotProperty,
                                      --MaterialTestSpecificationID,
                                      --TestResult,
                                      MaterialLotID,
                                      --MaterialSubLotID,
                                      DefinitionPropertyID,
                                      PropertyType)
                              VALUES (@MaterialLotPropertyID,
                                      @Description,
                                      @Value,
                                      @MaterialLotProperty,
                                      --@MaterialTestSpecificationID,
                                      --@TestResult,
                                      @MaterialLotID,
                                      --@MaterialSubLotID,
                                      @DefinitionPropertyID,
                                      @PropertyType);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы MaterialLotProperty
IF OBJECT_ID ('dbo.upd_MaterialLotProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotProperty;
GO

CREATE PROCEDURE dbo.upd_MaterialLotProperty
   @ID                          INT,
   @Description                 NVARCHAR(50),
   @Value                       NVARCHAR(50),
   @MaterialLotProperty         INT,
   --@MaterialTestSpecificationID NVARCHAR(50),
   --@TestResult                  NVARCHAR(50),
   @MaterialLotID               INT,
   --@MaterialSubLotID            INT,
   @DefinitionPropertyID        INT,
   @PropertyType                INT
AS
BEGIN

  UPDATE dbo.MaterialLotProperty
  SET Description=@Description,
      Value=@Value,
      MaterialLotProperty=@MaterialLotProperty,
      --MaterialTestSpecificationID=@MaterialTestSpecificationID,
      --TestResult=@TestResult,
      MaterialLotID=@MaterialLotID,
      --MaterialSubLotID=@MaterialSubLotID,
      DefinitionPropertyID=@DefinitionPropertyID,
      PropertyType=@PropertyType
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы MaterialLotProperty
IF OBJECT_ID ('dbo.del_MaterialLotProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_MaterialLotProperty;
GO

CREATE PROCEDURE dbo.del_MaterialLotProperty
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialLotProperty
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы MaterialLotProperty
IF OBJECT_ID ('dbo.get_MaterialLotProperty', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_MaterialLotProperty;
GO

CREATE FUNCTION dbo.get_MaterialLotProperty(@ID INT)
RETURNS @retMaterialLotProperty TABLE (ID                          INT,
                                       Description                 NVARCHAR(50),
                                       Value                       NVARCHAR(50),
                                       MaterialLotProperty         INT,
                                       MaterialTestSpecificationID NVARCHAR(50),
                                       TestResult                  NVARCHAR(50),
                                       MaterialLotID               INT,
                                       MaterialSubLotID            INT,
                                       DefinitionPropertyID        INT,
                                       PropertyType                INT)
AS
BEGIN

  INSERT @retMaterialLotProperty
  SELECT ID,
         Description,
         Value,
         MaterialLotProperty,
         MaterialTestSpecificationID,
         TestResult,
         MaterialLotID,
         MaterialSubLotID,
         DefinitionPropertyID,
         PropertyType
  FROM dbo.MaterialLotProperty
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу MaterialDefinitionProperty
IF OBJECT_ID ('dbo.ins_MaterialDefinitionProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialDefinitionProperty;
GO

CREATE PROCEDURE dbo.ins_MaterialDefinitionProperty
   @Description                  NVARCHAR(50),
   @Value                        NVARCHAR(50),
   --@MaterialDefinitionProperty   INT,
   --@MaterialTestSpecificationID  NVARCHAR(50),
   --@MaterialDefinitionID         INT,
   @ClassPropertyID              INT,
   @PropertyType                 INT,
   @MaterialDefinitionPropertyID INT OUTPUT
AS
BEGIN

  IF @MaterialDefinitionPropertyID IS NULL
    SET @MaterialDefinitionPropertyID=NEXT VALUE FOR dbo.gen_ClassDefinitionProperty;

  INSERT INTO dbo.MaterialDefinitionProperty(ID,
                                             Description,
                                             Value,
                                             --MaterialDefinitionProperty,
                                             --MaterialTestSpecificationID,
                                             --MaterialDefinitionID,
                                             ClassPropertyID,
                                             PropertyType)
                                     VALUES (@MaterialDefinitionPropertyID,
                                             @Description,
                                             @Value,
                                             --@MaterialDefinitionProperty,
                                             --@MaterialTestSpecificationID,
                                             --@MaterialDefinitionID,
                                             @ClassPropertyID,
                                             @PropertyType);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы MaterialDefinitionProperty
IF OBJECT_ID ('dbo.upd_MaterialDefinitionProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialDefinitionProperty;
GO

CREATE PROCEDURE dbo.upd_MaterialDefinitionProperty
   @ID                           INT,
   @Description                  NVARCHAR(50),
   @Value                        NVARCHAR(50),
   --@MaterialDefinitionProperty   INT,
   --@MaterialTestSpecificationID  NVARCHAR(50),
   --@MaterialDefinitionID         INT,
   @ClassPropertyID              INT,
   @PropertyType                 INT
AS
BEGIN

  UPDATE dbo.MaterialDefinitionProperty
  SET Description=@Description,
      Value=@Value,
      --MaterialDefinitionProperty=@MaterialDefinitionProperty,
      --MaterialTestSpecificationID=@MaterialTestSpecificationID,
      --MaterialDefinitionID=@MaterialDefinitionID,
      ClassPropertyID=@ClassPropertyID,
      PropertyType=@PropertyType
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы MaterialDefinitionProperty
IF OBJECT_ID ('dbo.del_MaterialDefinitionProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_MaterialDefinitionProperty;
GO

CREATE PROCEDURE dbo.del_MaterialDefinitionProperty
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialDefinitionProperty
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы MaterialDefinitionProperty
IF OBJECT_ID ('dbo.get_MaterialDefinitionProperty', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_MaterialDefinitionProperty;
GO

CREATE FUNCTION dbo.get_MaterialDefinitionProperty(@ID INT)
RETURNS @retMaterialLotProperty TABLE (ID                           INT,
                                       Description                  NVARCHAR(50),
                                       Value                        NVARCHAR(50),
                                       MaterialDefinitionProperty   INT,
                                       MaterialTestSpecificationID  NVARCHAR(50),
                                       MaterialDefinitionID         INT,
                                       ClassPropertyID              INT,
                                       PropertyType                 INT)
AS
BEGIN

  INSERT @retMaterialLotProperty
  SELECT ID,
         Description,
         Value,
         MaterialDefinitionProperty,
         MaterialTestSpecificationID,
         MaterialDefinitionID,
         ClassPropertyID,
         PropertyType
  FROM dbo.MaterialDefinitionProperty
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_MaterialActual',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_MaterialActual AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу MaterialActual
IF OBJECT_ID ('dbo.ins_MaterialActual',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialActual;
GO

CREATE PROCEDURE dbo.ins_MaterialActual
   --@MaterialClassID                    HIERARCHYID,
   --@MaterialDefinitionID               INT,
   @MaterialLotID                      INT,
   --@MaterialSubLotID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   --@MaterialUse                        NVARCHAR(50),
   @Quantity                           INT,
   --@AssemblyType                       NVARCHAR(50),
   --@AssemblyActual                     INT,
   --@AssemblyRelationship               NVARCHAR(50),
   --@RequiredByRequestedSegmentResponse NVARCHAR(50),
   @SegmentResponseID                  INT,
   @MaterialActualID                   INT OUTPUT
AS
BEGIN

  IF @MaterialActualID IS NULL
    SET @MaterialActualID=NEXT VALUE FOR dbo.gen_MaterialActual;

  INSERT INTO dbo.MaterialActual(ID,
                                 --MaterialClassID,
                                 --MaterialDefinitionID,
                                 MaterialLotID,
                                 --MaterialSubLotID,
                                 Description,
                                 --Location,
                                 --HierarchyScope,
                                 --MaterialUse,
                                 Quantity,
                                 --AssemblyType,
                                 --AssemblyActual,
                                 --AssemblyRelationship,
                                 --RequiredByRequestedSegmentResponse,
                                 SegmentResponseID)
                         VALUES (@MaterialActualID,
                                 --@MaterialClassID,
                                 --@MaterialDefinitionID,
                                 @MaterialLotID,
                                 --@MaterialSubLotID,
                                 @Description,
                                 --@Location,
                                 --@HierarchyScope,
                                 --@MaterialUse,
                                 @Quantity,
                                 --@AssemblyType,
                                 --@AssemblyActual,
                                 --@AssemblyRelationship,
                                 --@RequiredByRequestedSegmentResponse,
                                 @SegmentResponseID);
END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы MaterialActual
IF OBJECT_ID ('dbo.upd_MaterialActual',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialActual;
GO

CREATE PROCEDURE dbo.upd_MaterialActual
   @ID                                 INT,
   --@MaterialClassID                    HIERARCHYID,
   --@MaterialDefinitionID               INT,
   @MaterialLotID                      INT,
   --@MaterialSubLotID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   --@MaterialUse                        NVARCHAR(50),
   @Quantity                           INT,
   --@AssemblyType                       NVARCHAR(50),
   --@AssemblyActual                     INT,
   --@AssemblyRelationship               NVARCHAR(50),
   --@RequiredByRequestedSegmentResponse NVARCHAR(50),
   @SegmentResponseID                  INT
AS
BEGIN

  UPDATE dbo.MaterialActual
  SET --MaterialClassID=@MaterialClassID,
      --MaterialDefinitionID=@MaterialDefinitionID,
      MaterialLotID=@MaterialLotID,
      --MaterialSubLotID=@MaterialSubLotID,
      Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      --MaterialUse=@MaterialUse,
      Quantity=@Quantity,
      --AssemblyType=@AssemblyType,
      --AssemblyActual=@AssemblyActual,
      --AssemblyRelationship=@AssemblyRelationship,
      --RequiredByRequestedSegmentResponse=@RequiredByRequestedSegmentResponse,
      SegmentResponseID=@SegmentResponseID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы MaterialActual
IF OBJECT_ID ('dbo.del_MaterialActual',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_MaterialActual;
GO

CREATE PROCEDURE dbo.del_MaterialActual
    @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialActual
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы MaterialActual
IF OBJECT_ID ('dbo.get_MaterialActual', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_MaterialActual;
GO

CREATE FUNCTION dbo.get_MaterialActual(@ID INT)
RETURNS @retMaterialActual TABLE (ID                                 INT,
                                  MaterialClassID                    HIERARCHYID,
                                  MaterialDefinitionID               INT,
                                  MaterialLotID                      INT,
                                  MaterialSubLotID                   INT,
                                  Description                        NVARCHAR(50),
                                  Location                           NVARCHAR(50),
                                  HierarchyScope                     HIERARCHYID,
                                  MaterialUse                        NVARCHAR(50),
                                  Quantity                           INT,
                                  AssemblyType                       NVARCHAR(50),
                                  AssemblyActual                     INT,
                                  AssemblyRelationship               NVARCHAR(50),
                                  RequiredByRequestedSegmentResponse NVARCHAR(50),
                                  SegmentResponseID                  INT)
AS
BEGIN

  INSERT @retMaterialActual
  SELECT ID,
         MaterialClassID,
         MaterialDefinitionID,
         MaterialLotID,
         MaterialSubLotID,
         Description,
         Location,
         HierarchyScope,
         MaterialUse,
         Quantity,
         AssemblyType,
         AssemblyActual,
         AssemblyRelationship,
         RequiredByRequestedSegmentResponse,
         SegmentResponseID
  FROM dbo.MaterialActual
  WHERE ID=@ID;

  RETURN;

END;
GO

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
    @now                  DATETIME = CURRENT_TIMESTAMP,
    @err_message          NVARCHAR(255);

  SELECT @ProductionRequestID=sreq.ProductionRequest,
         @Quantity=kl.Weight_VALUE
  FROM dbo.v_kep_logger kl
       INNER JOIN dbo.EquipmentRequirement ereq ON (ereq.EquipmentID=kl.EquipmentID)
       INNER JOIN dbo.SegmentRequirement sreq ON (sreq.ID=ereq.SegmentRequirementID)
       INNER JOIN dbo.ProductionRequest preq ON (preq.ID=sreq.ProductionRequest AND preq.RequestState=N'InProgress')
  WHERE kl.Controller_ID=@ControllerID;

  IF @ProductionRequestID IS NULL
    BEGIN
      SET @err_message = N'Для контроллера №' + CAST(@ControllerID AS NVARCHAR) + ' не найден ProductionRequest в состоянии "InProgress"';
      RAISERROR (@err_message,11,1);
      RETURN;
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
