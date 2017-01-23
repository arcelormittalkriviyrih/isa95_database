ALTER TABLE dbo.MaterialLotProperty ALTER COLUMN [Value] nvarchar(250);
GO

IF OBJECT_ID('dbo.v_MaterialLotChange', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotChange];
GO
/*
   View: v_MaterialLotChange
    Возвращает список бирок для режима изменения заказа.
*/
CREATE VIEW [dbo].[v_MaterialLotChange]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.CreateTime,
       ml.Quantity,
       eq.Equipment SideID,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       bunt_no.[Value] BUNT_NO,
       CAST(0 AS BIT) selected
FROM (SELECT ml.[ID],
             ml.[FactoryNumber],
             ml.[Status],
             ml.[Quantity],
             ml.CreateTime
      FROM (SELECT ml.[ID],
                   ml.[FactoryNumber],
                   ml.[Status],
                   ml.[Quantity],
                   ml.CreateTime,
                   ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
            FROM [dbo].[MaterialLot] ml) ml
            WHERE ml.RowNumber=1) ml
     INNER JOIN [dbo].[Equipment] eq ON (eq.ID=[dbo].[get_EquipmentIdByPropertyValue](SUBSTRING(ml.FactoryNumber,7,2),'SCALES_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] bunt_no ON (bunt_no.[MaterialLotID]=ml.[ID] AND bunt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BUNT_NO'))
;
GO


