-- Пересоздаем все процедуры
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--call sequence one time to increase number, because current DB already has one record
select next value for dbo.gen_Files;

/****** Object:  StoredProcedure [dbo].[upd_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_SegmentResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_SegmentResponse]
GO
/****** Object:  StoredProcedure [dbo].[upd_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_SegmentRequirement',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_SegmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[upd_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_PropertyTypes',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_PropertyTypes]
GO
/****** Object:  StoredProcedure [dbo].[upd_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_ProductSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_ProductSegment]
GO
/****** Object:  StoredProcedure [dbo].[upd_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_ProductionResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_ProductionResponse]
GO
/****** Object:  StoredProcedure [dbo].[upd_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_ProductionRequest',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_ProductionRequest]
GO
/****** Object:  StoredProcedure [dbo].[upd_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_ProductionParameter',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_ProductionParameter]
GO
/****** Object:  StoredProcedure [dbo].[upd_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_ProcessSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_ProcessSegment]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialLotProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialLotProperty]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialLot',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialLot]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialDefinitionProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialDefinitionProperty]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialDefinition',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialDefinition]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialClass]
GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_MaterialActual',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_MaterialActual]
GO
/****** Object:  StoredProcedure [dbo].[upd_Files]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_Files',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_Files]
GO
/****** Object:  StoredProcedure [dbo].[upd_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.[upd_EquipmentRequirement]',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_EquipmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[upd_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_EquipmentProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_EquipmentProperty]
GO
/****** Object:  StoredProcedure [dbo].[upd_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_EquipmentClassProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_EquipmentClassProperty]
GO
/****** Object:  StoredProcedure [dbo].[upd_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_EquipmentClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_EquipmentClass]
GO
/****** Object:  StoredProcedure [dbo].[upd_Equipment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.upd_Equipment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[upd_Equipment]
GO
/****** Object:  StoredProcedure [dbo].[ins_TestParent]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_TestParent',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_TestParent]
GO
/****** Object:  StoredProcedure [dbo].[ins_TestOutParam]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_TestOutParam',N'P') IS NOT NULL
	DROP PROCEDURE [dbo].[ins_TestOutParam]
GO
/****** Object:  StoredProcedure [dbo].[ins_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_SegmentResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_SegmentResponse]
GO
/****** Object:  StoredProcedure [dbo].[ins_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_SegmentRequirement',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_SegmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[ins_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_PropertyTypes',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_PropertyTypes]
GO
/****** Object:  StoredProcedure [dbo].[ins_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_ProductSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_ProductSegment]
GO
/****** Object:  StoredProcedure [dbo].[ins_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_ProductionResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_ProductionResponse]
GO
/****** Object:  StoredProcedure [dbo].[ins_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_ProductionRequest',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_ProductionRequest]
GO
/****** Object:  StoredProcedure [dbo].[ins_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_ProductionParameter',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_ProductionParameter]
GO
/****** Object:  StoredProcedure [dbo].[ins_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_ProcessSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_ProcessSegment]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialLotProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialLotProperty]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialLot',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialLot]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialDefinitionProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialDefinitionProperty]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialDefinition',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialDefinition]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialClass]
GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_MaterialActual',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_MaterialActual]
GO
/****** Object:  StoredProcedure [dbo].[ins_Files]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_Files',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_Files]
GO
/****** Object:  StoredProcedure [dbo].[ins_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_EquipmentRequirement',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_EquipmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[ins_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_EquipmentProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_EquipmentProperty]
GO
/****** Object:  StoredProcedure [dbo].[ins_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_EquipmentClassProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_EquipmentClassProperty]
GO
/****** Object:  StoredProcedure [dbo].[ins_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_EquipmentClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_EquipmentClass]
GO
/****** Object:  StoredProcedure [dbo].[ins_Equipment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.ins_Equipment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[ins_Equipment]
GO
/****** Object:  StoredProcedure [dbo].[del_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_SegmentResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_SegmentResponse]
GO
/****** Object:  StoredProcedure [dbo].[del_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_SegmentRequirement',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_SegmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[del_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_PropertyTypes',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_PropertyTypes]
GO
/****** Object:  StoredProcedure [dbo].[del_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_ProductSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_ProductSegment]
GO
/****** Object:  StoredProcedure [dbo].[del_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_ProductionResponse',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_ProductionResponse]
GO
/****** Object:  StoredProcedure [dbo].[del_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_ProductionRequest',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_ProductionRequest]
GO
/****** Object:  StoredProcedure [dbo].[del_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_ProductionParameter',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_ProductionParameter]
GO
/****** Object:  StoredProcedure [dbo].[del_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_ProcessSegment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_ProcessSegment]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialLotProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialLotProperty]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialLot',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialLot]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialDefinitionProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialDefinitionProperty]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialDefinition',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialDefinition]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialClass]
GO
/****** Object:  StoredProcedure [dbo].[del_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_MaterialActual',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_MaterialActual]
GO
/****** Object:  StoredProcedure [dbo].[del_Files]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_Files',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_Files]
GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_EquipmentRequirement',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_EquipmentRequirement]
GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_EquipmentProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_EquipmentProperty]
GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_EquipmentClassProperty',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_EquipmentClassProperty]
GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_EquipmentClass',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_EquipmentClass]
GO
/****** Object:  StoredProcedure [dbo].[del_Equipment]    Script Date: 30.05.2016 13:22:25 ******/
IF OBJECT_ID ('dbo.del_Equipment',N'P') IS NOT NULL
DROP PROCEDURE [dbo].[del_Equipment]
GO
/****** Object:  StoredProcedure [dbo].[del_Equipment]    Script Date: 30.05.2016 13:22:25 ******/

