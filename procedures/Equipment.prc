USE [B2MML-BatchML]
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу EquipmentClass
IF OBJECT_ID ('dbo.ins_EquipmentClass',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_EquipmentClass;
GO

CREATE PROCEDURE dbo.ins_EquipmentClass
   @ID             HIERARCHYID,
   @Description    NVARCHAR(50),
   @Location       NVARCHAR(50),
   @HierarchyScope HIERARCHYID,
   @EquipmentLevel NVARCHAR(50)
AS
BEGIN

  INSERT INTO dbo.EquipmentClass(ID,
                                 Description,
                                 Location,
                                 HierarchyScope,
                                 EquipmentLevel)
                         VALUES (@ID,
                                 @Description,
                                 @Location,
                                 @HierarchyScope,
                                 @EquipmentLevel);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы EquipmentClass
IF OBJECT_ID ('dbo.upd_EquipmentClass',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentClass;
GO

CREATE PROCEDURE dbo.upd_EquipmentClass
   @ID             HIERARCHYID,
   @Description    NVARCHAR(50),
   @Location       NVARCHAR(50),
   @HierarchyScope HIERARCHYID,
   @EquipmentLevel NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.EquipmentClass
  SET Description=@Description,
      Location=@Location,
      HierarchyScope=@HierarchyScope,
      EquipmentLevel=@EquipmentLevel
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы EquipmentClass
IF OBJECT_ID ('dbo.del_EquipmentClass',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_EquipmentClass;
GO

CREATE PROCEDURE dbo.del_EquipmentClass
   @ID HIERARCHYID
AS
BEGIN

  DELETE FROM dbo.EquipmentClass
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы EquipmentClass
IF OBJECT_ID ('dbo.get_EquipmentClass', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentClass;
GO

CREATE FUNCTION dbo.get_EquipmentClass(@ID HIERARCHYID)
RETURNS @retEquipmentClass TABLE (ID             HIERARCHYID,
                                  Description    NVARCHAR(50),
                                  Location       NVARCHAR(50),
                                  HierarchyScope HIERARCHYID,
                                  EquipmentLevel NVARCHAR(50))
AS
BEGIN

  INSERT @retEquipmentClass
  SELECT ID,
         Description,
         Location,
         HierarchyScope,
         EquipmentLevel
  FROM dbo.EquipmentClass
  WHERE ID=@ID;

  RETURN;

END;
GO

IF OBJECT_ID ('dbo.gen_ClassDefinitionProperty',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ClassDefinitionProperty AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу EquipmentClassProperty
IF OBJECT_ID ('dbo.ins_EquipmentClassProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_EquipmentClassProperty;
GO

CREATE PROCEDURE dbo.ins_EquipmentClassProperty
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   --@EquipmentClassProperty               INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   @EquipmentClassID                     HIERARCHYID,
   @EquipmentClassPropertyID             INT OUTPUT
AS
BEGIN

  IF @EquipmentClassPropertyID IS NULL
    SET @EquipmentClassPropertyID=NEXT VALUE FOR dbo.gen_ClassDefinitionProperty;

  INSERT INTO dbo.EquipmentClassProperty(ID,
                                         Description,
                                         Value,
                                         --EquipmentClassProperty,
                                         --EquipmentCapabilityTestSpecification,
                                         EquipmentClassID)
                                 VALUES (@EquipmentClassPropertyID,
                                         @Description,
                                         @Value,
                                         --@EquipmentClassProperty,
                                         --@EquipmentCapabilityTestSpecification
                                         @EquipmentClassID);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы EquipmentClassProperty
IF OBJECT_ID ('dbo.upd_EquipmentClassProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentClassProperty;
GO

CREATE PROCEDURE dbo.upd_EquipmentClassProperty
   @ID                                   INT,
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   --@EquipmentClassProperty               INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   @EquipmentClassID                     HIERARCHYID
AS
BEGIN

  UPDATE dbo.EquipmentClassProperty
  SET Description=@Description,
      Value=@Value,
      --EquipmentClassProperty=@EquipmentClassProperty,
      --EquipmentCapabilityTestSpecification=@EquipmentCapabilityTestSpecification,
      EquipmentClassID=@EquipmentClassID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы EquipmentClassProperty
IF OBJECT_ID ('dbo.del_EquipmentClassProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_EquipmentClassProperty;
GO

CREATE PROCEDURE dbo.del_EquipmentClassProperty
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentClassProperty
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы EquipmentClassProperty
IF OBJECT_ID ('dbo.get_EquipmentClassProperty', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentClassProperty;
GO

CREATE FUNCTION dbo.get_EquipmentClassProperty(@ID INT)
RETURNS @retEquipmentClassProperty TABLE (ID                                   INT,
                                          Description                          NVARCHAR(50),
                                          Value                                NVARCHAR(50),
                                          EquipmentClassProperty               INT,
                                          EquipmentCapabilityTestSpecification NVARCHAR(50),
                                          EquipmentClassID                     HIERARCHYID)
AS
BEGIN

  INSERT @retEquipmentClassProperty
  SELECT ID,
         Description,
         Value,
         EquipmentClassProperty,
         EquipmentCapabilityTestSpecification,
         EquipmentClassID
  FROM dbo.EquipmentClassProperty
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_Property',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_Property AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу EquipmentProperty
IF OBJECT_ID ('dbo.ins_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_EquipmentProperty;
GO

CREATE PROCEDURE dbo.ins_EquipmentProperty
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   @EquipmentProperty                    INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   --@TestResult                           NVARCHAR(50),
   @EquipmentID                          INT,
   @ClassPropertyID                      INT,
   @EquipmentPropertyID                  INT OUTPUT
AS
BEGIN

  IF @EquipmentPropertyID IS NULL
    SET @EquipmentPropertyID=NEXT VALUE FOR dbo.gen_Property;

  INSERT INTO dbo.EquipmentProperty(ID,
                                    Description,
                                    Value,
                                    EquipmentProperty,
                                    --EquipmentCapabilityTestSpecification,
                                    --TestResult,
                                    EquipmentID,
                                    ClassPropertyID)
                            VALUES (@EquipmentPropertyID,
                                    @Description,
                                    @Value,
                                    @EquipmentProperty,
                                    --@EquipmentCapabilityTestSpecification,
                                    --@TestResult,
                                    @EquipmentID,
                                    @ClassPropertyID);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы EquipmentProperty
IF OBJECT_ID ('dbo.upd_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentProperty;
GO

CREATE PROCEDURE dbo.upd_EquipmentProperty
   @ID                                   INT,
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   @EquipmentProperty                    INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   --@TestResult                           NVARCHAR(50),
   @EquipmentID                          INT,
   @ClassPropertyID                      INT
AS
BEGIN

  UPDATE dbo.EquipmentProperty
  SET Description=@Description,
      Value=@Value,
      EquipmentProperty=@EquipmentProperty,
      --EquipmentCapabilityTestSpecification=@EquipmentCapabilityTestSpecification,
      --TestResult=@TestResult,
      EquipmentID=@EquipmentID,
      ClassPropertyID=@ClassPropertyID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы EquipmentProperty
IF OBJECT_ID ('dbo.del_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_EquipmentProperty;
GO

CREATE PROCEDURE dbo.del_EquipmentProperty
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentProperty
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы EquipmentProperty
IF OBJECT_ID ('dbo.get_EquipmentProperty', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentProperty;
GO

CREATE FUNCTION dbo.get_EquipmentProperty(@ID INT)
RETURNS @retEquipmentProperty TABLE (ID                                   INT,
                                     Description                          NVARCHAR(50),
                                     Value                                NVARCHAR(50),
                                     EquipmentProperty                    INT,
                                     EquipmentCapabilityTestSpecification NVARCHAR(50),
                                     TestResult                           NVARCHAR(50),
                                     EquipmentID                          INT,
                                     ClassPropertyID                      INT)
AS
BEGIN

  INSERT @retEquipmentProperty
  SELECT ID,
         Description,
         Value,
         EquipmentProperty,
         EquipmentCapabilityTestSpecification,
         TestResult,
         EquipmentID,
         ClassPropertyID
  FROM dbo.EquipmentProperty
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_Equipment',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_Equipment AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу Equipment
IF OBJECT_ID ('dbo.ins_Equipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_Equipment;
GO

CREATE PROCEDURE dbo.ins_Equipment
   @Description      NVARCHAR(50),
   --@Location         NVARCHAR(50),
   --@HierarchyScope   HIERARCHYID,
   --@EquipmentLevel   NVARCHAR(50),
   --@Equipment        INT,
   @EquipmentClassID HIERARCHYID,
   @EquipmentID      INT OUTPUT
AS
BEGIN

  IF @EquipmentID IS NULL
    SET @EquipmentID=NEXT VALUE FOR dbo.gen_Equipment;

  INSERT INTO dbo.Equipment(ID,
                            Description,
                            --Location,
                            --HierarchyScope,
                            --EquipmentLevel,
                            --Equipment,
                            EquipmentClassID)
                    VALUES (@EquipmentID,
                            @Description,
                            --@Location,
                            --@HierarchyScope,
                            --@EquipmentLevel,
                            --@Equipment,
                            @EquipmentClassID);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы Equipment
IF OBJECT_ID ('dbo.upd_Equipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_Equipment;
GO

CREATE PROCEDURE dbo.upd_Equipment
   @ID               INT,
   @Description      NVARCHAR(50),
   --@Location         NVARCHAR(50),
   --@HierarchyScope   HIERARCHYID,
   --@EquipmentLevel   NVARCHAR(50),
   --@Equipment        INT,
   @EquipmentClassID HIERARCHYID
AS
BEGIN

  UPDATE dbo.Equipment
  SET Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      --EquipmentLevel=@EquipmentLevel,
      --Equipment=@Equipment
      EquipmentClassID=@EquipmentClassID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы Equipment
IF OBJECT_ID ('dbo.del_Equipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_Equipment;
GO

CREATE PROCEDURE dbo.del_Equipment
   @ID INT
AS
BEGIN

  DELETE FROM dbo.Equipment
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы Equipment
IF OBJECT_ID ('dbo.get_Equipment', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_Equipment;
GO

CREATE FUNCTION dbo.get_Equipment(@ID INT)
RETURNS @retEquipment TABLE (ID               INT,
                             Description      NVARCHAR(50),
                             Location         NVARCHAR(50),
                             HierarchyScope   HIERARCHYID,
                             EquipmentLevel   NVARCHAR(50),
                             Equipment        INT,
                             EquipmentClassID HIERARCHYID)
AS
BEGIN

  INSERT @retEquipment
  SELECT ID,
         Description,
         Location,
         HierarchyScope,
         EquipmentLevel,
         Equipment,
         EquipmentClassID
  FROM dbo.Equipment
  WHERE ID=@ID;

  RETURN;

END;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_EquipmentRequirement',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_EquipmentRequirement AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу EquipmentRequirement
IF OBJECT_ID ('dbo.ins_EquipmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_EquipmentRequirement;
GO

CREATE PROCEDURE dbo.ins_EquipmentRequirement
   @EquipmentClassID                   HIERARCHYID,
   @EquipmentID                        INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   @Quantity                           INT,
   --@RequiredByRequestedSegmentResponce NVARCHAR(50),
   @SegmentRequirementID               INT,
   @EquipmentRequirementID             INT OUTPUT
AS
BEGIN

  IF @EquipmentRequirementID IS NULL
    SET @EquipmentRequirementID=NEXT VALUE FOR dbo.gen_EquipmentRequirement;

  INSERT INTO dbo.EquipmentRequirement(ID,
                                       EquipmentClassID,
                                       EquipmentID,
                                       Description,
                                       --Location,
                                       --HierarchyScope,
                                       Quantity,
                                       --RequiredByRequestedSegmentResponce,
                                       SegmentRequirementID)
                               VALUES (@EquipmentRequirementID,
                                       @EquipmentClassID,
                                       @EquipmentID,
                                       @Description,
                                       --@Location,
                                       --@HierarchyScope,
                                       @Quantity,
                                       --@RequiredByRequestedSegmentResponce,
                                       @SegmentRequirementID);

END;
GO

--------------------------------------------------------------
-- Процедура редактирования таблицы EquipmentRequirement
IF OBJECT_ID ('dbo.upd_EquipmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentRequirement;
GO

CREATE PROCEDURE dbo.upd_EquipmentRequirement
   @ID                                 INT,
   @EquipmentClassID                   HIERARCHYID,
   @EquipmentID                        INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     HIERARCHYID,
   @Quantity                           INT,
   --@RequiredByRequestedSegmentResponce NVARCHAR(50),
   @SegmentRequirementID               INT
AS
BEGIN

  UPDATE dbo.EquipmentRequirement
  SET EquipmentClassID=@EquipmentClassID,
      EquipmentID=@EquipmentID,
      Description=@Description,
      --Location=@Location,
      --HierarchyScope=@HierarchyScope,
      Quantity=@Quantity,
      --RequiredByRequestedSegmentResponce=@RequiredByRequestedSegmentResponce,
      SegmentRequirementID=@SegmentRequirementID
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы EquipmentRequirement
IF OBJECT_ID ('dbo.del_EquipmentRequirement',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_EquipmentRequirement;
GO

CREATE PROCEDURE dbo.del_EquipmentRequirement
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentRequirement
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы EquipmentRequirement
IF OBJECT_ID ('dbo.get_EquipmentRequirement', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentRequirement;
GO

CREATE FUNCTION dbo.get_EquipmentRequirement(@ID INT)
RETURNS @retEquipmentRequirement TABLE (ID                                 INT,
                                        EquipmentClassID                   HIERARCHYID,
                                        EquipmentID                        INT,
                                        Description                        NVARCHAR(50),
                                        Location                           NVARCHAR(50),
                                        HierarchyScope                     HIERARCHYID,
                                        Quantity                           INT,
                                        RequiredByRequestedSegmentResponce NVARCHAR(50),
                                        SegmentRequirementID               INT)
AS
BEGIN

  INSERT @retEquipmentRequirement
  SELECT ID,
         EquipmentClassID,
         EquipmentID,
         Description,
         Location,
         HierarchyScope,
         Quantity,
         RequiredByRequestedSegmentResponce,
         SegmentRequirementID
  FROM dbo.EquipmentRequirement
  WHERE ID=@ID;

  RETURN;

END;
GO