IF OBJECT_ID ('dbo.v_MaterialLotProperty', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotProperty;
GO
/*
   View: v_MaterialLotProperty
    Возвращает список свойств бирки.
	Используется в спец режимах.
*/
CREATE VIEW [dbo].[v_MaterialLotProperty]
AS
WITH MaterialLotFilt AS (SELECT ml.[ID],
                            ml.[FactoryNumber],
                            ml.[Status],
                            ml.[Quantity]
                     FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1)
SELECT mlp.[ID],
       ml.[ID] MaterialLotID,
       ml.[FactoryNumber],
       ml.[Status],
       ml.[Quantity],
       mlp.[PropertyType] PropertyID,
       pt.[Value] Property,
       mlp.[Value]
FROM MaterialLotFilt ml
     INNER JOIN [dbo].[MaterialLotProperty] mlp ON (mlp.[MaterialLotID]=ml.[ID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=mlp.[PropertyType]);
GO


IF OBJECT_ID ('dbo.v_MaterialLotReport', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotReport;
GO
/*
   View: v_MaterialLotReport
    Возвращает список бирок с информацией для отчетов.
*/
CREATE VIEW [dbo].[v_MaterialLotReport]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.Quantity,
       eq.Equipment SideID,
       TRY_CONVERT(DATETIMEOFFSET(3),prod_date.[Value],104) PROD_DATE,
       change_no.[Value] CHANGE_NO,
       brigade_no.[Value] BRIGADE_NO,
       melt_no.[Value] MELT_NO,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       auto_manu_value.[Value] AUTO_MANU_VALUE,
       create_mode.[Value] CREATE_MODE,
       TRY_CONVERT(DATETIMEOFFSET(3),measure_time.[Value],104) MEASURE_TIME,
       material_no.[Value] MATERIAL_NO,
	   (SELECT mt.Description FROM [dbo].[MaterialLinkTypes] mt WHERE mt.[ID]=ml.[Status]) StatusName
FROM (SELECT ml.[ID],
             ml.[FactoryNumber],
             ml.[Status],
             ml.[Quantity],
             ml.CreateTime
      FROM (SELECT ml.[ID],
                   ml.[FactoryNumber],
                   ml.[Status],
                   ml.[Quantity],
                   ml.CreateTime,
                   ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
            FROM [dbo].[MaterialLot] ml) ml
            WHERE ml.RowNumber=1) ml
      INNER JOIN [dbo].[Equipment] eq ON (eq.ID=[dbo].[get_EquipmentIdByPropertyValue](SUBSTRING(ml.FactoryNumber,7,2),'SCALES_NO'))
      INNER JOIN [dbo].[MaterialLotProperty] prod_date ON (prod_date.[MaterialLotID]=ml.[ID] AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_DATE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] change_no ON (change_no.[MaterialLotID]=ml.[ID] AND change_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CHANGE_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] brigade_no ON (brigade_no.[MaterialLotID]=ml.[ID] AND brigade_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BRIGADE_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] melt_no ON (melt_no.[MaterialLotID]=ml.[ID] AND melt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MELT_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] auto_manu_value ON (auto_manu_value.[MaterialLotID]=ml.[ID] AND auto_manu_value.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('AUTO_MANU_VALUE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] create_mode ON (create_mode.[MaterialLotID]=ml.[ID] AND create_mode.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CREATE_MODE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] measure_time ON (measure_time.[MaterialLotID]=ml.[ID] AND measure_time.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MEASURE_TIME'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] material_no ON (material_no.[MaterialLotID]=ml.[ID] AND material_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MATERIAL_NO'))
GO

IF OBJECT_ID('dbo.v_PrintFile', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintFile];
GO
/*
   View: v_PrintFile
    Возвращает файл для печати MaterialLot .
*/
CREATE VIEW [dbo].[v_PrintFile]
AS
     SELECT mlp.ID,
            f.Name,
            f.FileType,
            f.[Data],
            pt.[Value] Property,
            mlp.MaterialLotID
     FROM [dbo].[Files] f,
          dbo.MaterialLotProperty mlp,
          dbo.PropertyTypes pt
     WHERE ISNUMERIC(mlp.[Value] + '.0e0')=1
	       AND mlp.[Value] = f.ID
           AND mlp.PropertyType = pt.ID
           AND pt.[Value] = N'TEMPLATE';
GO

IF OBJECT_ID('dbo.v_PrintProperties', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintProperties];
GO
/*
   View: v_PrintProperties
    Возвращает свойства MaterialLot.
*/

CREATE VIEW [dbo].[v_PrintProperties]
AS
     SELECT NEWID() ID,
            mlp.MaterialLotID,
            N'MaterialLotProperty' [TypeProperty],
            pt.[Value] [PropertyCode],
            pt.[Description] [Description],
            mlp.Value
     FROM dbo.MaterialLot ml
          INNER JOIN dbo.MaterialLotProperty mlp ON(mlp.MaterialLotID = ml.ID)
          INNER JOIN dbo.PropertyTypes pt ON(pt.ID = mlp.PropertyType)
     UNION ALL
     SELECT NEWID() ID,
            ml.ID MaterialLotID,
            N'Weight' [TypeProperty],
            N'WEIGHT' [PropertyCode],
            N'Вес' [Description],
            CONVERT( NVARCHAR, ml.Quantity) Value
     FROM dbo.MaterialLot ml
     UNION ALL
     SELECT NEWID() ID,
            ml.ID MaterialLotID,
            N'FactoryNumber' [TypeProperty],
            N'FactoryNumber' [PropertyCode],
            N'Номер бирки' [Description],
            CONVERT( NVARCHAR, ml.FactoryNumber) Value
     FROM dbo.MaterialLot ml
     WHERE ml.FactoryNumber IS NOT NULL;
GO

IF OBJECT_ID('dbo.v_MaterialLotPropertySimple', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_MaterialLotPropertySimple];
GO
/*
   View: v_MaterialLotPropertySimple
    Возвращает список свойств бирки.
	Исползуется на странице бирок.
*/
CREATE VIEW [dbo].[v_MaterialLotPropertySimple]
AS
     SELECT mlp.[ID],
            mlp.[MaterialLotID],
            pt.[Description] PropertyType,
            mlp.[Value]
     FROM [dbo].[MaterialLotProperty] mlp
          INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]);
	  
GO


SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_SegmentParameter_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_SegmentParameter_Order];
GO

IF OBJECT_ID ('dbo.v_Orders', N'V') IS NOT NULL
   DROP VIEW dbo.v_Orders;
GO

IF OBJECT_ID ('dbo.v_OrderProperties', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderProperties;
GO

ALTER TABLE dbo.SegmentParameter ALTER COLUMN [Value] nvarchar(250);
GO

/*
   View: v_SegmentParameter_Order
    Возвращает свойства заказа.
*/
CREATE VIEW [dbo].[v_SegmentParameter_Order] WITH SCHEMABINDING
AS
SELECT sp.ID, sp.[Value], sp.[Description], sp.OperationsSegment, sp.Parameter, sp.OpSegmentRequirement, sp.PropertyType
FROM [dbo].[SegmentParameter] sp
     INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER')
GO

CREATE UNIQUE CLUSTERED INDEX [u_SegmentParameter_Order] ON [dbo].[v_SegmentParameter_Order] (Value)
GO


/*
   View: v_OrderProperties
    Возвращает список свойств заказа.
	Используется на странице заказов.
*/
CREATE VIEW [dbo].[v_OrderProperties]
AS
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       sr.OperationsRequest,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType AND pt.[Value] IN ('PROD_ORDER','SIZE','LENGTH','TOLERANCE','CLASS','STEEL_CLASS','MELT_NO','PART_NO','MIN_ROD','BUYER_ORDER_NO','BRIGADE_NO','PROD_DATE','UTVK','CHANGE_NO','MATERIAL_NO','BUNT_DIA','PRODUCT','STANDARD','CHEM_ANALYSIS', 'BUNT_NO'))

GO

IF OBJECT_ID ('dbo.v_OrderPropertiesAll', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderPropertiesAll;
GO
/*
   View: v_OrderPropertiesAll
    Возвращает список свойств заказа.
	Используется на форме создания/редактирования заказа.
*/
CREATE VIEW [dbo].[v_OrderPropertiesAll]
AS
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       sr.OperationsRequest,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
GO


/*
   View: v_Orders
    Возвращает список заказов.
*/
CREATE VIEW [dbo].[v_Orders]
AS
select opr.id,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='COMM_ORDER') as COMM_ORDER,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='CONTRACT_NO') as CONTRACT_NO,
(select sp.value from SegmentParameter sp, PropertyTypes pt where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='DIRECTION') as DIRECTION,
(select f.Name from SegmentParameter sp, PropertyTypes pt, Files f where pt.ID=sp.PropertyType and sp.OpSegmentRequirement=sr.id and pt.Value='TEMPLATE' and sp.value=f.ID) as TEMPLATE
from OperationsRequest as opr,
OpSegmentRequirement sr
where opr.ID=sr.OperationsRequest;
GO





IF OBJECT_ID ('dbo.v_LatestWorkRequests', N'V') IS NOT NULL
   DROP VIEW dbo.v_LatestWorkRequests;
GO

IF OBJECT_ID ('dbo.v_ParameterSpecification_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_ParameterSpecification_Order];
GO

IF OBJECT_ID ('dbo.get_LatestWorkRequests', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_LatestWorkRequests;
GO

--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'T') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

IF OBJECT_ID (@name_scheme+'.ParameterSpecification', 'T') IS NOT NULL
begin
	SET @query = N'ALTER TABLE '+@name_scheme+'.ParameterSpecification ALTER COLUMN [Value] nvarchar(250);'
	exec(@query);
end


/*
   View: v_ParameterSpecification_Order
    Возвращает список свойств WorkDefinition.
*/
SET @query = N'CREATE VIEW [dbo].[v_ParameterSpecification_Order] WITH SCHEMABINDING
	AS
	SELECT sp.ID, sp.[Value], sp.[Description], sp.[WorkDefinitionID], oes.[EquipmentID], sp.PropertyType
	FROM '+@name_scheme+'.[ParameterSpecification] sp
		 INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=sp.[WorkDefinitionID])
		 INNER JOIN [dbo].[WorkDefinition] wd ON (wd.[ID]=sp.[WorkDefinitionID] AND wd.[WorkType]=N''Standard'')
		 INNER JOIN[dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N''COMM_ORDER'')'
exec(@query);

--| ERROR	Index cannot be created on view 'v_ParameterSpecification_Order' because the underlying object 'ParameterSpecification' has a different owner.
--CREATE UNIQUE CLUSTERED INDEX [u_ParameterSpecification_Order] ON [dbo].[v_ParameterSpecification_Order] ([Value],[WorkDefinitionID],[EquipmentID])
go

/*
   Function: get_LatestWorkRequests

   Получает свойства Work Request(Job Order) по ID весов.

   Parameters:

      EquipmentID - ID весов
     
   Returns:

      TABLE (WorkRequestID INT,
             JobOrderID    INT,
             EquipmentID   INT,
             ProfileID     INT,
             WorkType      NVARCHAR(50),
             PropertyType  NVARCHAR(50),
             Value         NVARCHAR(250)).

*/
--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'T') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