CREATE PROCEDURE [dbo].[del_Equipment]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.Equipment
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_EquipmentClass]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentClass
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_EquipmentClassProperty]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentClassProperty
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_EquipmentProperty]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentProperty
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_EquipmentRequirement]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.EquipmentRequirement
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_Files]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_Files]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.Files
  WHERE ID=@ID;

END;

GO
/****** Object:  StoredProcedure [dbo].[del_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_MaterialActual]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialActual
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_MaterialClass]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialClass
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_MaterialDefinition]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialDefinition
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_MaterialDefinitionProperty]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialDefinitionProperty
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_MaterialLot]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialLot
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_MaterialLotProperty]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.MaterialLotProperty
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_ProcessSegment]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProcessSegment
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_ProductionParameter]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionParameter
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_ProductionRequest]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionRequest
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_ProductionResponse]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductionResponse
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_ProductSegment]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.ProductSegment
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[del_PropertyTypes]
   @ID INT
AS
BEGIN

  DELETE FROM dbo.PropertyTypes
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_SegmentRequirement]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.SegmentRequirement
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[del_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[del_SegmentResponse]
    @ID INT
AS
BEGIN

  DELETE FROM dbo.SegmentResponse
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_Equipment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_Equipment]
   @Description      NVARCHAR(50),
   --@Location         NVARCHAR(50),
   --@HierarchyScope   INT,
   --@EquipmentLevel   NVARCHAR(50),
   --@Equipment        INT,
   @EquipmentClassID INT,
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
/****** Object:  StoredProcedure [dbo].[ins_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_EquipmentClass]
   @ParentID       INT,
   @Description    NVARCHAR(50),
   @Location       NVARCHAR(50),
   @HierarchyScope INT,
   @EquipmentLevel NVARCHAR(50),
   @EquipmentClassID INT OUTPUT
AS
BEGIN

  IF @EquipmentClassID IS NULL
    SET @EquipmentClassID=NEXT VALUE FOR dbo.gen_EquipmentClass;

  INSERT INTO dbo.EquipmentClass(ID,
                                 ParentID,
                                 Description,
                                 Location,
                                 HierarchyScope,
                                 EquipmentLevel)
                         VALUES (@EquipmentClassID,
                                 @ParentID,
                                 @Description,
                                 @Location,
                                 @HierarchyScope,
                                 @EquipmentLevel);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_EquipmentClassProperty]
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   --@EquipmentClassProperty               INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   @EquipmentClassID                     INT,
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
/****** Object:  StoredProcedure [dbo].[ins_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_EquipmentProperty]
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
/****** Object:  StoredProcedure [dbo].[ins_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_EquipmentRequirement]
   @EquipmentClassID                   INT,
   @EquipmentID                        INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
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
/****** Object:  StoredProcedure [dbo].[ins_Files]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_Files]
   @FileName   NVARCHAR(255),
   @Encoding   NVARCHAR(255),
   @FileType   NVARCHAR(50),
   @Data       [varbinary](MAX),
   @FileID     INT OUTPUT
AS
BEGIN

  IF @FileID IS NULL
    SET @FileID=NEXT VALUE FOR dbo.gen_Files;

  INSERT INTO dbo.Files(ID,
                        FileName,
                        Encoding,
                        FileType,
                        Data)
                VALUES (@FileID,
                        @FileName,
                        @Encoding,
                        @FileType,
                        @Data);

END;

GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_MaterialActual]
   --@MaterialClassID                    INT,
   --@MaterialDefinitionID               INT,
   @MaterialLotID                      INT,
   --@MaterialSubLotID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
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
/****** Object:  StoredProcedure [dbo].[ins_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_MaterialClass]
   @ParentID                     INT,
   @Description                  NVARCHAR(50),
   @MaterialClassID INT OUTPUT
AS
BEGIN

  IF @MaterialClassID IS NULL
    SET @MaterialClassID=NEXT VALUE FOR dbo.gen_MaterialClass;

  INSERT INTO dbo.MaterialClass(ID,
                                ParentID,
                                Description)
                        VALUES (@MaterialClassID,
                                @ParentID,
                                @Description);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_MaterialDefinition]
   @Description            NVARCHAR(50),
   @Location               NVARCHAR(50),
   @HierarchyScope         INT,
   @MaterialClassID        INT,
   @MaterialDefinitionID   INT OUTPUT
AS
BEGIN

  IF @MaterialDefinitionID IS NULL
    SET @MaterialDefinitionID=NEXT VALUE FOR dbo.gen_MaterialDefinition;

  INSERT INTO dbo.MaterialDefinition(ID,
                                     Description,
                                     Location,
                                     HierarchyScope,
                                     MaterialClassID)
                             VALUES (@MaterialDefinitionID,
                                     @Description,
                                     @Location,
                                     @HierarchyScope,
                                     @MaterialClassID);

END;

GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_MaterialDefinitionProperty]
   @Description                  NVARCHAR(50),
   @Value                        NVARCHAR(50),
   --@MaterialDefinitionProperty   INT,
   --@MaterialTestSpecificationID  NVARCHAR(50),
   @MaterialDefinitionID         INT,
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
                                             MaterialDefinitionID,
                                             ClassPropertyID,
                                             PropertyType)
                                     VALUES (@MaterialDefinitionPropertyID,
                                             @Description,
                                             @Value,
                                             --@MaterialDefinitionProperty,
                                             --@MaterialTestSpecificationID,
                                             @MaterialDefinitionID,
                                             @ClassPropertyID,
                                             @PropertyType);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_MaterialLot]
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
/****** Object:  StoredProcedure [dbo].[ins_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_MaterialLotProperty]
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
/****** Object:  StoredProcedure [dbo].[ins_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ProcessSegment]
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
/****** Object:  StoredProcedure [dbo].[ins_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_ProductionParameter]
    @ProductSegmentID      INT,
    @ProcessSegmentID      INT,
    @Parameter             NVARCHAR(50),
    @PropertyType          INT,
    @ProductionParameterID INT OUTPUT
AS
BEGIN

  IF @ProductionParameterID IS NULL
    SET @ProductionParameterID=NEXT VALUE FOR dbo.gen_Property;

  INSERT INTO dbo.ProductionParameter(ID,
                                      ProductSegmentID,
                                      ProcessSegmentID,
                                      Parameter,
                                      PropertyType)
                              VALUES (@ProductionParameterID,
                                      @ProductSegmentID,
                                      @ProcessSegmentID,
                                      @Parameter,
                                      @PropertyType);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_ProductionRequest]
   @Description         NVARCHAR(50),
   --@Location            NVARCHAR(50),
   --@HierarchyScope      INT,
   @StartTime           DATETIMEOFFSET,
   @EndTime             DATETIMEOFFSET,
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
                                     1,
                                    @StartTime,
                                    @EndTime,
                                    @Priority,
                                    @RequestState,
                                    @ProductionSchedule);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_ProductionResponse]
    @ProductionRequestID  INT,
    --@Location             NVARCHAR(50),
    --@HierarchyScope       INT,
    @StartTime            DATETIMEOFFSET,
    @EndTime              DATETIMEOFFSET,
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
                                     1,
                                     @StartTime,
                                     @EndTime,
                                     @ResponseState,
                                     --@ProductionPerfomance
                                     NULL);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_ProductSegment]
   @Description         NVARCHAR(50),
   @Duration            NVARCHAR(50),
   @SegmentDependency   NVARCHAR(50),
   @ProductSegment      INT,
   @SegmentResponse     INT,
   @ProductDefinition   INT,
   @ProductSegmentID    INT OUTPUT
AS
BEGIN

  IF @ProductSegmentID IS NULL
    SET @ProductSegmentID=NEXT VALUE FOR dbo.gen_ProductSegment;

  INSERT INTO dbo.ProductSegment(ID,
                                 Description,
                                 Duration,
                                 SegmentDependency,
                                 ProductSegment,
                                 SegmentResponse,
                                 ProductDefinition)
                         VALUES (@ProductSegmentID,
                                 @Description,
                                 @Duration,
                                 @SegmentDependency,
                                 @ProductSegment,
                                 @SegmentResponse,
                                 @ProductDefinition);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ins_PropertyTypes]
   @Description       NVARCHAR(50),
   @PropertyTypesID   INT OUTPUT
AS
BEGIN

  IF @PropertyTypesID IS NULL
    SET @PropertyTypesID=NEXT VALUE FOR dbo.gen_ClassDefinitionProperty;

  INSERT INTO dbo.PropertyTypes(ID,
                                Description)
                        VALUES (@PropertyTypesID,
                                @Description);

END;


GO
/****** Object:  StoredProcedure [dbo].[ins_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_SegmentRequirement]
   @ProductSegmentID                   INT,
   @ProcessSegmentID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
   @EarliestStartTime                  DATETIMEOFFSET,
   @LatestEndTime                      DATETIMEOFFSET,
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
/****** Object:  StoredProcedure [dbo].[ins_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ins_SegmentResponse]
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
   @ActualStartTime                    DATETIMEOFFSET,
   @ActualEndTime                      DATETIMEOFFSET,
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
/****** Object:  StoredProcedure [dbo].[ins_TestOutParam]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ins_TestOutParam]
	
   @Name      NVARCHAR(50)  ,
   @Surname      NVARCHAR(50)  ,
   @FullName     NVARCHAR(100)=null OUTPUT
AS
BEGIN
 
  
 
   SET @FullName=CONCAT(@Name,' ',@Surname);


INSERT INTO [dbo].[TestOutParam]
           ([Name]
           ,[Surname]
           ,[FullName])
     VALUES
           (@Name,
           @Surname,
           @FullName);
End;

GO
/****** Object:  StoredProcedure [dbo].[ins_TestParent]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[ins_TestParent]
  
@f_nvarchar nvarchar(50),
@f_datetimeoffset datetimeoffset(7),
@f_date date,
@f_real real,
@f_bit bit 
AS
BEGIN

 

INSERT INTO [dbo].[TestParent]
           ([f_nvarchar]
           ,[f_datetimeoffset]
           ,[f_date]
           ,[f_real]
           ,[f_bit])
     VALUES
           (@f_nvarchar,
            @f_datetimeoffset,
            @f_date,
            @f_real,
            @f_bit);

 

END;



GO
/****** Object:  StoredProcedure [dbo].[upd_Equipment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_Equipment]
   @ID               INT,
   @Description      NVARCHAR(50),
   --@Location         NVARCHAR(50),
   --@HierarchyScope   INT,
   --@EquipmentLevel   NVARCHAR(50),
   --@Equipment        INT,
   @EquipmentClassID INT
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
/****** Object:  StoredProcedure [dbo].[upd_EquipmentClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_EquipmentClass]
   @ID             INT,
   @ParentID       INT,
   @Description    NVARCHAR(50),
   @Location       NVARCHAR(50),
   @HierarchyScope INT,
   @EquipmentLevel NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.EquipmentClass
  SET ParentID=@ParentID,
      Description=@Description,
      Location=@Location,
      HierarchyScope=@HierarchyScope,
      EquipmentLevel=@EquipmentLevel
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_EquipmentClassProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_EquipmentClassProperty]
   @ID                                   INT,
   @Description                          NVARCHAR(50),
   @Value                                NVARCHAR(50),
   --@EquipmentClassProperty               INT,
   --@EquipmentCapabilityTestSpecification NVARCHAR(50),
   @EquipmentClassID                     INT
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
/****** Object:  StoredProcedure [dbo].[upd_EquipmentProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_EquipmentProperty]
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
/****** Object:  StoredProcedure [dbo].[upd_EquipmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_EquipmentRequirement]
   @ID                                 INT,
   @EquipmentClassID                   INT,
   @EquipmentID                        INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
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
/****** Object:  StoredProcedure [dbo].[upd_Files]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upd_Files]
   @ID         INT,
   @FileName   NVARCHAR(255),
   @Encoding   NVARCHAR(255),
   @FileType   NVARCHAR(50),
   @Data       [varbinary](MAX)
AS
BEGIN

  UPDATE dbo.Files
  SET FileName=@FileName,
      Encoding=@Encoding,
      FileType=@FileType,
      Data=@Data
  WHERE ID=@ID;

END;

GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialActual]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_MaterialActual]
   @ID                                 INT,
   --@MaterialClassID                    INT,
   --@MaterialDefinitionID               INT,
   @MaterialLotID                      INT,
   --@MaterialSubLotID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
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
/****** Object:  StoredProcedure [dbo].[upd_MaterialClass]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_MaterialClass]
   @ID            INT,
   @ParentID      INT,
   @Description   NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.MaterialClass
  SET ParentID=@ParentID,
      Description=@Description
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialDefinition]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_MaterialDefinition]
   @ID                INT,
   @Description       NVARCHAR(50),
   @Location          NVARCHAR(50),
   @HierarchyScope    INT,
   @MaterialClassID   INT
AS
BEGIN

  UPDATE dbo.MaterialDefinition
  SET Description=@Description,
      Location=@Location,
      HierarchyScope=@HierarchyScope,
      MaterialClassID=@MaterialClassID
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_MaterialDefinitionProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_MaterialDefinitionProperty]
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
/****** Object:  StoredProcedure [dbo].[upd_MaterialLot]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_MaterialLot]
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
/****** Object:  StoredProcedure [dbo].[upd_MaterialLotProperty]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_MaterialLotProperty]
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
/****** Object:  StoredProcedure [dbo].[upd_ProcessSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_ProcessSegment]
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
/****** Object:  StoredProcedure [dbo].[upd_ProductionParameter]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upd_ProductionParameter]
    @ID               INT,
    @ProductSegmentID INT,
    @ProcessSegmentID INT,
    @Parameter        NVARCHAR(50),
    @PropertyType     INT
AS
BEGIN

  UPDATE dbo.ProductionParameter
  SET ProductSegmentID=@ProductSegmentID,
      ProcessSegmentID=@ProcessSegmentID,
      Parameter=@Parameter,
      PropertyType=@PropertyType
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_ProductionRequest]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upd_ProductionRequest]
   @ID                   INT,
   @Description         NVARCHAR(50),
   --@Location            NVARCHAR(50),
   --@HierarchyScope      INT,
   @StartTime           DATETIMEOFFSET,
   @EndTime             DATETIMEOFFSET,
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
/****** Object:  StoredProcedure [dbo].[upd_ProductionResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upd_ProductionResponse]
    @ID                   INT,
    @ProductionRequestID  INT,
    --@Location             NVARCHAR(50),
    --@HierarchyScope       INT,
    @StartTime            DATETIMEOFFSET,
    @EndTime              DATETIMEOFFSET,
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
/****** Object:  StoredProcedure [dbo].[upd_ProductSegment]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_ProductSegment]
   @ID                  INT,
   @Description         NVARCHAR(50),
   @Duration            NVARCHAR(50),
   @SegmentDependency   NVARCHAR(50),
   @ProductSegment      INT,
   @SegmentResponse     INT,
   @ProductDefinition   INT
AS
BEGIN

  UPDATE dbo.ProductSegment
  SET Description=@Description,
      Duration=@Duration,
      SegmentDependency=@SegmentDependency,
      ProductSegment=@ProductSegment,
      SegmentResponse=@SegmentResponse,
      ProductDefinition=@ProductDefinition
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_PropertyTypes]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[upd_PropertyTypes]
   @ID          INT,
   @Description NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.PropertyTypes
  SET Description=@Description
  WHERE ID=@ID;

END;


GO
/****** Object:  StoredProcedure [dbo].[upd_SegmentRequirement]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[upd_SegmentRequirement]
   @ID                                 INT,
   @ProductSegmentID                   INT,
   @ProcessSegmentID                   INT,
   @Description                        NVARCHAR(50),
   --@Location                           NVARCHAR(50),
   --@HierarchyScope                     INT,
   @EarliestStartTime                  DATETIMEOFFSET,
   @LatestEndTime                      DATETIMEOFFSET,
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
/****** Object:  StoredProcedure [dbo].[upd_SegmentResponse]    Script Date: 30.05.2016 13:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_SegmentResponse]
    @ID                                 INT,
    @Description                        NVARCHAR(50),
    --@Location                           NVARCHAR(50),
    --@HierarchyScope                     INT,
    @ActualStartTime                    DATETIMEOFFSET,
    @ActualEndTime                      DATETIMEOFFSET,
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
