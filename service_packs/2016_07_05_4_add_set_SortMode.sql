UPDATE [dbo].[WorkRequest]
SET [WorkType]=N'Standard'
WHERE [WorkType] IS NULL;

UPDATE [dbo].[WorkDefinition]
SET [WorkType]=N'Standard'
WHERE [WorkType] IS NULL;

UPDATE [dbo].[JobOrder]
SET [WorkType]=N'Standard'
WHERE [WorkType]=N'INIT';

IF EXISTS (SELECT NULL
           FROM information_schema.columns
           WHERE table_name = 'WorkRequest'
             AND column_name = 'Workype') AND 
   NOT EXISTS (SELECT NULL
               FROM information_schema.columns
               WHERE table_name = 'WorkRequest'
                  AND column_name = 'WorkType')
   EXEC sp_RENAME '[dbo].[WorkRequest].[Workype]', 'WorkType', 'COLUMN';
GO

--------------------------------------------------------------
-- Процедура ins_JobOrderInit
IF OBJECT_ID ('dbo.ins_JobOrderInit',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderInit;
GO

--------------------------------------------------------------
-- Процедура upd_JobOrderInit
IF OBJECT_ID ('dbo.upd_JobOrderInit',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderInit;
GO

--------------------------------------------------------------
-- Процедура ins_WorkDefinition
IF OBJECT_ID ('dbo.ins_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkDefinition]
@WorkType       NVARCHAR(50),
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50),
@CONTRACT_NO    NVARCHAR(50) = NULL,
@DIRECTION      NVARCHAR(50) = NULL,
@SIZE           NVARCHAR(50) = NULL,
@LENGTH         NVARCHAR(50) = NULL,
@TOLERANCE      NVARCHAR(50) = NULL,
@CLASS          NVARCHAR(50) = NULL,
@STEEL_CLASS    NVARCHAR(50) = NULL,
@MELT_NO        NVARCHAR(50) = NULL,
@PART_NO        NVARCHAR(50) = NULL,
@MIN_ROD        NVARCHAR(50) = NULL,
@BUYER_ORDER_NO NVARCHAR(50) = NULL,
@BRIGADE_NO     NVARCHAR(50) = NULL,
@PROD_DATE      NVARCHAR(50) = NULL,
@UTVK           NVARCHAR(50) = NULL,
@LEAVE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID           INT,
           @OperationsSegmentID        INT,
           @OpEquipmentSpecificationID INT,
           @err_message                NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
   ELSE IF @WorkType IN (N'Standart') AND EXISTS (SELECT NULL FROM [dbo].[v_ParameterSpecification_Order] WHERE [Value]=@COMM_ORDER AND [EquipmentID]=@EquipmentID)
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] already exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @PROD_ORDER IS NULL
    THROW 60001, N'Параметр "Производственный заказ" обязательный', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CLASS IS NULL
    THROW 60001, N'CLASS param required', 1;
   ELSE IF @STEEL_CLASS IS NULL
    THROW 60001, N'STEEL_CLASS param required', 1;
   ELSE IF @MELT_NO IS NULL
    THROW 60001, N'MELT_NO param required', 1;
   ELSE IF @PART_NO IS NULL
    THROW 60001, N'PART_NO param required', 1;
   ELSE IF @BRIGADE_NO IS NULL
    THROW 60001, N'BRIGADE_NO param required', 1;
   ELSE IF @PROD_DATE IS NULL
    THROW 60001, N'PROD_DATE param required', 1;
   ELSE IF @UTVK IS NULL
    THROW 60001, N'UTVK param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;

   SET @WorkDefinitionID=NEXT VALUE FOR [dbo].[gen_WorkDefinition];
   INSERT INTO [dbo].[WorkDefinition] ([ID],[WorkType],[PublishedDate]) VALUES (@WorkDefinitionID,@WorkType,CURRENT_TIMESTAMP);

   SET @OperationsSegmentID=NEXT VALUE FOR [dbo].[gen_OperationsSegment];
   INSERT INTO [dbo].[OperationsSegment] ([ID],[OperationsType]) VALUES (@OperationsSegmentID,N'Standard');

   SET @OpEquipmentSpecificationID=NEXT VALUE FOR [dbo].[gen_OpEquipmentSpecification];
   INSERT INTO [dbo].[OpEquipmentSpecification]([ID],[EquipmentClassID],[EquipmentID],[OperationSegmentID],[WorkDefinition])
   SELECT @OpEquipmentSpecificationID,eq.[EquipmentClassID],eq.[ID],@OperationsSegmentID,@WorkDefinitionID
   FROM [dbo].[Equipment] eq
   WHERE eq.[ID]=@EquipmentID;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   IF @WorkType IN (N'Standard')
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'STANDARD_WORK_DEFINITION_ID',
                                         @EquipmentPropertyValue = @EquipmentPropertyValue;

/*
   DECLARE @JobOrderID INT;
   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   IF @JobOrderID IS NOT NULL
      BEGIN
         INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
         SELECT CAST(@WorkDefinitionID AS NVARCHAR),@JobOrderID,pt.ID
         FROM [dbo].[PropertyTypes] pt 
         WHERE (pt.value=N'WORK_DEFINITION_ID');
      END;
*/
   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'PROD_ORDER',@PROD_ORDER WHERE @PROD_ORDER IS NOT NULL
   UNION ALL
   SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
   UNION ALL
   SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
   UNION ALL
   SELECT N'SIZE',@SIZE WHERE @SIZE IS NOT NULL
   UNION ALL
   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N'TOLERANCE',@TOLERANCE WHERE @TOLERANCE IS NOT NULL
   UNION ALL
   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
   UNION ALL
   SELECT N'MELT_NO',@MELT_NO WHERE @MELT_NO IS NOT NULL
   UNION ALL
   SELECT N'PART_NO',@PART_NO WHERE @PART_NO IS NOT NULL
   UNION ALL
   SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
   UNION ALL
   SELECT N'BUYER_ORDER_NO',@BUYER_ORDER_NO WHERE @BUYER_ORDER_NO IS NOT NULL
   UNION ALL
   SELECT N'BRIGADE_NO',@BRIGADE_NO WHERE @BRIGADE_NO IS NOT NULL
   UNION ALL
   SELECT N'PROD_DATE',@PROD_DATE WHERE @PROD_DATE IS NOT NULL
   UNION ALL
   SELECT N'UTVK',@UTVK WHERE @UTVK IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',@LEAVE_NO WHERE @LEAVE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   INSERT INTO [dbo].[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkDefinitionStandard
IF OBJECT_ID ('dbo.ins_WorkDefinitionStandard',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinitionStandard;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkDefinitionStandard]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50),
@CONTRACT_NO    NVARCHAR(50) = NULL,
@DIRECTION      NVARCHAR(50) = NULL,
@SIZE           NVARCHAR(50) = NULL,
@LENGTH         NVARCHAR(50) = NULL,
@TOLERANCE      NVARCHAR(50) = NULL,
@CLASS          NVARCHAR(50) = NULL,
@STEEL_CLASS    NVARCHAR(50) = NULL,
@MELT_NO        NVARCHAR(50) = NULL,
@PART_NO        NVARCHAR(50) = NULL,
@MIN_ROD        NVARCHAR(50) = NULL,
@BUYER_ORDER_NO NVARCHAR(50) = NULL,
@BRIGADE_NO     NVARCHAR(50) = NULL,
@PROD_DATE      NVARCHAR(50) = NULL,
@UTVK           NVARCHAR(50) = NULL,
@LEAVE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN

EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Standard',
                                @EquipmentID    = @EquipmentID,
                                @COMM_ORDER     = @COMM_ORDER,
                                @PROD_ORDER     = @PROD_ORDER,
                                @CONTRACT_NO    = @CONTRACT_NO,
                                @DIRECTION      = @DIRECTION,
                                @SIZE           = @SIZE,
                                @LENGTH         = @LENGTH,
                                @TOLERANCE      = @TOLERANCE,
                                @CLASS          = @CLASS,
                                @STEEL_CLASS    = @STEEL_CLASS,
                                @MELT_NO        = @MELT_NO,
                                @PART_NO        = @PART_NO,
                                @MIN_ROD        = @MIN_ROD,
                                @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                @BRIGADE_NO     = @BRIGADE_NO,
                                @PROD_DATE      = @PROD_DATE,
                                @UTVK           = @UTVK,
                                @LEAVE_NO       = @LEAVE_NO,
                                @MATERIAL_NO    = @MATERIAL_NO,
                                @BUNT_DIA       = @BUNT_DIA,
                                @PRODUCT        = @PRODUCT,
                                @STANDARD       = @STANDARD,
                                @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                @TEMPLATE       = @TEMPLATE;

END;
GO



--------------------------------------------------------------
-- Процедура ins_JobOrder
IF OBJECT_ID ('dbo.ins_JobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_JobOrder]
@WorkType         NVARCHAR(50),
@WorkRequestID    INT,
@EquipmentID      INT,
@ProfileID        INT          = NULL,
@COMM_ORDER       NVARCHAR(50) = NULL,
@LENGTH           NVARCHAR(50) = NULL,
@BAR_WEIGHT       NVARCHAR(50) = NULL,
@BAR_QUANTITY     NVARCHAR(50) = NULL,
@MAX_WEIGHT       NVARCHAR(50) = NULL,
@MIN_WEIGHT       NVARCHAR(50) = NULL,
@SAMPLE_WEIGHT    NVARCHAR(50) = NULL,
@SAMPLE_LENGTH    NVARCHAR(50) = NULL,
@DEVIATION        NVARCHAR(50) = NULL,
@SANDWICH_MODE    NVARCHAR(50) = NULL,
@AUTO_MANU_VALUE  NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@FACTORY_NUMBER   NVARCHAR(50) = NULL,
@JobOrderID       INT OUTPUT
AS
BEGIN

   UPDATE [dbo].[JobOrder]
   SET [WorkType]=[WorkType]+N'_archive'
   WHERE [WorkRequest]=@WorkRequestID
     AND [WorkType]=@WorkType;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest])
   VALUES (@JobOrderID,@WorkType,CURRENT_TIMESTAMP,@WorkRequestID);

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@JobOrderID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   INSERT INTO [dbo].[OpMaterialRequirement] ([MaterialClassID],[MaterialDefinitionID],[JobOrderID])
   SELECT md.[MaterialClassID],md.[ID],@JobOrderID
   FROM [dbo].[MaterialDefinition] md
   WHERE md.[ID]=@ProfileID;

   INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq 
   WHERE eq.[ID]=@EquipmentID;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N'BAR_WEIGHT',@BAR_WEIGHT WHERE @BAR_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'BAR_QUANTITY',@BAR_QUANTITY WHERE @BAR_QUANTITY IS NOT NULL
   UNION ALL
   SELECT N'MAX_WEIGHT',@MAX_WEIGHT WHERE @MAX_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'MIN_WEIGHT',@MIN_WEIGHT WHERE @MIN_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'SAMPLE_WEIGHT',@SAMPLE_WEIGHT WHERE @SAMPLE_WEIGHT IS NOT NULL
   UNION ALL
   SELECT N'SAMPLE_LENGTH',@SAMPLE_LENGTH WHERE @SAMPLE_LENGTH IS NOT NULL
   UNION ALL
   SELECT N'DEVIATION',@DEVIATION WHERE @DEVIATION IS NOT NULL
   UNION ALL
   SELECT N'SANDWICH_MODE',@SANDWICH_MODE WHERE @SANDWICH_MODE IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL
   UNION ALL
   SELECT N'NEMERA',@NEMERA WHERE @NEMERA IS NOT NULL
   UNION ALL
   SELECT N'FACTORY_NUMBER',@FACTORY_NUMBER WHERE @FACTORY_NUMBER IS NOT NULL;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT t.value,@JobOrderID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_WorkRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequest;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkRequest]