SET @query = N'CREATE FUNCTION dbo.get_LatestWorkRequests(@EquipmentID INT)
RETURNS @get_LatestWorkRequests TABLE (WorkRequestID INT,
                                       JobOrderID    INT,
                                       EquipmentID   INT,
                                       ProfileID     INT,
                                       WorkType      NVARCHAR(50),
                                       PropertyType  NVARCHAR(50),
                                       Value         NVARCHAR(250))
AS
BEGIN

   DECLARE @JobOrderID       INT,
           @WorkRequestID    INT,
           @WorkDefinitionID INT,
           @ProfileID        INT,
           @WorkType         NVARCHAR(50),
           @PacksLeft        NVARCHAR(50);

   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N''JOB_ORDER_ID'');
   SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N''WORK_DEFINITION_ID'');

   SELECT @WorkRequestID=jo.[WorkRequest],
          @WorkType=wr.[WorkType],
          @ProfileID=mr.[MaterialDefinitionID]
   FROM [dbo].[JobOrder] jo
        INNER JOIN [dbo].[WorkRequest] wr ON (jo.[WorkRequest]=wr.[ID])
        LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID] AND mr.[MaterialClassID]=dbo.get_MaterialClassIDByCode(N''PROFILE''))
   WHERE jo.[ID]=@JobOrderID;

   INSERT @get_LatestWorkRequests
   SELECT @WorkRequestID WorkRequestID,
          par.[JobOrder] JobOrderID,
          er.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N''Standard'') WorkType,
          pt.[Value] PropertyType,
          par.[Value]
   FROM [dbo].[Parameter] par
        INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=par.[JobOrder])
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=par.[PropertyType] AND pt.[Value] NOT IN (N''COMM_ORDER''))
   WHERE par.[JobOrder]=@JobOrderID
   UNION ALL
   SELECT @WorkRequestID,
          @JobOrderID,
          oes.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N''Standard'') WorkType,
          pt.[Value] PropertyType,
          ps.[Value]
   FROM '+@name_scheme+'.[ParameterSpecification] ps
        INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=ps.WorkDefinitionID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N''COMM_ORDER'',N''BRIGADE_NO'',N''PROD_DATE''))
   WHERE ps.[WorkDefinitionID]=@WorkDefinitionID;

RETURN;

END;'
exec(@query);
go

/*
   View: v_LatestWorkRequests
   Возвращает текущий LatestWorkRequest для весов.
*/
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

-- 
IF OBJECT_ID ('dbo.get_WorkDefinitionPropertiesAll', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_WorkDefinitionPropertiesAll;
GO
/*
   Function: get_WorkDefinitionPropertiesAll

   Получает свойства WorkDefinition по COMM_ORDER.

   Parameters:

      COMM_ORDER - Коммерческий заказ
     
   Returns:

      TABLE (ID               INT,
             Description      NVARCHAR(50),
             Value            NVARCHAR(250),
             WorkDefinitionID INT,
             Property         NVARCHAR(50)).

*/
--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'T') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

set @query = N'CREATE FUNCTION dbo.get_WorkDefinitionPropertiesAll(@COMM_ORDER NVARCHAR(50))
RETURNS @retWorkDefinitionPropertiesAll TABLE (ID               INT,
                                               Description      NVARCHAR(50),
                                               Value            NVARCHAR(250),
                                               WorkDefinitionID INT,
                                               Property         NVARCHAR(50))