@WorkType         NVARCHAR(50),
@EquipmentID      INT,
@ProfileID        INT          = NULL,
@COMM_ORDER       NVARCHAR(50) = NULL,
@LENGTH           NVARCHAR(50) = NULL,
@BAR_WEIGHT       NVARCHAR(50) = NULL,
@BAR_QUANTITY     NVARCHAR(50) = NULL,
@MAX_WEIGHT       NVARCHAR(50) = NULL,
@MIN_WEIGHT       NVARCHAR(50) = NULL,
@SAMPLE_WEIGHT    NVARCHAR(50) = NULL,
@SAMPLE_LENGTH    NVARCHAR(50) = NULL,
@DEVIATION        NVARCHAR(50) = NULL,
@SANDWICH_MODE    NVARCHAR(50) = NULL,
@AUTO_MANU_VALUE  NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@FACTORY_NUMBER   NVARCHAR(50) = NULL,
@WorkRequestID    INT OUTPUT

AS
BEGIN

   IF @WorkType IN (N'Standard')
      BEGIN
         SELECT @WorkRequestID=jo.[WorkRequest]
         FROM [dbo].[v_Parameter_Order] po
              INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=po.[JobOrder])
         WHERE po.[Value]=@COMM_ORDER
           AND po.[EquipmentID]=@EquipmentID;
      END;

   IF @WorkRequestID IS NULL
      BEGIN
         SET @WorkRequestID=NEXT VALUE FOR [dbo].[gen_WorkRequest];

         INSERT INTO [dbo].[WorkRequest] ([ID],[StartTime],[WorkType])
         VALUES (@WorkRequestID,CURRENT_TIMESTAMP,@WorkType);
      END;

   DECLARE @JobOrderID INT;
   EXEC [dbo].[ins_JobOrder] @WorkType        = @WorkType,
                             @WorkRequestID   = @WorkRequestID,
                             @EquipmentID     = @EquipmentID,
                             @ProfileID       = @ProfileID,
                             @COMM_ORDER      = @COMM_ORDER,
                             @LENGTH          = @LENGTH,
                             @BAR_WEIGHT      = @BAR_WEIGHT,
                             @BAR_QUANTITY    = @BAR_QUANTITY,
                             @MAX_WEIGHT      = @MAX_WEIGHT,
                             @MIN_WEIGHT      = @MIN_WEIGHT,
                             @SAMPLE_WEIGHT   = @SAMPLE_WEIGHT,
                             @SAMPLE_LENGTH   = @SAMPLE_LENGTH,
                             @DEVIATION       = @DEVIATION,
                             @SANDWICH_MODE   = @SANDWICH_MODE,
                             @AUTO_MANU_VALUE = @AUTO_MANU_VALUE,
                             @NEMERA          = @NEMERA,
                             @FACTORY_NUMBER  = @FACTORY_NUMBER,
                             @JobOrderID      = @JobOrderID OUTPUT;

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkRequestStandart
IF OBJECT_ID ('dbo.ins_WorkRequestStandart',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequestStandart;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkRequestStandart]
@EquipmentID      INT,
@ProfileID        INT,
@COMM_ORDER       NVARCHAR(50),
@LENGTH           NVARCHAR(50),
@BAR_WEIGHT       NVARCHAR(50),
@BAR_QUANTITY     NVARCHAR(50),
@MAX_WEIGHT       NVARCHAR(50),
@MIN_WEIGHT       NVARCHAR(50),
@SAMPLE_WEIGHT    NVARCHAR(50),
@SAMPLE_LENGTH    NVARCHAR(50),
@DEVIATION        NVARCHAR(50),
@SANDWICH_MODE    NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50),
@NEMERA           NVARCHAR(50)
AS
BEGIN

   DECLARE @WorkRequestID INT;

   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Standard',
                                @EquipmentID     = @EquipmentID,
                                @ProfileID       = @ProfileID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @LENGTH          = @LENGTH,
                                @BAR_WEIGHT      = @BAR_WEIGHT,
                                @BAR_QUANTITY    = @BAR_QUANTITY,
                                @MAX_WEIGHT      = @MAX_WEIGHT,
                                @MIN_WEIGHT      = @MIN_WEIGHT,
                                @SAMPLE_WEIGHT   = @SAMPLE_WEIGHT,
                                @SAMPLE_LENGTH   = @SAMPLE_LENGTH,
                                @DEVIATION       = @DEVIATION,
                                @SANDWICH_MODE   = @SANDWICH_MODE,
                                @AUTO_MANU_VALUE = @AUTO_MANU_VALUE,
                                @NEMERA          = @NEMERA,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandMaxWeight] @WorkRequestID = @WorkRequestID,
                                                @EquipmentID   = @EquipmentID,
                                                @TagValue      = @MAX_WEIGHT;

   EXEC [dbo].[ins_JobOrderOPCCommandMinWeight] @WorkRequestID = @WorkRequestID,
                                                @EquipmentID   = @EquipmentID,
                                                @TagValue      = @MIN_WEIGHT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = @SANDWICH_MODE;

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = @AUTO_MANU_VALUE;