AS
BEGIN

   DECLARE @WorkDefinitionID     INT,
           @OpSegmentRequirement INT;

   SELECT @WorkDefinitionID=ps.[WorkDefinitionID]
   FROM '+@name_scheme+'.[ParameterSpecification] ps
        INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=ps.[PropertyType] AND ptco.[Value]=N''COMM_ORDER'')
   WHERE ps.[Value]=@COMM_ORDER;

  IF NOT @WorkDefinitionID IS NULL
     BEGIN 
        INSERT @retWorkDefinitionPropertiesAll
           SELECT ps.[ID],
                  pt.[Description],
                  ps.[Value],
                  ps.[WorkDefinitionID],
                  pt.[Value]
           FROM '+@name_scheme+'.[ParameterSpecification] ps
                INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
           WHERE ps.[WorkDefinitionID]=@WorkDefinitionID
     END
  ELSE
     BEGIN
        SELECT @OpSegmentRequirement=sp.[OpSegmentRequirement]
        FROM [dbo].[SegmentParameter] sp
             INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=sp.[PropertyType] AND ptco.[Value]=N''COMM_ORDER'')
        WHERE sp.[Value]=@COMM_ORDER;

        INSERT @retWorkDefinitionPropertiesAll
          SELECT sp.ID,
                 pt.Description,
                 sp.[Value],
                 NULL,
                 pt.[Value] Property
          FROM dbo.OpSegmentRequirement sr
               INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
               INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
          WHERE sr.[ID]=@OpSegmentRequirement;
     END

  RETURN;

END;'
exec(@query)
GO


--------------------------------------------------------------
-- Процедура для печати перемаркированой бирки ins_MaterialLotByFactoryNumber
IF OBJECT_ID ('dbo.ins_MaterialLotByFactoryNumber',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByFactoryNumber;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotByFactoryNumber
	Используется для режима перемаркировки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки,
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotByFactoryNumber]
@EquipmentID     INT,
@FACTORY_NUMBER  NVARCHAR(50),
@COMM_ORDER      NVARCHAR(250) = NULL,
@PROD_ORDER      NVARCHAR(250) = NULL,
@CONTRACT_NO     NVARCHAR(250) = NULL,
@DIRECTION       NVARCHAR(250) = NULL,
@SIZE            NVARCHAR(250) = NULL,
@LENGTH          NVARCHAR(250) = NULL,
@TOLERANCE       NVARCHAR(250) = NULL,
@CLASS           NVARCHAR(250) = NULL,
@STEEL_CLASS     NVARCHAR(250) = NULL,
@MELT_NO         NVARCHAR(250) = NULL,
@PART_NO         NVARCHAR(250) = NULL,
@MIN_ROD         NVARCHAR(250) = NULL,
@BUYER_ORDER_NO  NVARCHAR(250) = NULL,
@BRIGADE_NO      NVARCHAR(250) = NULL,
@PROD_DATE       NVARCHAR(250) = NULL,
@UTVK            NVARCHAR(250) = NULL,
@CHANGE_NO       NVARCHAR(250) = NULL,
@MATERIAL_NO     NVARCHAR(250) = NULL,
@BUNT_DIA        NVARCHAR(250) = NULL,
@BUNT_NO         NVARCHAR(250) = NULL,
@PRODUCT         NVARCHAR(250) = NULL,
@STANDARD        NVARCHAR(250) = NULL,
@CHEM_ANALYSIS   NVARCHAR(250) = NULL,
@TEMPLATE        NVARCHAR(50) = NULL
AS
BEGIN

   IF @TEMPLATE IS NULL
      THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @COMM_ORDER IS NULL
      THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;

	 BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @MaterialLotID       INT,
           @PrinterID           NVARCHAR(50),
           @err_message         NVARCHAR(255);

   EXEC [dbo].[ins_MaterialLotWithLinks] @FactoryNumber = @FACTORY_NUMBER,
                                         @Status        = N'1',
                                         @MaterialLotID = @MaterialLotID OUTPUT;

   DECLARE @MILL_ID NVARCHAR(50),
           @MEASURE_TIME NVARCHAR(50);
   SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');
   SET @MEASURE_TIME=FORMAT(CURRENT_TIMESTAMP, 'dd.MM.yyyy HH:mm:ss');

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@COMM_ORDER AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @COMM_ORDER IS NOT NULL
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
   SELECT N'CHANGE_NO',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',@TEMPLATE WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
   EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                       @MaterialLotID = @MaterialLotID,
                                       @Command       = N'Print';

END;
GO

--------------------------------------------------------------
-- Процедура для тестовой печати бирки ins_MaterialLotForTestPrint
IF OBJECT_ID ('dbo.ins_MaterialLotForTestPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotForTestPrint;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotForTestPrint
	Используется для тестовой печати.

	Parameters:

		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotForTestPrint]
@COMM_ORDER      NVARCHAR(250) = NULL,
@PROD_ORDER      NVARCHAR(250) = NULL,
@CONTRACT_NO     NVARCHAR(250) = NULL,
@DIRECTION       NVARCHAR(250) = NULL,
@SIZE            NVARCHAR(250) = NULL,
@LENGTH          NVARCHAR(250) = NULL,
@TOLERANCE       NVARCHAR(250) = NULL,
@CLASS           NVARCHAR(250) = NULL,
@STEEL_CLASS     NVARCHAR(250) = NULL,
@MELT_NO         NVARCHAR(250) = NULL,
@PART_NO         NVARCHAR(250) = NULL,
@MIN_ROD         NVARCHAR(250) = NULL,
@BUYER_ORDER_NO  NVARCHAR(250) = NULL,
@BRIGADE_NO      NVARCHAR(250) = NULL,
@PROD_DATE       NVARCHAR(250) = NULL,
@UTVK            NVARCHAR(250) = NULL,
@CHANGE_NO       NVARCHAR(250) = NULL,
@MATERIAL_NO     NVARCHAR(250) = NULL,
@BUNT_DIA        NVARCHAR(250) = NULL,
@BUNT_NO         NVARCHAR(250) = NULL,
@PRODUCT         NVARCHAR(250) = NULL,
@STANDARD        NVARCHAR(250) = NULL,
@CHEM_ANALYSIS   NVARCHAR(250) = NULL,
@TEMPLATE        NVARCHAR(50) = NULL
AS
BEGIN

DECLARE @MaterialLotID INT;

DECLARE @PrinterID NVARCHAR(50);

SET @PrinterID = (SELECT pp.[Value]
                                FROM [dbo].[PersonProperty] pp
                                    INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'TEST_PRINTER')
                                WHERE pp.[PersonID]=[dbo].[get_CurrentPerson]())
IF @PrinterID IS NULL
THROW 60001, N'Тестовый принтер не указан в настройках!', 1;

IF @COMM_ORDER IS NOT NULL
	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

EXEC [dbo].[ins_MaterialLot] @FactoryNumber = N'0',
                             @Status        = N'0',
                             @Quantity      = NULL,
                             @MaterialLotID = @MaterialLotID OUTPUT;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   INSERT @tblParams
   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@COMM_ORDER AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @COMM_ORDER IS NOT NULL
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
   SELECT N'CHANGE_NO',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',@TEMPLATE WHERE @TEMPLATE IS NOT NULL
   UNION ALL
   SELECT N'CREATOR',SYSTEM_USER
   UNION ALL
   SELECT N'CREATE_MODE',N'Тестовая печать';

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   
    EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                        @MaterialLotID = @MaterialLotID,
                                        @Command       = N'Print';  

END;
GO

--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_Order;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_Order
	Процедура добаления заказа.

	Parameters:

		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[ins_Order]
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250) = NULL,
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @OperationsRequestID     INT,
           @OpSegmentRequirementID  INT,
           @err_message             NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
   ELSE IF EXISTS (SELECT NULL FROM [dbo].[v_SegmentParameter_Order] WHERE [Value]=@COMM_ORDER)
      BEGIN
         SET @err_message = N'Заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] уже существует';
         THROW 60010, @err_message, 1;
      END;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
	
	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   SET @OperationsRequestID=NEXT VALUE FOR [dbo].[gen_OperationsRequest];
   INSERT INTO [dbo].[OperationsRequest] ([ID]) VALUES (@OperationsRequestID);

   SET @OpSegmentRequirementID=NEXT VALUE FOR [dbo].[gen_OpSegmentRequirement];
   INSERT INTO [dbo].[OpSegmentRequirement] ([ID],[OperationsRequest]) VALUES (@OpSegmentRequirementID,@OperationsRequestID);

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
   SELECT N'CHANGE_NO',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

--------------------------------------------------------------
-- Процедура ins_WorkDefinition
IF OBJECT_ID ('dbo.ins_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkDefinition
	Процедура добаления WorkDefinition.

	Parameters:

		WorkType	   - Режим,
		EquipmentID    - ID весов,
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'T') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

set @query = N'CREATE PROCEDURE [dbo].[ins_WorkDefinition]
@WorkType       NVARCHAR(50),
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID           INT,
           @OperationsSegmentID        INT,
           @OpEquipmentSpecificationID INT,
           @err_message                NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   IF @COMM_ORDER IS NULL
    THROW 60001, N''Параметр "Коммерческий заказ" обязательный'', 1;
   ELSE IF @WorkType IN (N''Standart'') AND EXISTS (SELECT NULL FROM [dbo].[v_ParameterSpecification_Order] WHERE [Value]=@COMM_ORDER AND [EquipmentID]=@EquipmentID)
      BEGIN
         SET @err_message = N''WorkDefinition ['' + CAST(@COMM_ORDER AS NVARCHAR) + N''] already exists'';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @PROD_ORDER IS NULL
    THROW 60001, N''Параметр "Производственный заказ" обязательный'', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N''CONTRACT_NO param required'', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N''DIRECTION param required'', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N''SIZE param required'', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N''LENGTH param required'', 1;
   ELSE IF @CLASS IS NULL
    THROW 60001, N''CLASS param required'', 1;
   ELSE IF @STEEL_CLASS IS NULL
    THROW 60001, N''STEEL_CLASS param required'', 1;
   ELSE IF @MELT_NO IS NULL
    THROW 60001, N''MELT_NO param required'', 1;
   ELSE IF @PART_NO IS NULL
    THROW 60001, N''PART_NO param required'', 1;
   ELSE IF @BRIGADE_NO IS NULL
    THROW 60001, N''BRIGADE_NO param required'', 1;
   ELSE IF @PROD_DATE IS NULL
    THROW 60001, N''PROD_DATE param required'', 1;
   ELSE IF @UTVK IS NULL
    THROW 60001, N''UTVK param required'', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N''Параметр "Шаблон бирки" обязательный'', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N''Excel label'' AND [ID]=@TEMPLATE)
      THROW 60010, N''Указанный Excel шаблон не существует в таблице Files'', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N''Параметр "Коммерческий заказ" должен быть числом'', 1;
	END CATCH;

   SET @WorkDefinitionID=NEXT VALUE FOR [dbo].[gen_WorkDefinition];
   INSERT INTO [dbo].[WorkDefinition] ([ID],[WorkType],[PublishedDate]) VALUES (@WorkDefinitionID,@WorkType,CURRENT_TIMESTAMP);

   SET @OperationsSegmentID=NEXT VALUE FOR [dbo].[gen_OperationsSegment];
   INSERT INTO [dbo].[OperationsSegment] ([ID],[OperationsType]) VALUES (@OperationsSegmentID,N''Standard'');

   SET @OpEquipmentSpecificationID=NEXT VALUE FOR [dbo].[gen_OpEquipmentSpecification];
   INSERT INTO [dbo].[OpEquipmentSpecification]([ID],[EquipmentClassID],[EquipmentID],[OperationSegmentID],[WorkDefinition])
   SELECT @OpEquipmentSpecificationID,eq.[EquipmentClassID],eq.[ID],@OperationsSegmentID,@WorkDefinitionID
   FROM [dbo].[Equipment] eq
   WHERE eq.[ID]=@EquipmentID;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N''WORK_DEFINITION_ID'',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   IF @WorkType IN (N''Standard'')
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N''STANDARD_WORK_DEFINITION_ID'',
                                         @EquipmentPropertyValue = @EquipmentPropertyValue;