END;
GO

--------------------------------------------------------------
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_Parameter_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_Parameter_Order];
GO

CREATE VIEW [dbo].[v_Parameter_Order] WITH SCHEMABINDING
AS
SELECT p.[ID], p.[Value], p.[Description], p.[JobOrder], p.[Parameter], p.[PropertyType], er.[EquipmentID]
FROM [dbo].[Parameter] p
     INNER JOIN [dbo].[JobOrder] jo ON (jo.[ID]=p.[JobOrder] AND jo.[WorkType]=N'Standard')
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=p.[PropertyType] AND pt.[Value]=N'COMM_ORDER')
     INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=p.[JobOrder])
GO

CREATE UNIQUE CLUSTERED INDEX [u_Parameter_Order] ON [dbo].[v_Parameter_Order] ([EquipmentID],[Value])
GO
--------------------------------------------------------------
-- Процедура dbo.set_SortMode
IF OBJECT_ID ('dbo.set_SortMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_SortMode;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[set_SortMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50),
@CONTRACT_NO    NVARCHAR(50) = NULL,
@DIRECTION      NVARCHAR(50) = NULL,
@SIZE           NVARCHAR(50) = NULL,
@LENGTH         NVARCHAR(50) = NULL,
@TOLERANCE      NVARCHAR(50) = NULL,
@CLASS          NVARCHAR(50) = NULL,
@STEEL_CLASS    NVARCHAR(50) = NULL,
@MELT_NO        NVARCHAR(50) = NULL,
@PART_NO        NVARCHAR(50) = NULL,
@MIN_ROD        NVARCHAR(50) = NULL,
@BUYER_ORDER_NO NVARCHAR(50) = NULL,
@BRIGADE_NO     NVARCHAR(50) = NULL,
@PROD_DATE      NVARCHAR(50) = NULL,
@UTVK           NVARCHAR(50) = NULL,
@LEAVE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Sort',
                                   @EquipmentID    = @EquipmentID,
                                   @COMM_ORDER     = @COMM_ORDER,
                                   @PROD_ORDER     = @PROD_ORDER,
                                   @CONTRACT_NO    = @CONTRACT_NO,
                                   @DIRECTION      = @DIRECTION,
                                   @SIZE           = @SIZE,
                                   @LENGTH         = @LENGTH,
                                   @TOLERANCE      = @TOLERANCE,
                                   @CLASS          = @CLASS,
                                   @STEEL_CLASS    = @STEEL_CLASS,
                                   @MELT_NO        = @MELT_NO,
                                   @PART_NO        = @PART_NO,
                                   @MIN_ROD        = @MIN_ROD,
                                   @BUYER_ORDER_NO = @BUYER_ORDER_NO,
                                   @BRIGADE_NO     = @BRIGADE_NO,
                                   @PROD_DATE      = @PROD_DATE,
                                   @UTVK           = @UTVK,
                                   @LEAVE_NO       = @LEAVE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Sort',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'true';

END;
GO

--------------------------------------------------------------

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ParameterSpecification_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_ParameterSpecification_Order];
GO