/*
   DECLARE @JobOrderID INT;
   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N''JOB_ORDER_ID'');
   IF @JobOrderID IS NOT NULL
      BEGIN
         INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
         SELECT CAST(@WorkDefinitionID AS NVARCHAR),@JobOrderID,pt.ID
         FROM [dbo].[PropertyTypes] pt 
         WHERE (pt.value=N''WORK_DEFINITION_ID'');
      END;
*/
   INSERT @tblParams
   SELECT N''COMM_ORDER'',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N''PROD_ORDER'',@PROD_ORDER WHERE @PROD_ORDER IS NOT NULL
   UNION ALL
   SELECT N''CONTRACT_NO'',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
   UNION ALL
   SELECT N''DIRECTION'',@DIRECTION WHERE @DIRECTION IS NOT NULL
   UNION ALL
   SELECT N''SIZE'',@SIZE WHERE @SIZE IS NOT NULL
   UNION ALL
   SELECT N''LENGTH'',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N''TOLERANCE'',@TOLERANCE WHERE @TOLERANCE IS NOT NULL
   UNION ALL
   SELECT N''CLASS'',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N''STEEL_CLASS'',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
   UNION ALL
   SELECT N''MELT_NO'',@MELT_NO WHERE @MELT_NO IS NOT NULL
   UNION ALL
   SELECT N''PART_NO'',@PART_NO WHERE @PART_NO IS NOT NULL
   UNION ALL
   SELECT N''MIN_ROD'',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
   UNION ALL
   SELECT N''BUYER_ORDER_NO'',@BUYER_ORDER_NO WHERE @BUYER_ORDER_NO IS NOT NULL
   UNION ALL
   SELECT N''BRIGADE_NO'',@BRIGADE_NO WHERE @BRIGADE_NO IS NOT NULL
   UNION ALL
   SELECT N''PROD_DATE'',@PROD_DATE WHERE @PROD_DATE IS NOT NULL
   UNION ALL
   SELECT N''UTVK'',@UTVK WHERE @UTVK IS NOT NULL
   UNION ALL
   SELECT N''CHANGE_NO'',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N''MATERIAL_NO'',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N''BUNT_DIA'',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N''BUNT_NO'',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N''PRODUCT'',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N''STANDARD'',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N''CHEM_ANALYSIS'',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N''TEMPLATE'',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   INSERT INTO '+@name_scheme+'.[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;'
exec(@query)
GO

--------------------------------------------------------------
-- Процедура ins_WorkDefinitionStandard
IF OBJECT_ID ('dbo.ins_WorkDefinitionStandard',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinitionStandard;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkDefinitionStandard
	Процедура добаления стандартного WorkDefinition.

	Parameters:

		EquipmentID    - ID весов,
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.

	See Also:

		<ins_WorkDefinition>

*/
CREATE PROCEDURE [dbo].[ins_WorkDefinitionStandard]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
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
                                @CHANGE_NO      = @CHANGE_NO,
                                @MATERIAL_NO    = @MATERIAL_NO,
                                @BUNT_DIA       = @BUNT_DIA,
                                @BUNT_NO        = @BUNT_NO,
                                @PRODUCT        = @PRODUCT,
                                @STANDARD       = @STANDARD,
                                @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                @TEMPLATE       = @TEMPLATE;

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_RejectMode
IF OBJECT_ID ('dbo.set_RejectMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_RejectMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_RejectMode
	Процедура установки режима отбраковки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[set_RejectMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Reject',
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
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Reject',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_SeparateMode
IF OBJECT_ID ('dbo.set_SeparateMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_SeparateMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_SeparateMode
	Процедура установки режима разделения пачки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		PACKS_LEFT	   - Количество пачек,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[set_SeparateMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@PACKS_LEFT     NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN

   EXEC [dbo].[ins_WorkDefinition] @WorkType       = N'Separate',
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
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
                                   @PRODUCT        = @PRODUCT,
                                   @STANDARD       = @STANDARD,
                                   @CHEM_ANALYSIS  = @CHEM_ANALYSIS,
                                   @TEMPLATE       = @TEMPLATE;

   DECLARE @WorkRequestID INT;
   EXEC [dbo].[ins_WorkRequest] @WorkType        = N'Separate',
                                @EquipmentID     = @EquipmentID,
                                @COMM_ORDER      = @COMM_ORDER,
                                @FACTORY_NUMBER  = @FACTORY_NUMBER,
                                @PACKS_LEFT      = @PACKS_LEFT,
                                @WorkRequestID   = @WorkRequestID OUTPUT;

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO

--------------------------------------------------------------
-- Процедура dbo.set_SortMode
IF OBJECT_ID ('dbo.set_SortMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_SortMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_SortMode
	Процедура установки режима сортировки.

	Parameters:

		EquipmentID    - ID весов,
		FACTORY_NUMBER - Номер бирки
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
CREATE PROCEDURE [dbo].[set_SortMode]
@EquipmentID    INT,
@FACTORY_NUMBER NVARCHAR(50),
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
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
                                   @CHANGE_NO      = @CHANGE_NO,
                                   @MATERIAL_NO    = @MATERIAL_NO,
                                   @BUNT_DIA       = @BUNT_DIA,
                                   @BUNT_NO        = @BUNT_NO,
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

   EXEC [dbo].[ins_JobOrderOPCCommandSandwich] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO


--------------------------------------------------------------
-- Процедура upd_Order
IF OBJECT_ID ('dbo.upd_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_Order;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_Order
	Процедура изменения заказа.

	Parameters:

		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/

CREATE PROCEDURE [dbo].[upd_Order] 
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250) = NULL,
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N'SIZE param required', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'Параметр "Шаблон бирки" обязательный', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   SELECT @OpSegmentRequirementID=spo.OpSegmentRequirement
   FROM [dbo].[v_SegmentParameter_Order] spo
   WHERE spo.Value=@COMM_ORDER;

   IF @OpSegmentRequirementID IS NULL
      BEGIN
         SET @err_message = N'Коммерческий заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] не найден';
         THROW 60010, @err_message, 1;
      END;

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
   SELECT N'CHANGE_NO',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_NO',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'BUNT_NO',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   DELETE FROM [dbo].[SegmentParameter]
   WHERE [OpSegmentRequirement]=@OpSegmentRequirementID;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);
   
   /*
   MERGE [dbo].[SegmentParameter] sp
   USING (SELECT t.value,pt.ID
          FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
   ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
   WHEN MATCHED THEN
      UPDATE SET sp.[Value]=tt.value
   WHEN NOT MATCHED THEN
      INSERT ([Value],[OpSegmentRequirement],[PropertyType])
      VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
   */

END;
GO

--------------------------------------------------------------
-- Процедура upd_WorkDefinition
IF OBJECT_ID ('dbo.upd_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_WorkDefinition
	Процедура изменения WorkDefinition.

	Parameters:

		EquipmentID    - ID весов,
		COMM_ORDER     - Коммерческий заказ,
		PROD_ORDER     - Производственный заказ,
		CONTRACT_NO    - Контракт №,
		DIRECTION      - Направление,
		SIZE           - Размер,
		LENGTH         - Длина,
		TOLERANCE      - Допуск,
		CLASS          - Класс,
		STEEL_CLASS    - Марка стали,
		MELT_NO        - Плавка,
		PART_NO        - Партия,
		MIN_ROD        - Количество прутков,
		BUYER_ORDER_NO - № заказа у покупателя,
		BRIGADE_NO     - Бригада,
		PROD_DATE      - Производственная дата,
		UTVK           - УТВК,
		CHANGE_NO      - Смена,
		MATERIAL_NO    - № материала,
		BUNT_DIA       - Диаметр бунта,
		BUNT_NO        - № бунта,
		PRODUCT        - Продукция,
		STANDARD       - Стандарт,
		CHEM_ANALYSIS  - Хим. Анализ,
		TEMPLATE       - Шаблон бирки.
*/
--| for test scheme
declare @name_scheme nvarchar(100) = N'dbo', @query nvarchar(max) = '';

IF OBJECT_ID ('dbo.ParameterSpecification', 'T') IS NULL
	SET @name_scheme = N'ISA95_OPERATION_DEFINITION';

set @query = N'CREATE PROCEDURE [dbo].[upd_WorkDefinition]
@EquipmentID    INT,
@COMM_ORDER     NVARCHAR(250),
@PROD_ORDER     NVARCHAR(250),
@CONTRACT_NO    NVARCHAR(250) = NULL,
@DIRECTION      NVARCHAR(250) = NULL,
@SIZE           NVARCHAR(250) = NULL,
@LENGTH         NVARCHAR(250) = NULL,
@TOLERANCE      NVARCHAR(250) = NULL,
@CLASS          NVARCHAR(250) = NULL,
@STEEL_CLASS    NVARCHAR(250) = NULL,
@MELT_NO        NVARCHAR(250) = NULL,
@PART_NO        NVARCHAR(250) = NULL,
@MIN_ROD        NVARCHAR(250) = NULL,
@BUYER_ORDER_NO NVARCHAR(250) = NULL,
@BRIGADE_NO     NVARCHAR(250) = NULL,
@PROD_DATE      NVARCHAR(250) = NULL,
@UTVK           NVARCHAR(250) = NULL,
@CHANGE_NO      NVARCHAR(250) = NULL,
@MATERIAL_NO    NVARCHAR(250) = NULL,
@BUNT_DIA       NVARCHAR(250) = NULL,
@BUNT_NO        NVARCHAR(250) = NULL,
@PRODUCT        NVARCHAR(250) = NULL,
@STANDARD       NVARCHAR(250) = NULL,
@CHEM_ANALYSIS  NVARCHAR(250) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID     INT,
           @err_message          NVARCHAR(255);

   IF @COMM_ORDER IS NULL
    THROW 60001, N''Параметр "Коммерческий заказ" обязательный'', 1;
   ELSE IF @PROD_ORDER IS NULL
    THROW 60001, N''Параметр "Производственный заказ" обязательный'', 1;
/*   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N''CONTRACT_NO param required'', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N''DIRECTION param required'', 1;
   ELSE IF @SIZE IS NULL
    THROW 60001, N''SIZE param required'', 1;
   ELSE IF @LENGTH IS NULL
    THROW 60001, N''LENGTH param required'', 1;
   ELSE IF @CLASS IS NULL
    THROW 60001, N''CLASS param required'', 1;
   ELSE IF @STEEL_CLASS IS NULL
    THROW 60001, N''STEEL_CLASS param required'', 1;
   ELSE IF @MELT_NO IS NULL
    THROW 60001, N''MELT_NO param required'', 1;
   ELSE IF @PART_NO IS NULL
    THROW 60001, N''PART_NO param required'', 1;
   ELSE IF @BRIGADE_NO IS NULL
    THROW 60001, N''BRIGADE_NO param required'', 1;
   ELSE IF @PROD_DATE IS NULL
    THROW 60001, N''PROD_DATE param required'', 1;
   ELSE IF @UTVK IS NULL
    THROW 60001, N''UTVK param required'', 1;*/
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N''Параметр "Шаблон бирки" обязательный'', 1;
   ELSE IF @TEMPLATE IS NOT NULL AND NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N''Excel label'' AND [ID]=@TEMPLATE)
      THROW 60010, N''Указанный Excel шаблон не существует в таблице Files'', 1;

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N''Параметр "Коммерческий заказ" должен быть числом'', 1;
	END CATCH;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(250));

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.[Value]=@COMM_ORDER
     AND pso.[EquipmentID]=@EquipmentID;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N''WorkDefinition ['' + CAST(@COMM_ORDER AS NVARCHAR) + N''] not found'';
         THROW 60010, @err_message, 1;
      END;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N''WORK_DEFINITION_ID'',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

   INSERT @tblParams
   SELECT N''COMM_ORDER'',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
   UNION ALL
   SELECT N''PROD_ORDER'',@PROD_ORDER WHERE @PROD_ORDER IS NOT NULL
   UNION ALL
   SELECT N''CONTRACT_NO'',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
   UNION ALL
   SELECT N''DIRECTION'',@DIRECTION WHERE @DIRECTION IS NOT NULL
   UNION ALL
   SELECT N''SIZE'',@SIZE WHERE @SIZE IS NOT NULL
   UNION ALL
   SELECT N''LENGTH'',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N''TOLERANCE'',@TOLERANCE WHERE @TOLERANCE IS NOT NULL
   UNION ALL
   SELECT N''CLASS'',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N''STEEL_CLASS'',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
   UNION ALL
   SELECT N''MELT_NO'',@MELT_NO WHERE @MELT_NO IS NOT NULL
   UNION ALL
   SELECT N''PART_NO'',@PART_NO WHERE @PART_NO IS NOT NULL
   UNION ALL
   SELECT N''MIN_ROD'',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
   UNION ALL
   SELECT N''BUYER_ORDER_NO'',@BUYER_ORDER_NO WHERE @BUYER_ORDER_NO IS NOT NULL
   UNION ALL
   SELECT N''BRIGADE_NO'',@BRIGADE_NO WHERE @BRIGADE_NO IS NOT NULL
   UNION ALL
   SELECT N''PROD_DATE'',@PROD_DATE WHERE @PROD_DATE IS NOT NULL
   UNION ALL
   SELECT N''UTVK'',@UTVK WHERE @UTVK IS NOT NULL
   UNION ALL
   SELECT N''CHANGE_NO'',@CHANGE_NO WHERE @CHANGE_NO IS NOT NULL
   UNION ALL
   SELECT N''MATERIAL_NO'',@MATERIAL_NO WHERE @MATERIAL_NO IS NOT NULL
   UNION ALL
   SELECT N''BUNT_DIA'',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N''BUNT_NO'',@BUNT_NO WHERE @BUNT_NO IS NOT NULL
   UNION ALL
   SELECT N''PRODUCT'',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N''STANDARD'',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N''CHEM_ANALYSIS'',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N''TEMPLATE'',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   DELETE FROM '+@name_scheme+'.[ParameterSpecification]
   WHERE [WorkDefinitionID]=@WorkDefinitionID;

   INSERT INTO '+@name_scheme+'.[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
   SELECT t.value,@WorkDefinitionID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);
   
   /*
   MERGE [dbo].[SegmentParameter] sp
   USING (SELECT t.value,pt.ID
          FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
   ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
   WHEN MATCHED THEN
      UPDATE SET sp.[Value]=tt.value
   WHEN NOT MATCHED THEN
      INSERT ([Value],[OpSegmentRequirement],[PropertyType])
      VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
   */

END;'
exec(@query)
GO