CREATE VIEW [dbo].[v_ParameterSpecification_Order] WITH SCHEMABINDING
AS
SELECT sp.ID, sp.[Value], sp.[Description], sp.[WorkDefinitionID], oes.[EquipmentID], sp.PropertyType
FROM [dbo].[ParameterSpecification] sp
     INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=sp.[WorkDefinitionID])
     INNER JOIN [dbo].[WorkDefinition] wd ON (wd.[ID]=sp.[WorkDefinitionID] AND wd.[WorkType]=N'Standard')
     INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER')
GO

CREATE UNIQUE CLUSTERED INDEX [u_ParameterSpecification_Order] ON [dbo].[v_ParameterSpecification_Order] ([Value],[WorkDefinitionID],[EquipmentID])
GO

IF OBJECT_ID ('dbo.get_LatestWorkRequests', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_LatestWorkRequests;
GO

CREATE FUNCTION dbo.get_LatestWorkRequests(@EquipmentID INT)
RETURNS @get_LatestWorkRequests TABLE (WorkRequestID INT,
                                       JobOrderID    INT,
                                       EquipmentID   INT,
                                       ProfileID     INT,
                                       WorkType      NVARCHAR(50),
                                       PropertyType  NVARCHAR(50),
                                       Value         NVARCHAR(50))
AS
BEGIN

   DECLARE @JobOrderID       INT,
           @WorkRequestID    INT,
           @WorkDefinitionID INT,
           @ProfileID        INT,
           @WorkType         NVARCHAR(50);

   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

   SELECT @WorkRequestID=jo.[WorkRequest],
          @WorkType=wr.[WorkType],
          @ProfileID=mr.[MaterialDefinitionID]
   FROM [dbo].[JobOrder] jo
        INNER JOIN [dbo].[WorkRequest] wr ON (jo.[WorkRequest]=wr.[ID])
        LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID])
   WHERE jo.[ID]=@JobOrderID;

   INSERT @get_LatestWorkRequests
   SELECT @WorkRequestID WorkRequestID,
          par.[JobOrder] JobOrderID,
          er.[EquipmentID],
          @ProfileID ProfileID,
          @WorkType WorkType,
          pt.[Value] PropertyType,
          par.[Value]
   FROM [dbo].[Parameter] par
        INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=par.[JobOrder])
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=par.[PropertyType] AND pt.[Value] NOT IN (N'COMM_ORDER'))
   WHERE par.[JobOrder]=@JobOrderID
   UNION ALL
   SELECT @WorkRequestID,
          @JobOrderID,
          oes.[EquipmentID],
          @ProfileID ProfileID,
          @WorkType WorkType,
          pt.[Value] PropertyType,
          ps.[Value]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=ps.WorkDefinitionID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N'COMM_ORDER',N'BRIGADE_NO',N'PROD_DATE'))
   WHERE ps.[WorkDefinitionID]=@WorkDefinitionID;

RETURN;

END;
GO
---------------------------------------------------------
IF OBJECT_ID ('dbo.v_LatestWorkRequests', N'V') IS NOT NULL
   DROP VIEW dbo.v_LatestWorkRequests;
GO

CREATE VIEW [dbo].[v_LatestWorkRequests]
AS
SELECT newID() ID,
       wr.WorkRequestID,
       wr.JobOrderID,
       eq.[ID] EquipmentID,
       wr.ProfileID,
       wr.WorkType,
       wr.PropertyType,
       wr.Value
FROM dbo.Equipment eq
     CROSS APPLY dbo.get_LatestWorkRequests(eq.[ID]) wr
GO