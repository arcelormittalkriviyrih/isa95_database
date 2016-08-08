
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------
IF OBJECT_ID('dbo.get_CalculateBindingWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_CalculateBindingWeightByEquipment;
GO
/*
   Function: get_CalculateBindingWeightByEquipment
   
   Функция отнимает вес упаковки для бунтовых весовх.

   Parameters:

      EquipmentID    - ID весов,
	  OriginalWeight - Исходный вес
     
	Returns:

      Вес нетто.


*/

CREATE FUNCTION dbo.get_CalculateBindingWeightByEquipment
(@EquipmentID    INT,
 @OriginalWeight INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @JobOrderID INT, @BINDING_DIA [NVARCHAR](50), @BINDING_QTY [NVARCHAR](50), @BINDING_WEIGHT_COEF FLOAT, @SCALES_TYPE [NVARCHAR](50), @PACK_RULE [NVARCHAR](50), @PACK_WEIGHT [NVARCHAR](50);
         SET @SCALES_TYPE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'SCALES_TYPE');
         IF @SCALES_TYPE = N'BUNT'
             BEGIN
                 SET @PACK_RULE = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_RULE');
                 IF @PACK_RULE = N'CALC'
                     BEGIN
                         SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                         IF @JobOrderID IS NULL
                             RETURN @OriginalWeight;
                         SET @BINDING_QTY = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_QTY');
                         SET @BINDING_DIA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'BINDING_DIA');
                         SET @BINDING_WEIGHT_COEF =
                         (
                             SELECT cast(REPLACE(mdpCoef.[Value],',','.') as float)
                             FROM MaterialDefinitionProperty mdpQty
                                  INNER JOIN MaterialClassProperty mcpQty ON mcpQty.ID = mdpQty.ClassPropertyID
                                                                             AND mcpQty.[Value] = N'BINDING_QTY'
                                                                             AND mdpQty.[Value] = @BINDING_QTY
                                  INNER JOIN MaterialDefinitionProperty mdpDia ON mdpDia.MaterialDefinitionID = mdpQty.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpDia ON mcpDia.ID = mdpDia.ClassPropertyID
                                                                             AND mcpDia.[Value] = N'BINDING_DIA'
                                                                             AND mdpDia.[Value] = @BINDING_DIA
                                  INNER JOIN MaterialDefinitionProperty mdpCoef ON mdpCoef.MaterialDefinitionID = mdpDia.MaterialDefinitionID
                                  INNER JOIN MaterialClassProperty mcpCoef ON mcpCoef.ID = mdpCoef.ClassPropertyID
                                                                              AND mcpCoef.[Value] = N'BINDING_WEIGHT_COEF'
                         );
                         IF @BINDING_WEIGHT_COEF IS NOT NULL
                             RETURN @OriginalWeight * CAST(@BINDING_WEIGHT_COEF AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 IF @PACK_RULE = N'ENTERED'
                     BEGIN
                         SET @PACK_WEIGHT = dbo.get_EquipmentPropertyValue(@EquipmentID, N'PACK_WEIGHT');
                         IF @PACK_WEIGHT IS NOT NULL
                             RETURN @OriginalWeight - CAST(@PACK_WEIGHT AS FLOAT);
                         ELSE
                         RETURN @OriginalWeight;
                     END;
                 ELSE
                 RETURN @OriginalWeight;;
             END;
         ELSE
         RETURN @OriginalWeight;
         RETURN @OriginalWeight;
     END;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.get_CurrentPerson', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_CurrentPerson;
GO
/*
   Function: get_CurrentPerson

   Функция возвращает текущий Person ID
      
   Returns:
	  
	  Текущий Person ID.

*/
CREATE FUNCTION dbo.get_CurrentPerson
(
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
     BEGIN
         DECLARE @PersonID INT;
         SELECT @PersonID = p.ID
         FROM dbo.Person p,
              dbo.PersonProperty pp,
              dbo.PersonnelClassProperty pcp
         WHERE pp.PersonID = p.ID
               AND pcp.Value = 'AD_LOGIN'
               AND pcp.ID = pp.ClassPropertyID
               AND pp.Value = SYSTEM_USER;
         RETURN(@PersonID);
     END;
GO 
--------------------------------------------------------------
-- Функция возвращает текущий режим по весам
IF OBJECT_ID ('dbo.get_CurrentWorkType', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_CurrentWorkType;
GO
/*
   Function: get_CurrentWorkType

   Функция возвращает текущий режим по весам

   Parameters:

      EquipmentID - ID весов.
      
   Returns:
	  
	  Текущий режим работы АРМ.

*/
CREATE FUNCTION dbo.get_CurrentWorkType(@EquipmentID INT)
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @JobOrderID INT,
        @WorkType   [NVARCHAR](50);

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SELECT @WorkType=wr.[WorkType]
FROM [dbo].[JobOrder] jo INNER JOIN [dbo].[WorkRequest] wr ON (wr.[ID]=jo.[WorkRequest])
WHERE jo.[ID]=@JobOrderID;

RETURN @WorkType;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentClassPropertyByValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentClassPropertyByValue;
GO
/*
   Function: get_EquipmentClassPropertyByValue

   Функция вычитки поля ID из таблицы EquipmentClassProperty по значению поля Value

   Parameters:

      Value - Значение поля Value.
      
   Returns:
	  
	  EquipmentClassProperty ID.

*/
CREATE FUNCTION dbo.get_EquipmentClassPropertyByValue(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID] 
FROM [dbo].[EquipmentClassProperty]
WHERE [Value]=@Value;

RETURN @Id;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentIdByDescription', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIdByDescription;
GO
/*
   Function: get_EquipmentIdByDescription

   Функция вычитки поля ID из таблицы Equipment по значению поля Description

   Parameters:

      Description - Значение поля Description.
      
   Returns:
	  
	  ID весов.

*/
CREATE FUNCTION dbo.get_EquipmentIdByDescription(@Description [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID] 
FROM [dbo].[Equipment]
WHERE UPPER(LTRIM(RTRIM([Description])))=UPPER(LTRIM(RTRIM(@Description)));

RETURN @Id;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentIdByPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_EquipmentIdByPropertyValue];
GO
/*
   Function: get_EquipmentIdByPropertyValue

   Функция вычитки поля ID из таблицы EquipmentProperty по значению поля Value

   Parameters:

      Value                       - Значение свойства,
      EquipmentClassPropertyValue - Свойство.
   Returns:
	  
	  ID весов.

*/
CREATE FUNCTION [dbo].[get_EquipmentIdByPropertyValue](@Value [nvarchar](50),
                                                       @EquipmentClassPropertyValue [NVARCHAR](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[EquipmentID]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[Value]=@Value
  AND ep.[ClassPropertyID]=[dbo].[get_EquipmentClassPropertyByValue](@EquipmentClassPropertyValue);

RETURN @Id;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentPropertyValue;
GO
/*
   Function: get_EquipmentPropertyValue

   Функция вычитки поля Value из таблицы EquipmentProperty

   Parameters:

      EquipmentID                   - ID весов,
	  EquipmentClassPropertyValue   - Свойство.
     
   Returns:
	  
	  Значение свойства.

*/
CREATE FUNCTION dbo.get_EquipmentPropertyValue(@EquipmentID                 INT,
                                               @EquipmentClassPropertyValue [NVARCHAR](50))
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @Value [NVARCHAR](50);

SELECT @Value=ep.[Value]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[EquipmentID]=@EquipmentID
  AND ep.[ClassPropertyID]=dbo.get_EquipmentClassPropertyByValue(@EquipmentClassPropertyValue);

RETURN @Value;

END;
GO
 IF OBJECT_ID('dbo.gen_MaterialLotNumber', N'SO') IS NULL 
   CREATE SEQUENCE dbo.gen_MaterialLotNumber AS INT START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 9999 CYCLE NO CACHE;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_GenMaterialLotNumber', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_GenMaterialLotNumber;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*
   Function: get_GenMaterialLotNumber

   Функция генерирует уникальный № бирки

   Parameters:

      EquipmentID - ID весов,
	  SerialID    - Счётчик.
     
   Returns:
	  
	  № бирки.

*/
CREATE FUNCTION dbo.get_GenMaterialLotNumber(@EquipmentID  [INT],
                                             @SerialID     [INT])
RETURNS [NVARCHAR](12)
AS
BEGIN

DECLARE @MaterialLotNumber [NVARCHAR](12),
        @ScaleNO           [NVARCHAR](2);

SELECT @ScaleNO=ep.[Value]
FROM [dbo].[EquipmentProperty] ep
WHERE ep.[EquipmentID]=@EquipmentID
  AND ep.[ClassPropertyID]=dbo.get_EquipmentClassPropertyByValue(N'SCALES_NO');

SET @MaterialLotNumber=RIGHT(CAST(YEAR(CURRENT_TIMESTAMP) AS NVARCHAR),2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(MONTH(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',2) + LEFT(CAST(DAY(CURRENT_TIMESTAMP) AS NVARCHAR), 2), 2) + 
RIGHT(REPLICATE('0',2) + LEFT(@ScaleNO, 2), 2) + 
RIGHT(REPLICATE('0',4) + LEFT(CAST(@SerialID AS NVARCHAR), 4), 4)

RETURN @MaterialLotNumber;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_JobOrderPropertyValue', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_JobOrderPropertyValue;
GO
/*
   Function: get_JobOrderPropertyValue

   Функция вычитки поля Value из таблицы Parameter

   Parameters:

      JobOrderID   - Job Order ID,
	  PropertyType - Свойство.
     
   Returns:
	  
	  Значение свойства.

*/
CREATE FUNCTION dbo.get_JobOrderPropertyValue(@JobOrderID   INT,
                                              @PropertyType [NVARCHAR](50))
RETURNS [NVARCHAR](50)
AS
BEGIN

DECLARE @Value [NVARCHAR](50);

SELECT @Value=p.[Value]
FROM [dbo].[Parameter] p
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=p.[PropertyType] AND pt.[Value]=@PropertyType)
WHERE (p.JobOrder=@JobOrderID);

RETURN @Value;

END;
GO
IF OBJECT_ID ('dbo.get_LatestWorkRequests', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_LatestWorkRequests;
GO
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
             Value         NVARCHAR(50)).

*/
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
           @WorkType         NVARCHAR(50),
           @PacksLeft        NVARCHAR(50);

   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

   SELECT @WorkRequestID=jo.[WorkRequest],
          @WorkType=wr.[WorkType],
          @ProfileID=mr.[MaterialDefinitionID]
   FROM [dbo].[JobOrder] jo
        INNER JOIN [dbo].[WorkRequest] wr ON (jo.[WorkRequest]=wr.[ID])
        LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID] AND mr.[MaterialClassID]=dbo.get_MaterialClassIDByCode(N'PROFILE'))
   WHERE jo.[ID]=@JobOrderID;

   INSERT @get_LatestWorkRequests
   SELECT @WorkRequestID WorkRequestID,
          par.[JobOrder] JobOrderID,
          er.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N'Standard') WorkType,
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
          isnull(@WorkType,N'Standard') WorkType,
          pt.[Value] PropertyType,
          ps.[Value]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=ps.WorkDefinitionID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N'COMM_ORDER',N'BRIGADE_NO',N'PROD_DATE'))
   WHERE ps.[WorkDefinitionID]=@WorkDefinitionID;

RETURN;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_MaterialClassIDByCode', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_MaterialClassIDByCode;
GO
/*
   Function: get_MaterialClassIDByCode
   
   Функция вычитки поля ID из таблицы MaterialClass по значению поля Code.

   Parameters:

	  Code - Code.
     
	Returns:

      MaterialClass ID.
	
*/

CREATE FUNCTION dbo.get_MaterialClassIDByCode(@Code [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID] 
FROM [dbo].[MaterialClass]
WHERE [Code]=@Code;

RETURN @Id;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_MaterialLotStatusByWorkType', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_MaterialLotStatusByWorkType];
GO
/*
   Function: get_MaterialLotStatusByWorkType
   
   Функция возвращает MaterialLot.Status по режиму работы.

   Parameters:

	  WorkType - Режим работы.
     
	Returns:

      MaterialLot.Status.
	
*/
CREATE FUNCTION [dbo].[get_MaterialLotStatusByWorkType](@WorkType NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
   IF @WorkType = N'Sort'
      RETURN N'2';
   ELSE IF @WorkType = N'Reject'
      RETURN N'3';
   ELSE IF @WorkType = N'Separate'
      RETURN N'4';

   RETURN N'0';
END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_ParentEquipmentIDByClass', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_ParentEquipmentIDByClass];
GO
/*
   Function: get_ParentEquipmentIDByClass

   Функция возвращает ID родителя из таблицы Equipment соответствующего EquipmentClass.Code

   Parameters:

      @EquipmentID  - ID оборудования,
      @Code         - EquipmentClass.Code
      
   Returns:
	  
	  Parent Equipment ID.

*/
CREATE FUNCTION [dbo].[get_ParentEquipmentIDByClass](@EquipmentID   INT,
                                                     @Code          NVARCHAR(50))
RETURNS INT
AS
BEGIN

DECLARE @ParentEquipmentID INT,
        @ReturnEquipmentID INT,
        @EquipmentClassID  INT;

SELECT @EquipmentClassID=EquipmentClassID,
       @ParentEquipmentID=[Equipment]
FROM [dbo].[Equipment]
WHERE [ID]=@EquipmentID;

WHILE (@EquipmentClassID IS NOT NULL) AND (SELECT [ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=@Code) <> @EquipmentClassID
BEGIN
   SELECT @EquipmentClassID=EquipmentClassID,
          @ReturnEquipmentID=[ID],
          @ParentEquipmentID=[Equipment]
   FROM [dbo].[Equipment]
   WHERE [ID]=@ParentEquipmentID;
END;

RETURN @ReturnEquipmentID;

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID('dbo.get_RoundedWeight', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeight;
GO
/*
   Function: dbo.get_RoundedWeight
   
   Функция округляет вес.

   Parameters:

	  WeightValue	 - Исходный вес,
	  RoundRule		 - Правило округления,
	  RoundPrecision - Точность.
     
	Returns:

      Округлённый вес.
	
*/
CREATE FUNCTION dbo.get_RoundedWeight
(@WeightValue INT,
 @RoundRule   NVARCHAR(50),
 @RoundPrecision  INT
)
RETURNS INT
AS
     BEGIN
         IF @RoundRule IS NULL
             RETURN @WeightValue;
         IF @RoundPrecision IS NULL
             RETURN @WeightValue;
         IF @RoundRule = 'UP'
             BEGIN
                 IF @WeightValue % @RoundPrecision = 0
                     RETURN @WeightValue;
                 ELSE
                 RETURN @WeightValue + @RoundPrecision - @WeightValue % @RoundPrecision;
             END;
         IF @RoundRule = 'DOWN'
             RETURN @WeightValue - @WeightValue % @RoundPrecision;
         RETURN @WeightValue;
     END;
GO 
--------------------------------------------------------------

--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_EquipmentIDByScalesNo', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_EquipmentIDByScalesNo;
GO
/*
   Function: get_EquipmentIDByScalesNo

   Функция вычитки поля ID из таблицы Equipment по EquipmentClassProperty N'SCALES_NO'

   Parameters:

      Value - Идентификатор весов.
     
   Returns:
	  
	  ID весов.

*/
CREATE FUNCTION dbo.get_EquipmentIDByScalesNo(@Value [nvarchar](50))
RETURNS INT
AS
BEGIN

DECLARE @EquipmentID INT;

SELECT @EquipmentID=eqp.EquipmentID
FROM dbo.EquipmentProperty eqp
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'SCALES_NO')
WHERE eqp.value=@Value;

RETURN @EquipmentID;

END;
GO


IF OBJECT_ID('dbo.get_RoundedWeightByEquipment', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_RoundedWeightByEquipment;
GO
/*
   Function: get_RoundedWeightByEquipment
   
   Функция округляет вес для конкретных весов.

   Parameters:

      EquipmentID - ID весов,
	  WeightValue - Исходный вес
     
	Returns:

      Округлённый вес.
	
	See Also:

      <get_RoundedWeight>

*/

CREATE FUNCTION dbo.get_RoundedWeightByEquipment
(@WeightValue INT,
 @EquipmentID INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @RoundPrecision INT, @RoundRule [NVARCHAR](50);
         SET @RoundRule = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_RULE');
         SET @RoundPrecision = dbo.get_EquipmentPropertyValue(@EquipmentID, N'ROUND_PRECISION');
	    SET @WeightValue = dbo.get_CalculateBindingWeightByEquipment(@EquipmentID,@WeightValue);
         RETURN dbo.[get_RoundedWeight](@WeightValue, @RoundRule, @RoundPrecision);
     END;
GO 


IF OBJECT_ID ('dbo.get_TableInteger', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_TableInteger;
GO
/*
   Function: get_TableInteger
   
   Превращает строку в таблицу Integer.

   Parameters:

      input_str - входная строка,
	  delimeter - разделитель.
     
   Returns:

      Таблицу Integer.

*/
CREATE FUNCTION dbo.get_TableInteger(@input_str NVARCHAR(MAX),
                                     @delimeter NVARCHAR(5) = ','
                                     )
RETURNS @table TABLE (ID INT)
AS
BEGIN

   -- определяем позицию первого разделителя
   DECLARE @str NVARCHAR(MAX) = @input_str + @delimeter;
   DECLARE @pos INT = charindex(@delimeter,@str);

   -- создаем переменную для хранения одного айдишника
   DECLARE @id NVARCHAR(10);

   WHILE (1=1)
      BEGIN
         -- получаем айдишник
         SET @id = SUBSTRING(@str, 1, @pos-1);
         -- записываем в таблицу
         INSERT INTO @table (id) VALUES(CAST(@id AS INT));
         -- сокращаем исходную строку на
         -- размер полученного айдишника
         -- и разделителя
         SET @str = SUBSTRING(@str, @pos+1, LEN(@str));
         -- определяем позицию след. разделителя
         SET @pos = CHARINDEX(@delimeter,@str);

         IF @pos=0
            BREAK;
         ELSE
            CONTINUE;
      END;

RETURN;

END;
GO 

IF OBJECT_ID ('dbo.get_TableVarchar', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_TableVarchar;
GO
/*
   Function: get_TableVarchar
   
   Превращает строку в таблицу NVARCHAR.

   Parameters:

      input_str - входная строка,
	  delimeter - разделитель.
     
   Returns:

      Таблицу NVARCHAR.

*/
CREATE FUNCTION dbo.get_TableVarchar(@input_str NVARCHAR(MAX),
                                     @delimeter NVARCHAR(5) = ','
                                     )
RETURNS @table TABLE (Value NVARCHAR(MAX))
AS
BEGIN

   -- определяем позицию первого разделителя
   DECLARE @str NVARCHAR(MAX) = @input_str + @delimeter;
   DECLARE @pos INT = charindex(@delimeter,@str);

   -- создаем переменную для хранения одного айдишника
   DECLARE @Value NVARCHAR(MAX);

   WHILE (1=1)
      BEGIN
         -- получаем айдишник
         SET @Value = SUBSTRING(@str, 1, @pos-1);
         -- записываем в таблицу
         INSERT INTO @table(Value) VALUES(@Value);
         -- сокращаем исходную строку на
         -- размер полученного айдишника
         -- и разделителя
         SET @str = SUBSTRING(@str, @pos+1, LEN(@str));
         -- определяем позицию след. разделителя
         SET @pos = CHARINDEX(@delimeter,@str);

         IF @pos=0
            BREAK;
         ELSE
            CONTINUE;
      END;

RETURN;

END;
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
             Value            NVARCHAR(50),
             WorkDefinitionID INT,
             Property         NVARCHAR(50)).

*/
CREATE FUNCTION dbo.get_WorkDefinitionPropertiesAll(@COMM_ORDER NVARCHAR(50))
RETURNS @retWorkDefinitionPropertiesAll TABLE (ID               INT,
                                               Description      NVARCHAR(50),
                                               Value            NVARCHAR(50),
                                               WorkDefinitionID INT,
                                               Property         NVARCHAR(50))
AS
BEGIN

   DECLARE @WorkDefinitionID     INT,
           @OpSegmentRequirement INT;

   SELECT @WorkDefinitionID=ps.[WorkDefinitionID]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=ps.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
   WHERE ps.[Value]=@COMM_ORDER;

  IF NOT @WorkDefinitionID IS NULL
     BEGIN 
        INSERT @retWorkDefinitionPropertiesAll
           SELECT ps.[ID],
                  pt.[Description],
                  ps.[Value],
                  ps.[WorkDefinitionID],
                  pt.[Value]
           FROM [dbo].[ParameterSpecification] ps
                INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
           WHERE ps.[WorkDefinitionID]=@WorkDefinitionID
     END
  ELSE
     BEGIN
        SELECT @OpSegmentRequirement=sp.[OpSegmentRequirement]
        FROM [dbo].[SegmentParameter] sp
             INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=sp.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
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

END;
GO
 --------------------------------------------------------------
IF OBJECT_ID ('dbo.get_WorkRequestByJobOrder', N'FN') IS NOT NULL
   DROP FUNCTION dbo.get_WorkRequestByJobOrder;
GO

/*
   Function: get_WorkRequestByJobOrder
   
   Получает Work Request по Job Order.

   Parameters:

      JobOrderID - Job Order ID
     
   Returns:

      Work Request ID.

*/
CREATE FUNCTION dbo.get_WorkRequestByJobOrder(@JobOrderID INT)
RETURNS INT
AS
BEGIN
   DECLARE @WorkRequestID INT;

   SELECT @WorkRequestID=jo.[WorkRequest]
   FROM [dbo].[JobOrder] jo
   WHERE jo.[ID]=@JobOrderID;

   RETURN @WorkRequestID;
END
GO

--------------------------------------------------------------
-- Процедура del_KEPLoggerJob
IF OBJECT_ID ('dbo.del_KEPLoggerJob',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_KEPLoggerJob;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: del_KEPLoggerJob
	Удаляет записи созданные позднее 30минут назад из таблиц KEP_logger и KEP_weigth_fix.
*/
CREATE PROCEDURE [dbo].[del_KEPLoggerJob]
AS
BEGIN

   DELETE FROM [dbo].[KEP_logger]
   WHERE [TIMESTAMP]<=DATEADD(minute,-30,GETDATE());

   DELETE FROM [dbo].[KEP_weigth_fix]
   WHERE [TIMESTAMP]<=DATEADD(minute,-30,GETDATE());

END;
GO
 --------------------------------------------------------------
-- Процедура del_Order
IF OBJECT_ID ('dbo.del_Order',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_Order;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: del_Order
	Процедура удаления заказа.

	Parameters:

      COMM_ORDER - Номер коммерческого заказа
*/
CREATE PROCEDURE [dbo].[del_Order]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID    INT,
           @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @COMM_ORDER IS NULL
      THROW 60001, N'COMM_ORDER param required', 1;

   SELECT @OpSegmentRequirementID=spo.OpSegmentRequirement
   FROM [dbo].[v_SegmentParameter_Order] spo
   WHERE spo.Value=@COMM_ORDER;

   IF @OpSegmentRequirementID IS NULL
      BEGIN
         SET @err_message = N'Order [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DELETE FROM [dbo].[SegmentParameter]
   WHERE OpSegmentRequirement=@OpSegmentRequirementID;

   DELETE [dbo].[OpSegmentRequirement]
   WHERE ID=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OperationsRequest]
   WHERE ID=@OperationsRequestID;

END;
GO
 --------------------------------------------------------------
-- Процедура del_WorkDefinition
IF OBJECT_ID ('dbo.del_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: del_WorkDefinition
	Процедура удаления WorkDefinition.
	
	Parameters:

      COMM_ORDER - Номер коммерческого заказа
*/
CREATE PROCEDURE [dbo].[del_WorkDefinition]
@COMM_ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @WorkDefinitionID   INT,
           @err_message        NVARCHAR(255);

   IF @COMM_ORDER IS NULL
      THROW 60001, N'COMM_ORDER param required', 1;

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.Value=@COMM_ORDER;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DELETE FROM [dbo].[ParameterSpecification]
   WHERE WorkDefinitionID=@WorkDefinitionID;

   DELETE FROM [dbo].[WorkDefinition]
   WHERE ID=@WorkDefinitionID;

END;
GO
 SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.exec_SAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.exec_SAPExport;
GO
--------------------------------------------------------------
/*
	Procedure: exec_SAPExport
	Используется для выполнения экспорта бирок в САП.
*/

CREATE PROCEDURE [dbo].[exec_SAPExport]
AS
BEGIN

	DECLARE @MaterialLotID int, @JobOrderID int, @LinkedServer NVARCHAR(50);


	DECLARE selMaterialLots CURSOR
	FOR SELECT p.[Value], o.ID, o.CommandRule
		FROM [dbo].JobOrder AS o, [dbo].[Parameter] AS p, [dbo].[PropertyTypes] AS pt
		WHERE o.ID = p.JobOrder AND 
			  p.PropertyType = pt.ID AND 
			  pt.[Value] = N'MaterialLotID' AND 
			  o.WorkType = N'SAPExport' AND
			  o.DispatchStatus = N'TODO';
	OPEN selMaterialLots;
	FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID, @LinkedServer;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			EXEC DBO.[ins_ExportMaterialLotToSAP] @MaterialLotID = @MaterialLotID, @LinkedServer = @LinkedServer;
			update [dbo].JobOrder set DispatchStatus=N'Done',EndTime=CURRENT_TIMESTAMP where id=@JobOrderID;
		END TRY
		BEGIN CATCH

			EXEC [dbo].[ins_ErrorLog];
		END CATCH;

		FETCH NEXT FROM selMaterialLots INTO @MaterialLotID, @JobOrderID;
	END;
	CLOSE selMaterialLots;
	DEALLOCATE selMaterialLots;
END;

GO


 SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.get_SAPOrderRequestURL',N'P') IS NOT NULL
   DROP PROCEDURE dbo.get_SAPOrderRequestURL;
GO
--------------------------------------------------------------

/*
	Procedure: get_SAPOrderRequestURL
	Используется для генерации URL для обращения к SAP сервису для получения информации о заказе.
	Parameters:

		COMM_ORDER - Номер коммерческого заказа
		URL        - URL OUTPUT
	
	 
	  
*/

CREATE PROCEDURE [dbo].[get_SAPOrderRequestURL](
	   @COMM_ORDER [nvarchar](50), @URL nvarchar(1000) OUTPUT)
WITH ENCRYPTION
AS
BEGIN
	DECLARE @SAP_SERVICE_URL nvarchar(500), @SAP_SERVICE_LOGIN nvarchar(50), @SAP_SERVICE_PASS nvarchar(50);
	SET @SAP_SERVICE_URL =
	(
		SELECT p.[Value]
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_URL'
	);
	SET @SAP_SERVICE_LOGIN =
	(
		SELECT DECRYPTBYPASSPHRASE(N'arcelor', p.[Value])
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_LOGIN'
	);
	SET @SAP_SERVICE_PASS =
	(
		SELECT DECRYPTBYPASSPHRASE(N'arcelor', p.[Value])
		FROM JobOrder AS o, [Parameter] AS p, dbo.PropertyTypes AS pt
		WHERE WorkType = 'SAPOrderRequest' AND 
			  p.JobOrder = o.ID AND 
			  pt.ID = p.PropertyType AND 
			  pt.[Value] = N'SAP_SERVICE_PASS'
	);

	--https://krrzdmm1.europe.mittalco.com:50001/XMII/Runner?Transaction=DataTransferToPrintLabelSystem/SAP/GetSelesOrderInformation.trx
	--&SLS_ORDR=&OutputParameter=RSLT&XacuteLoginName=&XacuteLoginPassword=&Content-Type=text/xml

	SET @URL = @SAP_SERVICE_URL+N'&SLS_ORDR='+@COMM_ORDER+N'&OutputParameter=RSLT&XacuteLoginName='+@SAP_SERVICE_LOGIN+N'&XacuteLoginPassword='+@SAP_SERVICE_PASS+N'&Content-Type=text/xml';

END;
GO 

--------------------------------------------------------------
-- Процедура ins_ErrorLog
IF OBJECT_ID ('dbo.ins_ErrorLog',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ErrorLog;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_ErrorLog
	Добаляет информацию об ошибке в таблицу ErrorLog.
*/

CREATE PROCEDURE [dbo].[ins_ErrorLog]
AS
BEGIN
   INSERT INTO [dbo].[ErrorLog](error_details,error_message)
   SELECT N'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR) + N', ERROR_SEVERITY: '+ IsNull(CAST(ERROR_SEVERITY() AS NVARCHAR),N'') + N', ERROR_STATE: '+ IsNull(CAST(ERROR_STATE() AS NVARCHAR),N'') + N', ERROR_PROCEDURE: '+ IsNull(ERROR_PROCEDURE(),N'') + N', ERROR_LINE '+ CAST(ERROR_LINE() AS NVARCHAR),
          ERROR_MESSAGE();
END;
GO
 --------------------------------------------------------------
-- Процедура ins_ExportMaterialLotToSAP
IF OBJECT_ID ('dbo.ins_ExportMaterialLotToSAP',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ExportMaterialLotToSAP;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_ExportMaterialLotToSAP
	Отправляет информацию о напечатанной бирке в SAP.

	Parameters:

      MaterialLotID - MaterialLot ID.
*/
CREATE PROCEDURE [dbo].[ins_ExportMaterialLotToSAP]
@MaterialLotID INT,
@LinkedServer NVARCHAR(50)
AS
BEGIN

   SET NOCOUNT ON;

   --BEGIN TRY

      IF @MaterialLotID IS NULL
         RETURN;

      DECLARE @FactoryNumber NVARCHAR(250),
              @Quantity      INT,
              @Status        NVARCHAR(250);

      DECLARE @tblProperty   TABLE(ID          INT,
                                   Description NVARCHAR(50),
                                   Value       NVARCHAR(50));

      SELECT @FactoryNumber=[FactoryNumber],
             @Quantity=[Quantity],
             @Status=[Status]
      FROM [dbo].[MaterialLot]
      WHERE [ID]=@MaterialLotID;

      IF ISNULL(@Quantity,0)=0
         RETURN;

      INSERT @tblProperty
      SELECT mlp.PropertyType,pt.[Value],mlp.[Value]
      FROM [dbo].[MaterialLotProperty] mlp INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID = mlp.PropertyType)
      WHERE MaterialLotID=@MaterialLotID;

      SET XACT_ABORT ON;

      CREATE TABLE #ZPP_WEIGHT_PROKAT (AUFNR    NVARCHAR(50),
                                       MATNR    NVARCHAR(50),
                                       DATE_P   DATE,
                                       N_BIR    NUMERIC(10,0),
                                       NSMEN    NUMERIC(10,0),
                                       NBRIG    NUMERIC(10,0),
                                       PARTY    NVARCHAR(50),
                                       BUNT     NUMERIC(10,0),
                                       MAS      INT,
                                       PLAVK    NVARCHAR(50),
                                       OLD_BIR  NVARCHAR(250),
                                       AUART    NVARCHAR(50),
                                       EO       NVARCHAR(250),
                                       N_ORDER  NVARCHAR(50),
                                       DT       DATETIME,
                                       EO_OLD   NVARCHAR(250),
                                       REZIM    NUMERIC);

      INSERT INTO #ZPP_WEIGHT_PROKAT
      SELECT (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'PROD_ORDER'), --AUFNR
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MATERIAL_NO' AND EXISTS (SELECT NULL FROM @tblProperty tt WHERE tt.[Description]=N'NEMERA' AND UPPER(tt.[Value])=N'TRUE')), --MATNR
             (SELECT CONVERT(DATE,t.[Value],104) FROM @tblProperty t WHERE t.[Description]=N'PROD_DATE' AND ISDATE(t.[Value])=1), --DATE_P
              CAST(SUBSTRING(@FactoryNumber,9,12) AS NUMERIC(10,0)), --N_BIR
             (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'CHANGE_NO' AND ISNUMERIC(t.[Value])=1), --NSMEN
             (SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BRIGADE_NO' AND ISNUMERIC(t.[Value])=1), --NBRIG
             (SELECT t.[Value] FROM @tblProperty t WHERE [Description]=N'PART_NO'), --PARTY
             isnull((SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'BUNT_NO' AND ISNUMERIC(t.[Value])=1),0), --BUNT
              @Quantity, --MAS
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MELT_NO'), --PLAVK
              @Status, --OLD_BIR
             (SELECT t.[Value] FROM @tblProperty t WHERE t.[Description]=N'MILL_ID'), --AUART
              @FactoryNumber, --EO
              ISNULL((SELECT CAST(t.[Value] AS NUMERIC(10,0)) FROM @tblProperty t WHERE t.[Description]=N'LEAVE_NO' AND ISNUMERIC(t.[Value])=1),0), --N_ORDER,
             (SELECT CONVERT(DATETIME,t.[Value],121) FROM @tblProperty t WHERE t.[Description]=N'MEASURE_TIME' AND ISDATE(t.[Value])=1), --DT,
              ISNULL((CASE @Status
                      WHEN '1' THEN 0 
                      ELSE (SELECT TOP 1 mm.[FactoryNumber]
                            FROM [dbo].[MaterialLotLinks] ml INNER JOIN [dbo].[MaterialLot] mm ON (mm.[ID]=ml.[MaterialLot1])
                            WHERE (ml.[MaterialLot2]=@MaterialLotID))
                      END),0), --EO_OLD,
             (SELECT ABS(CAST(t.[Value] AS NUMERIC)-1) FROM @tblProperty t WHERE t.[Description]=N'AUTO_MANU_VALUE' AND ISNUMERIC(t.[Value])=1); --REZIM

      DECLARE @OPENQUERY    NVARCHAR(4000);


      SET @OPENQUERY = 'INSERT OPENQUERY ('+ @LinkedServer + ',''SELECT AUFNR,MATNR,DATE_P,N_BIR,NSMEN,NBRIG,PARTY,BUNT,MAS,PLAVK,OLD_BIR,AUART,EO,N_ORDER,DT,EO_OLD,REZIM FROM ZPP.ZPP_WEIGHT_PROKAT'') '+
                       '(AUFNR,MATNR,DATE_P,N_BIR,NSMEN,NBRIG,PARTY,BUNT,MAS,PLAVK,OLD_BIR,AUART,EO,N_ORDER,DT,EO_OLD,REZIM) (SELECT * FROM #ZPP_WEIGHT_PROKAT)';
      EXEC (@OPENQUERY);

      DROP TABLE #ZPP_WEIGHT_PROKAT;
   --END TRY

   --BEGIN CATCH

   --  EXEC [dbo].[ins_ErrorLog];

   --END CATCH

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrder
IF OBJECT_ID ('dbo.ins_JobOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrder;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: dbo.ins_JobOrder
	Процедура вставки JobOrder.

	Parameters:

		WorkType		- Режим,
		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок.
		JobOrderID      - Job Order ID OUTPUT.

*/

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
@PACKS_LEFT       NVARCHAR(50) = NULL,
@BINDING_DIA      NVARCHAR(50) = NULL,
@BINDING_QTY      NVARCHAR(50) = NULL,
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

   IF @WorkType IN (N'Standard')
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'STANDARD_JOB_ORDER_ID',
                                         @EquipmentPropertyValue = @EquipmentPropertyValue;

   if @ProfileID is not null	
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
   SELECT N'FACTORY_NUMBER',@FACTORY_NUMBER WHERE @FACTORY_NUMBER IS NOT NULL
   UNION ALL
   SELECT N'PACKS_LEFT',@PACKS_LEFT WHERE @PACKS_LEFT IS NOT NULL
   UNION ALL
   SELECT N'BINDING_DIA',@BINDING_DIA WHERE @BINDING_DIA IS NOT NULL
   UNION ALL
   SELECT N'BINDING_QTY',@BINDING_QTY WHERE @BINDING_QTY IS NOT NULL;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT t.value,@JobOrderID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO

 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommand
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommand',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommand;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommand
	Процедура отправки комманд на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		Tag             - Имя комманды,
		TagType         - Тип,
		TagValue        - Значение.

*/

CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommand]
@WorkRequestID   INT,
@EquipmentID     INT,
@Tag             NVARCHAR(255),
@TagType         NVARCHAR(50),
@TagValue        NVARCHAR(255)
AS
BEGIN

   DECLARE @err_message   NVARCHAR(255);

   IF @WorkRequestID IS NULL
    THROW 60001, N'WorkRequestID param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[WorkRequest] WHERE [ID]=@WorkRequestID)
      BEGIN
         SET @err_message = N'WorkRequest [' + CAST(@WorkRequestID AS NVARCHAR) + N'] not exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @EquipmentID IS NULL
    THROW 60001, N'EquipmentID param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Equipment] WHERE [ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment [' + CAST(@EquipmentID AS NVARCHAR) + N'] not exists';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @Tag IS NULL
    THROW 60001, N'Tag param required', 1;
   ELSE IF @TagType IS NULL
    THROW 60001, N'TagType param required', 1;
   ELSE IF @TagType NOT IN (N'Boolean',N'Byte',N'Short',N'Word',N'Long',N'Dword',N'Float',N'Double',N'Char',N'String')
      BEGIN
         SET @err_message = N'[' + @TagType + N'] is not valid value for TagType param';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @TagValue IS NULL
    THROW 60001, N'TagValue param required', 1;

   DECLARE @JobOrderID  INT,
           @Command     NVARCHAR(50),
           @CommandRule NVARCHAR(50);

   SET @JobOrderID = NEXT VALUE FOR [dbo].[gen_JobOrder];
   SET @Command = dbo.get_EquipmentPropertyValue(@EquipmentID,N'OPC_DEVICE_NAME')+ N'.' +  @Tag;
   SET @CommandRule = N'(' + @TagType + N')' + @TagValue;
   INSERT INTO [dbo].[JobOrder] ([ID], [WorkType], [StartTime], [WorkRequest], [DispatchStatus], [Command], [CommandRule])
   VALUES (@JobOrderID,N'KEPCommands',CURRENT_TIMESTAMP,@WorkRequestID,N'ToSend',@Command,@CommandRule);

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandAutoManu
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandAutoManu',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandAutoManu;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandAutoManu
	Процедура отправки AutoManu на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandAutoManu]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF @TagValue NOT IN (N'true',N'false')
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'AUTO_MANU',
                                    @TagType       = N'Boolean',
                                    @TagValue      = @TagValue;

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMaxWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMaxWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMaxWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandMaxWeight
	Процедура отправки максимального веса на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandMaxWeight]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF ISNUMERIC(@TagValue)=0
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;


EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'WEIGHT_SP_MAX',
                                    @TagType       = N'Float',
                                    @TagValue      = @TagValue;

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandMinWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandMinWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandMinWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandMinWeight
	Процедура отправки минимального веса на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandMinWeight]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF ISNUMERIC(@TagValue)=0
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'WEIGHT_SP_MIN',
                                    @TagType       = N'Float',
                                    @TagValue      = @TagValue;

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandSandwich
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandSandwich',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandSandwich;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandSandwich
	Процедура отправки Sandwich на контроллер.

	Parameters:

		WorkRequestID   - WorkRequest ID,
		EquipmentID     - ID весов,
		TagValue        - Значение.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandSandwich]
@WorkRequestID   INT,
@EquipmentID     INT,
@TagValue        NVARCHAR(255)
AS
BEGIN

DECLARE @err_message   NVARCHAR(255);

IF @TagValue NOT IN (N'true',N'false')
   BEGIN
      SET @err_message = N'[' + @TagValue + N'] is not valid value';
      THROW 60010, @err_message, 1;
   END;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_SANDWICH',
                                    @TagType       = N'Boolean',
                                    @TagValue      = @TagValue;

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeTara
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeTara',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeTara;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandTakeTara
	Процедура отправки Взять тару на контроллер.

	Parameters:

		EquipmentID     - ID весов.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeTara]
@EquipmentID     INT
AS
BEGIN

DECLARE @JobOrderID    INT,
        @WorkRequestID INT;

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

SELECT @WorkRequestID=jo.[WorkRequest]
FROM [dbo].[JobOrder] jo
WHERE jo.[ID]=@JobOrderID;

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_TARA',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderOPCCommandTakeWeight
IF OBJECT_ID ('dbo.ins_JobOrderOPCCommandTakeWeight',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderOPCCommandTakeWeight;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderOPCCommandTakeWeight
	Процедура отправки Взять вес на контроллер.

	Parameters:

		EquipmentID     - ID весов.

	See Also:

		<ins_JobOrderOPCCommand>

*/
CREATE PROCEDURE [dbo].[ins_JobOrderOPCCommandTakeWeight]
@EquipmentID     INT
AS
BEGIN

DECLARE @JobOrderID    INT,
        @WorkRequestID INT,
	   @TakeWeightLocked [NVARCHAR](50);

SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');

SELECT @WorkRequestID=jo.[WorkRequest]
FROM [dbo].[JobOrder] jo
WHERE jo.[ID]=@JobOrderID;

SET @TakeWeightLocked=dbo.get_EquipmentPropertyValue(@EquipmentID,N'TAKE_WEIGHT_LOCKED');

IF @TakeWeightLocked NOT IN (N'1')
    EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
								@EquipmentClassPropertyValue = N'TAKE_WEIGHT_LOCKED',
								@EquipmentPropertyValue = N'1';

EXEC [dbo].[ins_JobOrderOPCCommand] @WorkRequestID = @WorkRequestID,
                                    @EquipmentID   = @EquipmentID,
                                    @Tag           = N'CMD_TAKE_WEIGHT',
                                    @TagType       = N'Boolean',
                                    @TagValue      = N'true';

END;
GO
 --------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabel
IF OBJECT_ID ('dbo.ins_JobOrderPrintLabel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderPrintLabel;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderPrintLabel
	Процедура создания Job на печать или отправку бирки.

	Parameters:

		PrinterID     - Printer ID,
		MaterialLotID - MaterialLot ID,
		Command       - Email или Print,
		CommandRule   - Список адресов,
		WorkRequestID - WorkRequestID

	See Also:

		<ins_JobOrderToPrint>
*/
CREATE PROCEDURE [dbo].[ins_JobOrderPrintLabel]
@PrinterID      NVARCHAR(255) = NULL,
@MaterialLotID  INT,
@Command        NVARCHAR(50),
@CommandRule    NVARCHAR(50) = NULL,
@WorkRequestID  INT = NULL

AS
BEGIN

   DECLARE @err_message NVARCHAR(255),
           @EquipmentID INT;

   IF @Command IS NULL
      THROW 60001, N'Command param required', 1;
   ELSE IF @PrinterID IS NULL AND @Command=N'Print' 
      THROW 60001, N'PrinterID param required for Print Command', 1;
   ELSE IF @MaterialLotID IS NULL
      THROW 60001, N'MaterialLotID param required', 1;
   ELSE IF @CommandRule IS NULL AND @Command=N'Email' 
      THROW 60001, N'CommandRule param required for Email Command', 1;
   ELSE IF @PrinterID IS NOT NULL 
      SET @EquipmentID = [dbo].[get_EquipmentIdByPropertyValue](@PrinterID,N'PRINTER_NO');
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialLot] WHERE [ID]=@MaterialLotID)
      BEGIN
         SET @err_message = N'MaterialLot ID [' + CAST(@MaterialLotID AS NVARCHAR) + N'] does not exists';
         THROW 60010, @err_message, 1;
      END;

   IF @EquipmentID IS NULL
      BEGIN
         SET @err_message = N'Принтер с идентификатором "' + @PrinterID + N'" не существует';
          THROW 60010, @err_message, 1;
      END;

   EXEC [dbo].[ins_JobOrderToPrint] @EquipmentID = @EquipmentID,
                                    @MaterialLotID = @MaterialLotID,
                                    @Command = @Command,
                                    @CommandRule = @CommandRule,
                                    @WorkRequestID = @WorkRequestID;

END;
GO

 --------------------------------------------------------------
-- Процедура ins_JobOrderPrintLabelByScalesNo


IF OBJECT_ID('dbo.ins_JobOrderPrintLabelByScalesNo', N'P') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo;
    END;
GO

SET QUOTED_IDENTIFIER ON;
GO
/*
	Procedure: ins_JobOrderToPrint
	Процедура создания бирки и Job на печать бирки.

	Parameters:

		SCALES_NO  - Идентификатор весов,
		TIMESTAMP  - Дата и время,
        WEIGHT_FIX - Вес,
        AUTO_MANU  - Признак AUTO_MANU,
        IDENT      - Идентификатор взвешивания

	
*/
CREATE PROCEDURE dbo.ins_JobOrderPrintLabelByScalesNo @SCALES_NO  NVARCHAR(50),
                                                      @TIMESTAMP  DATETIME,
                                                      @WEIGHT_FIX INT,
                                                      @AUTO_MANU  BIT,
                                                      @IDENT      NVARCHAR(50)
AS
     BEGIN
         BEGIN TRY
             DECLARE @EquipmentID INT, @FactoryNumber NVARCHAR(12), @PrinterID NVARCHAR(50), @JobOrderID INT, @WorkType NVARCHAR(50), @WorkDefinitionID INT, @MaterialLotID INT, @Status NVARCHAR(250), @err_message NVARCHAR(255), @Weight_Rounded INT;
             IF NOT EXISTS
             (
                 SELECT NULL
                 FROM MaterialLotProperty AS mlp,
                      PropertyTypes AS pt
                 WHERE pt.ID = mlp.PropertyType
                       AND pt.[Value] = N'MATERIAL_LOT_IDENT'
                       AND mlp.[Value] = @IDENT
             )
                 BEGIN
                     SET @EquipmentID = dbo.get_EquipmentIDByScalesNo(@SCALES_NO);
                     IF @EquipmentID IS NULL
                         BEGIN
                             SET @err_message = N'By SCALES_NO=['+@SCALES_NO+N'] EquipmentID not found';
                             THROW 60010, @err_message, 1;
                         END;

/*
      SELECT TOP 1 @JobOrderID=jo.[ID]
      FROM [dbo].[JobOrder] jo
           INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID] AND er.EquipmentID=@EquipmentID)
      WHERE jo.[WorkType]=N'INIT'
      ORDER BY jo.[StartTime] DESC;
*/

                     SET @Weight_Rounded = dbo.get_RoundedWeightByEquipment(@WEIGHT_FIX, @EquipmentID);
                     SET @JobOrderID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'JOB_ORDER_ID');
                     IF @JobOrderID IS NULL
                         BEGIN
                             SET @err_message = N'JobOrder is missing for EquipmentID=['+CAST(@EquipmentID AS NVARCHAR)+N']';
                             THROW 60010, @err_message, 1;
                         END;
                     SELECT @WorkType = wr.WorkType
                     FROM dbo.JobOrder AS jo
                          INNER JOIN dbo.WorkRequest AS wr ON wr.ID = jo.WorkRequest
                     WHERE jo.ID = @JobOrderID;
                     SET @Status = dbo.get_MaterialLotStatusByWorkType(@WorkType);
                     IF @WorkType IN(N'Standard')
                         BEGIN
                             SET @FactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                             EXEC dbo.ins_MaterialLot
                                  @FactoryNumber = @FactoryNumber,
                                  @Status = @Status,
                                  @Quantity = @Weight_Rounded,
                                  @MaterialLotID = @MaterialLotID OUTPUT;
                         END;
                     ELSE
                         BEGIN
                             IF @WorkType IN(N'Sort', N'Reject')
                                 BEGIN
                                     SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                     EXEC dbo.ins_MaterialLotWithLinks
                                          @FactoryNumber = @FactoryNumber,
                                          @Status = @Status,
                                          @Quantity = @Weight_Rounded,
                                          @MaterialLotID = @MaterialLotID OUTPUT;
                                     EXEC dbo.set_StandardMode
                                          @EquipmentID = @EquipmentID;
                                 END;
                             ELSE
                                 BEGIN
                                     IF @WorkType IN(N'Separate')
                                         BEGIN
                                             DECLARE @LinkFactoryNumber NVARCHAR(12);
                                             SET @LinkFactoryNumber = dbo.get_GenMaterialLotNumber(@EquipmentID, NEXT VALUE FOR dbo.gen_MaterialLotNumber);
                                             SET @FactoryNumber = dbo.get_JobOrderPropertyValue(@JobOrderID, N'FACTORY_NUMBER');
                                             EXEC dbo.ins_MaterialLotWithLinks
                                                  @FactoryNumber = @FactoryNumber,
                                                  @Status = @Status,
                                                  @Quantity = @Weight_Rounded,
                                                  @LinkFactoryNumber = @LinkFactoryNumber,
                                                  @MaterialLotID = @MaterialLotID OUTPUT;
                                             EXEC dbo.set_DecreasePacksLeft
                                                  @EquipmentID = @EquipmentID;
                                         END;
                                 END;
                         END;
                     DECLARE @MEASURE_TIME NVARCHAR(50), @MILL_ID NVARCHAR(50), @NEMERA NVARCHAR(50);
                     SET @MEASURE_TIME = CONVERT(NVARCHAR, @TIMESTAMP, 121);
                     SET @MILL_ID = dbo.get_EquipmentPropertyValue(dbo.get_ParentEquipmentIDByClass(@EquipmentID, N'MILL'), N'MILL_ID');
                     SET @WorkDefinitionID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'WORK_DEFINITION_ID');
                     SET @NEMERA = dbo.get_JobOrderPropertyValue(@JobOrderID, N'NEMERA');
                     EXEC dbo.ins_MaterialLotPropertyByWorkDefinition
                          @WorkDefinitionID = @WorkDefinitionID,
                          @MaterialLotID = @MaterialLotID,
                          @MEASURE_TIME = @MEASURE_TIME,
                          @AUTO_MANU_VALUE = @AUTO_MANU,
                          @MILL_ID = @MILL_ID,
                          @NEMERA = @NEMERA,
						  @IDENT = @IDENT,
						  @CREATE_MODE = N'Авто печать';

/*
      EXEC [dbo].[ins_MaterialLotPropertyByJobOrder] @MaterialLotID   = @MaterialLotID,
                                                     @JobOrderID      = @JobOrderID,
                                                     @MEASURE_TIME    = @MEASURE_TIME,
                                                     @AUTO_MANU_VALUE = @AUTO_MANU;
*/

                     SET @PrinterID = dbo.get_EquipmentPropertyValue(@EquipmentID, N'USED_PRINTER');
                     EXEC dbo.ins_JobOrderPrintLabel
                          @PrinterID = @PrinterID,
                          @MaterialLotID = @MaterialLotID,
                          @Command = N'Print';
                 END;
         END TRY
         BEGIN CATCH
             EXEC dbo.ins_ErrorLog;
         END CATCH;
     END;
GO 

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_JobOrderSAPExport',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderSAPExport;
GO
--------------------------------------------------------------

/*
	Procedure: ins_JobOrderSAPExport
	Используется для создания задания на отправку бирки в САП.

	Parameters:

		MaterialLotID  - MaterialLot ID,
		WorkRequestID  - WorkRequest ID

	
*/
CREATE PROCEDURE [dbo].[ins_JobOrderSAPExport]
@MaterialLotID   INT,
@WorkRequestID   INT = NULL
AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255),
		   @LinkedServer  NVARCHAR(50);

   SET @LinkedServer=(SELECT top 1 Parameter from WorkDefinition where WORKType='SAPExport' order by ID desc);

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[WorkRequest],CommandRule)
   VALUES (@JobOrderID,N'SAPExport',N'TODO',CURRENT_TIMESTAMP,@WorkRequestID,@LinkedServer);
 
   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

END;

GO

 --------------------------------------------------------------
-- Процедура ins_JobOrderToPrint
IF OBJECT_ID ('dbo.ins_JobOrderToPrint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_JobOrderToPrint;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_JobOrderToPrint
	Процедура создания Job на печать или отправку бирки.

	Parameters:

		EquipmentID   - ID весов,
		MaterialLotID - MaterialLot ID,
		Command       - Email или Print,
		CommandRule   - Список адресов,
		WorkRequestID - WorkRequestID

	See Also:

		<ins_JobOrderPrintLabel>
*/
CREATE PROCEDURE [dbo].[ins_JobOrderToPrint]
@EquipmentID     INT,
@MaterialLotID   INT,
@Command         NVARCHAR(50),
@CommandRule     NVARCHAR(50) = NULL,
@WorkRequestID   INT = NULL

AS
BEGIN

   DECLARE @JobOrderID    INT,
           @err_message   NVARCHAR(255);

   IF NOT EXISTS (SELECT NULL 
                  FROM [dbo].[Equipment] eq INNER JOIN [dbo].[EquipmentClass] eqc ON (eqc.[ID] = eq.[EquipmentClassID] AND eqc.[Code]=N'PRINTER')
                  WHERE eq.[ID]=@EquipmentID)
      BEGIN
         SET @err_message = N'Equipment ID=[' + CAST(@EquipmentID AS NVARCHAR) + N'] is not a PRINTER';
         THROW 60010, @err_message, 1;
      END;

   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType],[DispatchStatus],[StartTime],[Command],[CommandRule],[WorkRequest])
   VALUES (@JobOrderID,N'Print',N'ToPrint',CURRENT_TIMESTAMP,@Command,@CommandRule,@WorkRequestID);

	 INSERT INTO [dbo].[OpEquipmentRequirement] ([EquipmentClassID],[EquipmentID],[JobOrderID])
   SELECT eq.[EquipmentClassID],eq.[ID],@JobOrderID
   FROM [dbo].[Equipment] eq
   WHERE [ID]=@EquipmentID;

   INSERT INTO [dbo].[Parameter] ([Value],[JobOrder],[PropertyType])
   SELECT @MaterialLotID,@JobOrderID,pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=N'MaterialLotID';

   IF @Command = N'Print'
    EXEC dbo.[ins_JobOrderSAPExport]
         @MaterialLotID = @MaterialLotID,
         @WorkRequestID = @WorkRequestID;

END;
GO

 SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.ins_ManualWeightEntry',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_ManualWeightEntry;
GO
--------------------------------------------------------------

/*
	Procedure: ins_ManualWeightEntry
	Используется для ручного ввода веса.

	Parameters:

		EquipmentID     - ID весов,
		Quantity        - Значение веса.

*/
CREATE PROCEDURE [dbo].[ins_ManualWeightEntry] @EquipmentID INT,
                                               @Quantity    INT
AS
     BEGIN
         IF @Quantity IS NULL THROW 60001, N'Параметр "Вес" обязательный', 1;
         IF @EquipmentID IS NULL THROW 60001, N'Параметр "EquipmentID" обязательный', 1;
         EXEC dbo.ins_MaterialLotByEquipment
              @EquipmentID = @EquipmentID,
              @Quantity = @Quantity;
     END;
GO 

--------------------------------------------------------------
-- Процедура ins_MaterialLot
IF OBJECT_ID ('dbo.ins_MaterialLot',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLot;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLot
	Процедура создания бирки.

	Parameters:

		FactoryNumber  - Номер бирки,
		Status         - Режим,
		Quantity       - Значение веса.
		MaterialLotID  - MaterialLot ID OUTPUT
*/
CREATE PROCEDURE [dbo].[ins_MaterialLot]
@FactoryNumber   NVARCHAR(250),
@Status          NVARCHAR(250),
@Quantity        INT,
@MaterialLotID   INT OUTPUT
AS
BEGIN

   SET @MaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   VALUES (@MaterialLotID,@FactoryNumber,@Status,@Quantity);

END;
GO
 --------------------------------------------------------------
-- Процедура ins_MaterialLotByEquipment
IF OBJECT_ID ('dbo.ins_MaterialLotByEquipment',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotByEquipment;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------

/*
	Procedure: ins_MaterialLotByEquipment
	Используется для тестовой печати и для ручной печати с вводом кол-ва.

	Parameters:

		EquipmentID     - ID весов,
		Quantity        - Значение веса.
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotByEquipment]
@EquipmentID   INT,
@Quantity      INT = NULL
AS
BEGIN

DECLARE @MaterialLotID    INT,
        @WorkDefinitionID INT,
        @AUTO_MANU_VALUE [NVARCHAR](50),
        @FactoryNumber   [NVARCHAR](12),
        @PrinterID       [NVARCHAR](50),
        @Status          [NVARCHAR](250),
	    @JobOrderID      INT,
        @WorkType	     [NVARCHAR](50),
		@CREATE_MODE	 [NVARCHAR](50);

SET @Status=N'0';
SET @AUTO_MANU_VALUE=N'0';
SET @WorkType = [dbo].[get_CurrentWorkType](@EquipmentID);
SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
SET @CREATE_MODE = N'Тестовая печать';

IF @Quantity IS NOT NULL
   BEGIN
      SET @Status=[dbo].[get_MaterialLotStatusByWorkType](@WorkType);
      SET @AUTO_MANU_VALUE=N'1';
      SET @Quantity=dbo.get_RoundedWeightByEquipment(@Quantity,@EquipmentID);
	  SET @CREATE_MODE = N'Печать с ручным вводом веса';
   END;

IF @WorkType IN (N'Sort',N'Reject')	     
    SET @FactoryNumber=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'FACTORY_NUMBER');	   
ELSE 
    SET @FactoryNumber=[dbo].[get_GenMaterialLotNumber](@EquipmentID,NEXT VALUE FOR dbo.gen_MaterialLotNumber);

EXEC [dbo].[ins_MaterialLot] @FactoryNumber = @FactoryNumber,
                             @Status        = @Status,
                             @Quantity      = @Quantity,
                             @MaterialLotID = @MaterialLotID OUTPUT;

SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

IF @WorkDefinitionID IS NOT NULL
   BEGIN
      DECLARE @MEASURE_TIME NVARCHAR(50),
              @MILL_ID      NVARCHAR(50),
              @NEMERA       NVARCHAR(50);
      SET @MEASURE_TIME=CONVERT(NVARCHAR,CURRENT_TIMESTAMP,121);
      SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');      
      SET @NEMERA=[dbo].[get_JobOrderPropertyValue](@JobOrderID,N'NEMERA');
      
	 EXEC [dbo].[ins_MaterialLotPropertyByWorkDefinition] @WorkDefinitionID = @WorkDefinitionID,
                                                           @MaterialLotID    = @MaterialLotID,
                                                           @MEASURE_TIME     = @MEASURE_TIME,
                                                           @AUTO_MANU_VALUE  = @AUTO_MANU_VALUE,
                                                           @MILL_ID          = @MILL_ID,
                                                           @NEMERA           = @NEMERA,
														   @CREATE_MODE		 = @CREATE_MODE;

      SET @PrinterID = [dbo].[get_EquipmentPropertyValue](@EquipmentID,N'USED_PRINTER');
      EXEC [dbo].[ins_JobOrderPrintLabel] @PrinterID     = @PrinterID,
                                          @MaterialLotID = @MaterialLotID,
                                          @Command       = N'Print';
   END;

IF @WorkType = N'Separate'
    EXEC [dbo].[set_DecreasePacksLeft] @EquipmentID=@EquipmentID;
IF @WorkType IN (N'Sort',N'Reject')
    EXEC dbo.set_StandardMode @EquipmentID=@EquipmentID; 

END;
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
@COMM_ORDER      NVARCHAR(50) = NULL,
@PROD_ORDER      NVARCHAR(50) = NULL,
@CONTRACT_NO     NVARCHAR(50) = NULL,
@DIRECTION       NVARCHAR(50) = NULL,
@SIZE            NVARCHAR(50) = NULL,
@LENGTH          NVARCHAR(50) = NULL,
@TOLERANCE       NVARCHAR(50) = NULL,
@CLASS           NVARCHAR(50) = NULL,
@STEEL_CLASS     NVARCHAR(50) = NULL,
@MELT_NO         NVARCHAR(50) = NULL,
@PART_NO         NVARCHAR(50) = NULL,
@MIN_ROD         NVARCHAR(50) = NULL,
@BUYER_ORDER_NO  NVARCHAR(50) = NULL,
@BRIGADE_NO      NVARCHAR(50) = NULL,
@PROD_DATE       NVARCHAR(50) = NULL,
@UTVK            NVARCHAR(50) = NULL,
@CHANGE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO     NVARCHAR(50) = NULL,
@BUNT_DIA        NVARCHAR(50) = NULL,
@BUNT_NO         NVARCHAR(50) = NULL,
@PRODUCT         NVARCHAR(50) = NULL,
@STANDARD        NVARCHAR(50) = NULL,
@CHEM_ANALYSIS   NVARCHAR(50) = NULL,
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

   DECLARE @MILL_ID NVARCHAR(50);
   SET @MILL_ID=[dbo].[get_EquipmentPropertyValue]([dbo].[get_ParentEquipmentIDByClass](@EquipmentID,N'MILL'),N'MILL_ID');

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

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
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL;

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
@COMM_ORDER      NVARCHAR(50) = NULL,
@PROD_ORDER      NVARCHAR(50) = NULL,
@CONTRACT_NO     NVARCHAR(50) = NULL,
@DIRECTION       NVARCHAR(50) = NULL,
@SIZE            NVARCHAR(50) = NULL,
@LENGTH          NVARCHAR(50) = NULL,
@TOLERANCE       NVARCHAR(50) = NULL,
@CLASS           NVARCHAR(50) = NULL,
@STEEL_CLASS     NVARCHAR(50) = NULL,
@MELT_NO         NVARCHAR(50) = NULL,
@PART_NO         NVARCHAR(50) = NULL,
@MIN_ROD         NVARCHAR(50) = NULL,
@BUYER_ORDER_NO  NVARCHAR(50) = NULL,
@BRIGADE_NO      NVARCHAR(50) = NULL,
@PROD_DATE       NVARCHAR(50) = NULL,
@UTVK            NVARCHAR(50) = NULL,
@CHANGE_NO       NVARCHAR(50) = NULL,
@MATERIAL_NO     NVARCHAR(50) = NULL,
@BUNT_DIA        NVARCHAR(50) = NULL,
@BUNT_NO         NVARCHAR(50) = NULL,
@PRODUCT         NVARCHAR(50) = NULL,
@STANDARD        NVARCHAR(50) = NULL,
@CHEM_ANALYSIS   NVARCHAR(50) = NULL,
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
                            Value NVARCHAR(50));

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
-- Процедура ins_MaterialLotPropertyByWorkDefinition
IF OBJECT_ID ('dbo.ins_MaterialLotPropertyByWorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotPropertyByWorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotPropertyByWorkDefinition
	Добавляет свойства бирки из WorkDefinition.

	Parameters:

		MaterialLotID    - MaterialLot ID,
		WorkRequestID    - WorkRequest ID,
		MEASURE_TIME	 - Дата и время,
        AUTO_MANU_VALUE  - Признак AUTO_MANU,
		MILL_ID			 - ID стана
		NEMERA			 - Признак "Немера"
        IDENT			 - Идентификатор взвешивания

	
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotPropertyByWorkDefinition]
@WorkDefinitionID INT,
@MaterialLotID    INT,
@MEASURE_TIME     NVARCHAR(50),
@AUTO_MANU_VALUE  NVARCHAR(50),
@MILL_ID          NVARCHAR(50) = NULL,
@NEMERA           NVARCHAR(50) = NULL,
@IDENT			  NVARCHAR(50) = NULL,
@CREATE_MODE	  NVARCHAR(50) = NULL
AS
BEGIN

   DECLARE @LEAVE_NO NVARCHAR(50);
   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   SET @LEAVE_NO =
	   (
		  SELECT sp.[Value]
		  FROM [dbo].[ParameterSpecification] sp
			  INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = sp.[PropertyType])
		  WHERE(sp.WorkDefinitionID = @WorkDefinitionID)
			  AND pt.[Value] = N'COMM_ORDER'
	   );

   INSERT @tblParams
   SELECT pt.[Value],sp.[Value]
   FROM [dbo].[ParameterSpecification] sp
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=sp.[PropertyType])
   WHERE (sp.WorkDefinitionID=@WorkDefinitionID)
   UNION ALL
   SELECT N'MEASURE_TIME',@MEASURE_TIME WHERE @MEASURE_TIME IS NOT NULL
   UNION ALL
   SELECT N'AUTO_MANU_VALUE',@AUTO_MANU_VALUE WHERE @AUTO_MANU_VALUE IS NOT NULL
   UNION ALL
   SELECT N'MILL_ID',@MILL_ID WHERE @MILL_ID IS NOT NULL
   UNION ALL
   SELECT N'NEMERA',@NEMERA WHERE @NEMERA IS NOT NULL
   UNION ALL
   SELECT N'LEAVE_NO',CAST(CAST(@LEAVE_NO AS NUMERIC(11,0))-5000000000 as nvarchar(50)) WHERE @LEAVE_NO IS NOT NULL
   UNION ALL
   SELECT N'MATERIAL_LOT_IDENT',@IDENT WHERE @IDENT IS NOT NULL
   UNION ALL
   SELECT N'CREATOR',SYSTEM_USER
   UNION ALL
   SELECT N'CREATE_MODE',@CREATE_MODE WHERE @CREATE_MODE IS NOT NULL;

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT t.value,@MaterialLotID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO
 --------------------------------------------------------------
-- Процедура ins_MaterialLotWithLinks
IF OBJECT_ID ('dbo.ins_MaterialLotWithLinks',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_MaterialLotWithLinks;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_MaterialLotWithLinks
	Создаёт новый  и запись в таблице связи бирок.

	Parameters:

		FactoryNumber     - Номер бирки,
		Status            - Статус,
		Quantity          - Вес,
		LinkType          - Тип связки,
		LinkFactoryNumber - Номер новой бирки,
		MaterialLotID     - MaterialLot ID OUTPUT

	
*/
CREATE PROCEDURE [dbo].[ins_MaterialLotWithLinks]
@FactoryNumber       NVARCHAR(250),
@Status              NVARCHAR(250),
@Quantity            INT = NULL,
@LinkType            INT = 1,
@LinkFactoryNumber   NVARCHAR(250) = NULL,
@MaterialLotID       INT OUTPUT
AS
BEGIN

  DECLARE @LastMaterialLotID INT,
          @LastQuantity      INT,
          @err_message       NVARCHAR(255);

   SELECT @LastMaterialLotID=ml.[ID],
          @LastQuantity=ml.[Quantity]
   FROM (SELECT ml.[ID],
                ml.[Quantity],
                ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
         FROM [dbo].[MaterialLot] ml
         WHERE ml.[FactoryNumber]=@FactoryNumber) ml
   WHERE ml.RowNumber=1;

   IF @LastMaterialLotID IS NULL
      BEGIN
         SET @err_message = N'By FactoryNumber [' + @FactoryNumber + N'] MaterialLot not found';
         THROW 60010, @err_message, 1;
      END;

   SET @MaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   VALUES (@MaterialLotID,ISNULL(@LinkFactoryNumber,@FactoryNumber),@Status,ISNULL(@Quantity,@LastQuantity));

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@LastMaterialLotID,@MaterialLotID,@LinkType);

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
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50) = NULL,
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @OperationsRequestID     INT,
           @OpSegmentRequirementID  INT,
           @err_message             NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
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

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
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
-- Процедура ins_WorkRequest
IF OBJECT_ID ('dbo.ins_WorkRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkRequest;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: ins_WorkRequest
	Процедура вставки Work Request.

	Parameters:

		WorkType		- Режим,
		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок.
		WorkRequestID   - Work Request ID OUTPUT.

*/
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
@PACKS_LEFT       NVARCHAR(50) = NULL,
@BINDING_DIA      NVARCHAR(50) = NULL,
@BINDING_QTY      NVARCHAR(50) = NULL,
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
                             @PACKS_LEFT      = @PACKS_LEFT,
                             @BINDING_DIA     = @BINDING_DIA,
                             @BINDING_QTY     = @BINDING_QTY,
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
/*
	Procedure: ins_WorkRequestStandart
	Процедура вставки  стандартного Work Request.

	Parameters:

		EquipmentID     - ID весов,
		ProfileID       - ID профиля,
		COMM_ORDER      - Номер коммерческого заказа,
		LENGTH          - Длина,
		BAR_WEIGHT      - Вес прутка,
		BAR_QUANTITY    - Количество прутков,
		MAX_WEIGHT      - Максимальный вес,
		MIN_WEIGHT      - Минимальный вес,
		SAMPLE_WEIGHT   - Вес образца,
		SAMPLE_LENGTH   - Длина образца,
		DEVIATION       - Отклонение,
		SANDWICH_MODE   - Признак "Бутерброд",
		AUTO_MANU_VALUE - Признак "Автоматический режим",
		NEMERA          - Признак "Немера",
		FACTORY_NUMBER  - Номер бирки,
		PACKS_LEFT      - Количество оставшихся пачек для режима "Разделение пачки",
		BINDING_DIA     - Диаметр увязки,
		BINDING_QTY     - Количество увязок.

*/
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
@NEMERA           NVARCHAR(50),
@BINDING_DIA      NVARCHAR(50),
@BINDING_QTY      NVARCHAR(50)
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
                                @BINDING_DIA     = @BINDING_DIA,
                                @BINDING_QTY     = @BINDING_QTY,
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
-- Процедура dbo.set_DecreasePacksLeft
IF OBJECT_ID ('dbo.set_DecreasePacksLeft',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_DecreasePacksLeft;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_DecreasePacksLeft
	Процедура уменьшения количества пачек.

	Parameters:

		EquipmentID    - ID весов,
	
*/
CREATE PROCEDURE [dbo].[set_DecreasePacksLeft]
@EquipmentID    INT
AS
BEGIN

   DECLARE @JobOrder        [NVARCHAR](50),
           @JobOrderID      INT,
           @PACKS_LEFT      [NVARCHAR](50),
           @PropertyValue   [NVARCHAR](50);

   SET @JobOrder=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   IF @JobOrder IS NOT NULL
      BEGIN
         SET @JobOrderID=CAST(@JobOrder AS INT);
         SET @PACKS_LEFT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'PACKS_LEFT');
         IF CAST(IsNull(@PACKS_LEFT,N'0') AS INT)>0
            BEGIN
               SET @PropertyValue=CAST(CAST(@PACKS_LEFT AS INT) - 1 AS NVARCHAR);
               EXEC [dbo].[upd_JobOrderProperty] @JobOrderID    = @JobOrderID,
                                                 @PropertyType  = N'PACKS_LEFT',
                                                 @PropertyValue = @PropertyValue;
            END;
		IF @PACKS_LEFT='1' 
		  EXEC dbo.set_StandardMode @EquipmentID=@EquipmentID;
      END;
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
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

   EXEC [dbo].[ins_JobOrderOPCCommandAutoManu] @WorkRequestID = @WorkRequestID,
                                               @EquipmentID   = @EquipmentID,
                                               @TagValue      = N'false';

END;
GO
 --------------------------------------------------------------
-- Процедура dbo.set_StandardMode
IF OBJECT_ID ('dbo.set_StandardMode',N'P') IS NOT NULL
   DROP PROCEDURE dbo.set_StandardMode;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: set_StandardMode
	Процедура установки стандартного режима.

	Parameters:
		EquipmentID	- ID оборудования.
	
		
*/
CREATE PROCEDURE [dbo].[set_StandardMode]
@EquipmentID    INT
AS
BEGIN

   DECLARE @StandardWorkDefinitionID [NVARCHAR](50),
           @StandardJobOrderID       [NVARCHAR](50);

   SET @StandardWorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'STANDARD_WORK_DEFINITION_ID');
   SET @StandardJobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'STANDARD_JOB_ORDER_ID');

   IF @StandardWorkDefinitionID IS NOT NULL
      EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                         @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                         @EquipmentPropertyValue = @StandardWorkDefinitionID;

   IF @StandardJobOrderID IS NOT NULL
      BEGIN
         EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                            @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
                                            @EquipmentPropertyValue = @StandardJobOrderID;

         DECLARE @JobOrderID      INT,
                 @WorkRequestID   INT,
                 @MAX_WEIGHT      [NVARCHAR](50),
                 @MIN_WEIGHT      [NVARCHAR](50),
                 @SANDWICH_MODE   [NVARCHAR](50),
                 @AUTO_MANU_VALUE [NVARCHAR](50);


         SET @JobOrderID=CAST(@StandardJobOrderID AS INT);
         SET @WorkRequestID=dbo.get_WorkRequestByJobOrder(@JobOrderID);

         SET @MAX_WEIGHT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'MAX_WEIGHT');
         SET @MIN_WEIGHT=dbo.get_JobOrderPropertyValue(@JobOrderID,N'MIN_WEIGHT');
         SET @SANDWICH_MODE=dbo.get_JobOrderPropertyValue(@JobOrderID,N'SANDWICH_MODE');
         SET @AUTO_MANU_VALUE=dbo.get_JobOrderPropertyValue(@JobOrderID,N'AUTO_MANU_VALUE');

         -- Отправляем команды на котроллер
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

	IF @StandardJobOrderID IS NULL
	   BEGIN
		  EXEC [dbo].[upd_EquipmentProperty]
			  @EquipmentID = @EquipmentID,
			  @EquipmentClassPropertyValue = N'JOB_ORDER_ID',
			  @EquipmentPropertyValue = NULL;
	   END;

/*
   IF @JobOrderID IS NULL
      BEGIN
         SET @err_message = N'Property JOB_ORDER_ID is not set for EquipmentID=[' + CAST(@EquipmentID AS NVARCHAR) + N']';
         THROW 60010, @err_message, 1;
      END;
*/
END;
GO
 --------------------------------------------------------------
-- Процедура upd_EquipmentProperty
IF OBJECT_ID ('dbo.upd_EquipmentProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EquipmentProperty;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_EquipmentProperty
	Процедура изменения свойства оборудования.

	Parameters:
		EquipmentID					- ID оборудования,
		EquipmentClassPropertyValue - Свойство,
		EquipmentPropertyValue		- Значение свойства.

		
*/

CREATE PROCEDURE [dbo].[upd_EquipmentProperty]
@EquipmentID                   INT,
@EquipmentClassPropertyValue   NVARCHAR(50),
@EquipmentPropertyValue        NVARCHAR(50)
AS
BEGIN
   DECLARE @err_message          NVARCHAR(255);

   IF @EquipmentID IS NULL
      THROW 60001, N'EquipmentID param required', 1;
   ELSE IF @EquipmentClassPropertyValue IS NULL
      THROW 60001, N'EquipmentClassPropertyValue param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL 
                       FROM [dbo].[EquipmentClassProperty] ecp
                       WHERE ecp.[Value]=@EquipmentClassPropertyValue)
      BEGIN
         SET @err_message = N'EquipmentClassProperty Value=['+@EquipmentClassPropertyValue+N'] not found';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF NOT EXISTS (SELECT NULL 
                       FROM [dbo].[EquipmentClassProperty] ecp
                            INNER JOIN [dbo].[Equipment] eq ON (eq.[ID]=@EquipmentID AND eq.[EquipmentClassID]=ecp.[EquipmentClassID])
                       WHERE ecp.[Value]=@EquipmentClassPropertyValue)
      BEGIN
         SELECT @err_message = N'Wrong EquipmentClassProperty Value=['+@EquipmentClassPropertyValue+ N'] for Equipment ID=['+CAST(@EquipmentID AS NVARCHAR)+']';
         THROW 60010, @err_message, 1;
      END;
   -- allow NULL to be able to clear values
   --ELSE IF @EquipmentPropertyValue IS NULL
   --   THROW 60001, N'EquipmentPropertyValue param required', 1;

   MERGE [dbo].[EquipmentProperty] ep
   USING (SELECT dbo.get_EquipmentClassPropertyByValue(@EquipmentClassPropertyValue) EquipmentClassPropertyID) ecp
   ON (ep.[EquipmentID]=@EquipmentID AND ep.[ClassPropertyID]=ecp.EquipmentClassPropertyID)
   WHEN MATCHED THEN
      UPDATE SET ep.[Value]=@EquipmentPropertyValue
   WHEN NOT MATCHED THEN
      INSERT ([Value],[EquipmentID],[ClassPropertyID])
      VALUES (@EquipmentPropertyValue,@EquipmentID,ecp.EquipmentClassPropertyID);

END;
GO

 SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelCancel',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelCancel;
GO
--------------------------------------------------------------

/*
	Procedure: upd_JobOrderPrintLabelCancel
	Используется для отмены задания на печать.

	Parameters:
		
		MaterialLotIDs - Айдишники бирок для отмены печати
		
*/
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelCancel] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'Done';
     END;
GO 

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelChangeStatus',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelChangeStatus;
GO
--------------------------------------------------------------

/*
	Procedure: upd_JobOrderPrintLabelChangeStatus
	Используется для смены статуса задания на печать.

	Parameters:
		
		MaterialLotIDs - Айдишники бирок для измениния,
		Status		   - Статус.
		
*/
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelChangeStatus]
@MaterialLotIDs   NVARCHAR(MAX),
@Status NVARCHAR(50)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID     INT,
	   @JobOrderID	    INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @JobOrderID = (SELECT max(p.JobOrder)
         FROM Parameter p,
              PropertyTypes pt,
              JobOrder jo
         WHERE pt.ID = p.PropertyType
               AND pt.[Value] = N'MaterialLotID'
               AND jo.ID = p.JobOrder			   
			   and jo.WorkType=N'Print'
			and p.[Value]=cast(@MaterialLotID as nvarchar));

    IF @JobOrderID IS NOT NULL
	   update dbo.JobOrder set DispatchStatus=@Status where ID=@JobOrderID;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;

GO


 SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderPrintLabelReprint',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderPrintLabelReprint;
GO
--------------------------------------------------------------

/*
	Procedure: upd_JobOrderPrintLabelReprint
	Используется повторной отправки бирок на печать.

	Parameters:
		
		MaterialLotIDs - Айдишники бирок для повторной печати
		
*/
CREATE PROCEDURE [dbo].[upd_JobOrderPrintLabelReprint] @MaterialLotIDs NVARCHAR(MAX)
AS
     BEGIN
         EXEC dbo.[upd_JobOrderPrintLabelChangeStatus]
              @MaterialLotIDs = @MaterialLotIDs,
              @Status = N'ToPrint';
     END;

GO


 --------------------------------------------------------------
-- Процедура upd_JobOrderProperty
IF OBJECT_ID ('dbo.upd_JobOrderProperty',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderProperty;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_JobOrderProperty
	Процедура изменения свойства Job Order.

	Parameters:
		JobOrderID     - Job Order ID ,
		PropertyType   - Свойство,
		PropertyValue  - Значение свойства

		
*/
CREATE PROCEDURE [dbo].[upd_JobOrderProperty]
@JobOrderID      INT,
@PropertyType    NVARCHAR(50),
@PropertyValue   NVARCHAR(50)
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @JobOrderID IS NULL
      THROW 60001, N'JobOrderID param required', 1;
   ELSE IF @PropertyType IS NULL
      THROW 60001, N'PropertyType param required', 1;
   ELSE IF @PropertyValue IS NULL
      THROW 60001, N'PropertyValue param required', 1;

   SELECT @ID=pt.[ID]
   FROM [dbo].[PropertyTypes] pt
   WHERE pt.[Value]=@PropertyType;

    IF @ID IS NULL
      BEGIN
         SET @err_message = N'PropertyType Value=['+@PropertyType+N'] not found';
         THROW 60010, @err_message, 1;
      END;

   UPDATE [dbo].[Parameter]
   SET [Value]=@PropertyValue
   WHERE [JobOrder]=@JobOrderID
     AND [PropertyType]=@ID;

/*
   MERGE [dbo].[Parameter] p
   USING (SELECT pt.* FROM [dbo].[PropertyTypes] pt) pt
   ON (p.[JobOrder]=@JobOrderID AND p.[PropertyType]=pt.[ID])
   WHEN MATCHED THEN
      UPDATE SET p.[Value]=@PropertyValue
   WHEN NOT MATCHED THEN
      INSERT ([Value],[JobOrder],[PropertyType])
      VALUES (@PropertyValue,@JobOrderID,pt.[ID]);
*/
END;
GO

 SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.upd_JobOrderSAPOrderRequest',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_JobOrderSAPOrderRequest;
GO
/*
	Procedure: upd_JobOrderSAPOrderRequest
	Процедура изменения параметров запроса в SAP.

	Parameters:
		ServiceURL - Service URL,
		Login	   - Логин,
		Password   - Пароль.

		
*/

CREATE PROCEDURE [dbo].[upd_JobOrderSAPOrderRequest]
@ServiceURL NVARCHAR(1000),
@Login		NVARCHAR(250),
@Password   NVARCHAR(250)
WITH ENCRYPTION 
AS
BEGIN
   DECLARE @JobOrderID            INT,
		  @SAP_SERVICE_URL	  INT,
		  @SAP_SERVICE_PASS	  INT,
		  @SAP_SERVICE_LOGIN  INT;

   IF @ServiceURL IS NULL
      THROW 60001, N'ServiceURL param required', 1;
   ELSE IF @Login IS NULL
      THROW 60001, N'Login param required', 1;
   ELSE IF @Password IS NULL
      THROW 60001, N'Password param required', 1;

   SET @JobOrderID = (SELECT max(ID) from JobOrder where WorkType=N'SAPOrderRequest');

   IF @JobOrderID IS NULL
	   BEGIN
		   SET @JobOrderID=NEXT VALUE FOR [dbo].[gen_JobOrder];
		   INSERT INTO [dbo].[JobOrder] ([ID],[WorkType])
		   VALUES (@JobOrderID,N'SAPOrderRequest');
	   END

    SET @SAP_SERVICE_URL = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_URL');
    SET @SAP_SERVICE_LOGIN = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_LOGIN');
    SET @SAP_SERVICE_PASS = (SELECT ID from dbo.PropertyTypes where [Value]=N'SAP_SERVICE_PASS');

	MERGE [dbo].[Parameter] p
		USING
		(
			SELECT @ServiceURL AS vValue, @JobOrderID AS vJobOrder, @SAP_SERVICE_URL AS vPropertyType
			/*UNION
			SELECT @Login, @JobOrderID, @SAP_SERVICE_LOGIN
			UNION
			SELECT @Password, @JobOrderID, @SAP_SERVICE_PASS*/
			UNION
			SELECT cast(ENCRYPTBYPASSPHRASE(N'arcelor', @Login) as nvarchar), @JobOrderID, @SAP_SERVICE_LOGIN
			UNION
			SELECT cast(ENCRYPTBYPASSPHRASE(N'arcelor', @Password) as nvarchar), @JobOrderID, @SAP_SERVICE_PASS
		) val
		ON( p.JobOrder = val.vJobOrder AND 
			p.PropertyType = val.vPropertyType
		  )
		WHEN MATCHED
			  THEN UPDATE SET p.[Value] = val.vValue
		WHEN NOT MATCHED
			  THEN INSERT([Value], JobOrder, [PropertyType]) VALUES( val.vValue, val.vJobOrder, val.vPropertyType );

END;


GO


 --------------------------------------------------------------
-- Процедура upd_MaterialLotProdOrder
IF OBJECT_ID ('dbo.upd_MaterialLotProdOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotProdOrder;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_MaterialLotProdOrder
	Процедура изменения призводственного заказа.

	Parameters:

		MaterialLotIDs - Айдишники бирок для изменения,
		PROD_ORDER     - Производственный заказ.
		
*/
CREATE PROCEDURE [dbo].[upd_MaterialLotProdOrder]
@MaterialLotIDs   NVARCHAR(MAX),
@PROD_ORDER       NVARCHAR(50)
AS
BEGIN

SET NOCOUNT ON;

IF @MaterialLotIDs IS NULL
   RETURN;

DECLARE @MaterialLotID     INT,
        @LinkMaterialLotID INT;

DECLARE selMaterialLots CURSOR FOR SELECT ml.[ID]
                                   FROM [dbo].[MaterialLot] ml INNER JOIN dbo.get_TableInteger(@MaterialLotIDs,DEFAULT) t ON (t.[ID]=ml.ID);

OPEN selMaterialLots

FETCH NEXT FROM selMaterialLots INTO @MaterialLotID
WHILE @@FETCH_STATUS = 0
BEGIN

   SET @LinkMaterialLotID=NEXT VALUE FOR [dbo].[gen_MaterialLot];
   INSERT INTO [dbo].[MaterialLot] ([ID],[FactoryNumber],[Status],[Quantity])
   (SELECT @LinkMaterialLotID,[FactoryNumber],N'1',[Quantity]
    FROM [dbo].[MaterialLot] ml
    WHERE ml.[ID]=@MaterialLotID);

   INSERT INTO [dbo].[MaterialLotLinks] ([MaterialLot1],[MaterialLot2],[LinkType])
   VALUES (@MaterialLotID,@LinkMaterialLotID,1);

   INSERT INTO [dbo].[MaterialLotProperty] ([Value],[MaterialLotID],[PropertyType])
   SELECT mlp.[Value],@LinkMaterialLotID,mlp.[PropertyType]
   FROM [dbo].[MaterialLotProperty] mlp
   WHERE mlp.[MaterialLotID]=@MaterialLotID

   MERGE [dbo].[MaterialLotProperty] mlp
   USING (SELECT pt.ID
          FROM [dbo].[PropertyTypes] pt 
          WHERE (pt.value=N'PROD_ORDER')) pt
   ON (mlp.[MaterialLotID]=@LinkMaterialLotID AND pt.[ID]=mlp.[PropertyType])
   WHEN MATCHED THEN
      UPDATE SET mlp.[Value]=@PROD_ORDER
   WHEN NOT MATCHED THEN
      INSERT ([Value],[MaterialLotID],[PropertyType])
      VALUES (@PROD_ORDER,@LinkMaterialLotID,pt.[ID]);

   EXEC DBO.[ins_JobOrderSAPExport] @MaterialLotID=@LinkMaterialLotID;

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

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
@COMM_ORDER     NVARCHAR(50),
@PROD_ORDER     NVARCHAR(50) = NULL,
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
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
                            Value NVARCHAR(50));

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
CREATE PROCEDURE [dbo].[upd_WorkDefinition]
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
@CHANGE_NO      NVARCHAR(50) = NULL,
@MATERIAL_NO    NVARCHAR(50) = NULL,
@BUNT_DIA       NVARCHAR(50) = NULL,
@BUNT_NO        NVARCHAR(50) = NULL,
@PRODUCT        NVARCHAR(50) = NULL,
@STANDARD       NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL,
@TEMPLATE       INT          = NULL
AS
BEGIN
   DECLARE @WorkDefinitionID     INT,
           @err_message          NVARCHAR(255);

   IF @COMM_ORDER IS NULL
    THROW 60001, N'Параметр "Коммерческий заказ" обязательный', 1;
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

	BEGIN TRY
		SELECT CAST(@COMM_ORDER AS NUMERIC(11,0))
	END TRY
	BEGIN CATCH
		 THROW 60001, N'Параметр "Коммерческий заказ" должен быть числом', 1;
	END CATCH;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   SELECT @WorkDefinitionID=pso.WorkDefinitionID
   FROM [dbo].[v_ParameterSpecification_Order] pso
   WHERE pso.[Value]=@COMM_ORDER
     AND pso.[EquipmentID]=@EquipmentID;

   IF @WorkDefinitionID IS NULL
      BEGIN
         SET @err_message = N'WorkDefinition [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   DECLARE @EquipmentPropertyValue NVARCHAR(50);
   SET @EquipmentPropertyValue=CAST(@WorkDefinitionID AS NVARCHAR);
   EXEC [dbo].[upd_EquipmentProperty] @EquipmentID = @EquipmentID,
                                      @EquipmentClassPropertyValue = N'WORK_DEFINITION_ID',
                                      @EquipmentPropertyValue = @EquipmentPropertyValue;

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

   DELETE FROM [dbo].[ParameterSpecification]
   WHERE [WorkDefinitionID]=@WorkDefinitionID;

   INSERT INTO [dbo].[ParameterSpecification] ([Value],[WorkDefinitionID],[PropertyType])
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

END;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_AvailableScales', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableScales];
GO
/*
   View: v_AvailableScales
   Возвращает список доступных весов.
*/
CREATE VIEW [dbo].[v_AvailableScales]
AS
     SELECT DISTINCT
            e.ID,
            e.Description,
            side.ID sideID
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment e,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,
          dbo.EquipmentClass ec
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.get_CurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND side.ID = e.Equipment
           AND ec.Code = N'SCALES'
           AND ec.ID = e.EquipmentClassID;
GO 

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_AvailableSides', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableSides];
GO
/*
   View: v_AvailableSides
   Возвращает список доступных сторон.
*/
CREATE VIEW [dbo].[v_AvailableSides]
AS
     SELECT DISTINCT
            side.ID,
            workshop.Description+' \ '+mill.Description+' \ '+side.[Description] [Description]
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment side,
          dbo.Equipment mill,
		  dbo.Equipment workshop,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.get_CurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment;
GO 

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_BindingDia', N'V') IS NOT NULL
    DROP VIEW dbo.[v_BindingDia];
GO
/*
   View: v_BindingDia 
   Возвращает список возможных диаметров увязки.
*/
CREATE VIEW [dbo].[v_BindingDia]
AS
SELECT min(p.ID) ID,
       p.[Value]
FROM MaterialDefinitionProperty p
     INNER JOIN MaterialClassProperty mcp ON p.ClassPropertyID = mcp.ID
                                             AND mcp.[Value] = N'BINDING_DIA'
     INNER JOIN MaterialClass mc ON mc.ID = mcp.MaterialClassID
                                    AND mc.Code = N'BINDING'
 group by p.[Value];
GO

 SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_BindingQty', N'V') IS NOT NULL
    DROP VIEW dbo.[v_BindingQty];
GO
/*
   View: v_BindingQty
   Возвращает список возможных количеств увязки.
*/
CREATE VIEW [dbo].[v_BindingQty]
AS
SELECT min(p.ID) ID,
       p.[Value]
FROM MaterialDefinitionProperty p
     INNER JOIN MaterialClassProperty mcp ON p.ClassPropertyID = mcp.ID
                                             AND mcp.[Value] = N'BINDING_QTY'
     INNER JOIN MaterialClass mc ON mc.ID = mcp.MaterialClassID
                                    AND mc.Code = N'BINDING'
							 group by p.[Value];
GO 

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_EquipmentProperty', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_EquipmentProperty];
GO
/*
   View: v_EquipmentProperty
    Возвращает свойств оборудования.
*/
CREATE VIEW [dbo].[v_EquipmentProperty]
AS
     SELECT ep.ID,
            ep.[Value],
            ep.EquipmentID,
            ecp.[Description],
            ecp.[Value] Property
     FROM dbo.EquipmentProperty ep,
          dbo.EquipmentClassProperty ecp
     WHERE ecp.ID = ep.ClassPropertyID;
GO
 SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_EquipmentProperty_PrinterNo', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_EquipmentProperty_PrinterNo];
GO
/*
   View: v_EquipmentProperty_PrinterNo
    Создана для обеспечения уникальности PRINTER_NO.
*/
CREATE VIEW [dbo].[v_EquipmentProperty_PrinterNo] WITH SCHEMABINDING
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'PRINTER_NO')
GO

CREATE UNIQUE CLUSTERED INDEX [u_EquipmentProperty_PrinterNo] ON [dbo].[v_EquipmentProperty_PrinterNo] (Value)
GO 

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_EquipmentProperty_ScalesNo', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_EquipmentProperty_ScalesNo];
GO
/*
   View: v_EquipmentProperty_ScalesNo
    Создана для обеспечения уникальности SCALES_NO.
*/
CREATE VIEW [dbo].[v_EquipmentProperty_ScalesNo] WITH SCHEMABINDING
AS
SELECT ep.ID, ep.[Value], ep.[Description], ep.EquipmentID, ep.ClassPropertyID
FROM [dbo].[EquipmentProperty] ep
     INNER JOIN [dbo].[EquipmentClassProperty] ecp ON (ecp.ID=ep.ClassPropertyID AND ecp.Value=N'SCALES_NO')
GO

CREATE UNIQUE CLUSTERED INDEX [u_EquipmentProperty_ScalesNo] ON [dbo].[v_EquipmentProperty_ScalesNo] (Value)
GO 

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_JobOrders', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_JobOrders];
GO
/*
   View: v_JobOrders
   Возвращает список JobOrder.
*/
CREATE VIEW [dbo].[v_JobOrders]
AS
     SELECT ID,
            DispatchStatus,
		  WorkType,
		  Command,
		  CommandRule
     FROM dbo.JobOrder;
GO 

IF OBJECT_ID ('dbo.v_LatestWorkRequests', N'V') IS NOT NULL
   DROP VIEW dbo.v_LatestWorkRequests;
GO
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLot', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLot;
GO
/*
   View: v_MaterialLot
    Возвращает список бирок.
*/
CREATE VIEW [dbo].[v_MaterialLot]
AS
SELECT *,
       CASE [Status]
           WHEN '0'
           THEN N'Печать'
           WHEN '1'
           THEN N'Перемаркировка'
           WHEN '2'
           THEN N'Сортировка'
           WHEN '3'
           THEN N'Отбраковка'
           WHEN '4'
           THEN N'Разделение пачки'
       END StatusName,
       (CASE ps.DispatchStatus
            WHEN N'Done'
            THEN CAST(1 AS BIT)
            WHEN N'ToPrint'
            THEN CAST(0 AS BIT)
            ELSE NULL
        END) isPrinted
FROM [dbo].[MaterialLot] mlp
     LEFT OUTER JOIN (SELECT ww.MaterialLotID,
                             ww.DispatchStatus
                      FROM (SELECT ROW_NUMBER() OVER (PARTITION BY p.[Value] ORDER BY jo.ID DESC) rnum,
                                   jo.ID,
                                   jo.DispatchStatus,
                                   CAST(p.[Value] AS INT) MaterialLotID
                            FROM Parameter p,PropertyTypes pt,JobOrder jo
                            WHERE pt.ID = p.PropertyType
                              AND pt.[Value] = N'MaterialLotID'
                              AND jo.ID = p.JobOrder
                              AND jo.WorkType=N'Print') ww
                       WHERE ww.rnum=1) ps ON ps.MaterialLotID=mlp.ID;
GO 

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
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
     WITH MaterialLotProperties
          AS (SELECT mlp.[ID],
                     mlp.[MaterialLotID],
                     pt.[Value] PropertyType,
                     mlp.[Value]
              FROM [dbo].[MaterialLotProperty] mlp
                   INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]))
          SELECT ml.ID,
                 ml.FactoryNumber,
                 ml.CreateTime,
                 ml.Quantity,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PROD_ORDER'
          ) PROD_ORDER,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PART_NO'
          ) PART_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'BUNT_NO'
          ) BUNT_NO,
                 CAST(0 AS BIT) selected
          FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
						    ml.CreateTime,
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1;
GO      

 SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
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
 SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
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

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
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
     WITH MaterialLotProperties
          AS (SELECT mlp.[ID],
                     mlp.[MaterialLotID],
                     pt.[Value] PropertyType,
                     mlp.[Value]
              FROM [dbo].[MaterialLotProperty] mlp
                   INNER JOIN [dbo].[PropertyTypes] pt ON(pt.[ID] = mlp.[PropertyType]))
          SELECT ml.ID,
                 ml.FactoryNumber,
                 ml.CreateTime,
                 ml.Quantity,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'CHANGE_NO'
          ) CHANGE_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'BRIGADE_NO'
          ) BRIGADE_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'MELT_NO'
          ) MELT_NO,
          (
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'COMM_ORDER'
          ) COMM_ORDER,
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'PART_NO'
          ) PART_NO,  
		(
              SELECT [Value]
              FROM MaterialLotProperties
              WHERE MaterialLotID = ml.Id
                    AND PropertyType = 'AUTO_MANU_VALUE'
          ) AUTO_MANU_VALUE     
          FROM (SELECT ml.[ID],
                                  ml.[FactoryNumber],
                                  ml.[Status],
                                  ml.[Quantity],
						    ml.CreateTime,
                                  ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
                           FROM [dbo].[MaterialLot] ml) ml
                     WHERE ml.RowNumber=1;
GO 

IF OBJECT_ID ('dbo.v_OrderProperties', N'V') IS NOT NULL
   DROP VIEW dbo.v_OrderProperties;
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

IF OBJECT_ID ('dbo.v_Orders', N'V') IS NOT NULL
   DROP VIEW dbo.v_Orders;
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
 SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ParameterSpecification_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_ParameterSpecification_Order];
GO
/*
   View: v_ParameterSpecification_Order
    Возвращает список свойств WorkDefinition.
*/
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

 SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_Parameter_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_Parameter_Order];
GO
/*
   View: v_Parameter_Order
    Возвращает список свойств JobOrder.
*/
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

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_PersonProperty_AD_Login', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_PersonProperty_AD_Login];
GO
/*
   View: v_PersonProperty_AD_Login
    Обеспечивает уникальность AD_Login.
*/
CREATE VIEW [dbo].[v_PersonProperty_AD_Login] WITH SCHEMABINDING
AS
SELECT pp.[ID], pp.[Value], pp.[Description], pp.[PersonID], pp.[ClassPropertyID]
FROM [dbo].[PersonProperty] pp
     INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'AD_LOGIN')
GO

CREATE UNIQUE CLUSTERED INDEX [u_PersonProperty_AD_Login] ON [dbo].[v_PersonProperty_AD_Login] ([Value])
GO

 SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintJobParameters', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintJobParameters];
GO
/*
   View: v_PrintJobParameters
    Возвращает параметры Print Job .
*/

CREATE VIEW [dbo].[v_PrintJobParameters]
AS
     SELECT p.ID,
            p.[Value],
            p.JobOrder AS JobOrderID,
            pt.[Value] Property
     FROM Parameter p,
          PropertyTypes pt
     WHERE pt.ID = p.PropertyType
     UNION ALL
     SELECT er.ID,
            CAST(er.EquipmentID AS NVARCHAR),
            er.JobOrderID,
            'PrinterID' AS Property
     FROM OpEquipmentRequirement er;
GO 

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.v_PrintTemplate', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_PrintTemplate];
GO
/*
   View: v_PrintProperties
    Возвращает пустые свойства MaterialLot для печати шаблона.
*/

CREATE VIEW [dbo].[v_PrintTemplate]
AS
SELECT NEWID() AS ID,
       N'MaterialLotProperty' AS TypeProperty,
       mcp.[Value] AS PropertyCode,
       mcp.Description,
       NULL AS [Value]
FROM dbo.PropertyTypes AS mcp
WHERE mcp.[Value] IN(N'STANDARD', N'LENGTH', N'MIN_ROD', N'CONTRACT_NO', N'DIRECTION', N'PRODUCT', N'CLASS', N'STEEL_CLASS', N'CHEM_ANALYSIS', N'BUNT_DIA', N'ADDRESS', N'PROD_ORDER', N'PROD_DATE', N'MELT_NO', N'PART_NO', N'BUNT_NO', N'LEAVE_NO', N'CHANGE_NO', N'BRIGADE_NO', N'SIZE', N'TOLERANCE', N'BUYER_ORDER_NO', N'UTVK', N'MATERIAL_NO')
UNION ALL
SELECT NEWID() AS ID,
       N'Weight' AS TypeProperty,
       N'WEIGHT' AS PropertyCode,
       N'МАССА' AS Description,
       NULL AS [Value]
UNION ALL
SELECT NEWID() AS ID,
       N'FactoryNumber' AS TypeProperty,
       N'FactoryNumber' AS PropertyCode,
       N'№ бирки для штрих-кода' AS Description,
       NULL AS [Value];

GO 

IF OBJECT_ID ('dbo.v_Roles', N'V') IS NOT NULL
   DROP VIEW dbo.v_Roles;
GO
/*
   View: v_Roles
    Возвращает список доступных ролей.
*/
CREATE VIEW dbo.v_Roles
AS
SELECT kppr.ID,
       kppr.RoleName
FROM sys.server_permissions sper
     INNER JOIN sys.server_principals sprin ON (sprin.principal_id=sper.grantee_principal_id AND sprin.is_disabled=0 AND sprin.type=N'G' AND sprin.type_desc=N'WINDOWS_GROUP')
     INNER JOIN dbo.KPPRoles kppr ON (kppr.ADRoleName=sprin.name)
GO
 SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_SAPOrderRequest', 'V') IS NOT NULL
	DROP VIEW dbo.[v_SAPOrderRequest];
GO
 
CREATE VIEW [dbo].[v_SAPOrderRequest]
AS
SELECT p.ID,
	   pt.[Value] PropertyType,
       p.[Value]
FROM JobOrder o,
     [Parameter] p,
     dbo.PropertyTypes pt
WHERE WorkType = 'SAPOrderRequest'
      AND p.JobOrder = o.ID
      AND pt.ID = p.PropertyType
	  and pt.[Value]=N'SAP_SERVICE_URL';
GO 

SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO
/*
   View: v_ScalesDetailInfo
    Возвращает данные из контроллера а также расчитывает количество прудков для весов.
	Используется на экране маркиорвщицы.
*/
CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
     WITH BarWeight
          AS (SELECT CAST(par.[Value] AS FLOAT) PropertyValue,
                     pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] IN(N'BAR_WEIGHT', N'MIN_WEIGHT', N'MAX_WEIGHT', N'BAR_QUANTITY')
              AND pr.ID = par.PropertyType
              AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
          AND ep.[Value] = par.JobOrder),
          Kep_Data
          AS (SELECT *
              FROM
              (
                  SELECT ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                         kl.[WEIGHT_CURRENT],
                         kl.[WEIGHT_STAB],
                         kl.[WEIGHT_ZERO],
                         kl.[COUNT_BAR],
                         kl.[REM_BAR],
                         kl.[AUTO_MANU],
                         kl.[POCKET_LOC],
                         kl.[PACK_SANDWICH],
                         kl.[NUMBER_POCKET]
                  FROM dbo.KEP_logger kl
                  WHERE kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE())
              ) ww
              WHERE ww.RowNumber = 1)
          SELECT eq.ID AS ID,
                 eq.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) WEIGHT_CURRENT,
                 kd.WEIGHT_STAB,
                 kd.WEIGHT_ZERO,
                 kd.AUTO_MANU,
                 kd.POCKET_LOC,
                 kd.PACK_SANDWICH,
                 CAST(0 AS   BIT) AS ALARM,
                 CAST(FLOOR(dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) / bw.PropertyValue) AS   INT) RodsQuantity,
                 kd.REM_BAR RodsLeft,
                 ISNULL(CAST(bminW.PropertyValue AS INT), 0) MinWeight,
                 ISNULL(CAST(bmaxW.PropertyValue AS INT), 0) MaxWeight,
                 ISNULL(dbo.get_RoundedWeight(bmaxW.PropertyValue * 1.2, 'UP', 100), dbo.get_EquipmentPropertyValue(eq.ID, N'MAX_WEIGHT')) MaxPossibleWeight,
                 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'SCALES_TYPE'), N'POCKET') SCALES_TYPE,
				 dbo.get_EquipmentPropertyValue(eq.ID, N'PACK_RULE') PACK_RULE,
				 CAST(bQty.PropertyValue AS INT)		BAR_QUANTITY,
			 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'TAKE_WEIGHT_LOCKED'), '0') TAKE_WEIGHT_LOCKED
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1
                                              AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID
                                               AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bminW ON bminW.EquipmentId = eq.ID
                                                  AND bminW.PropertyType = N'MIN_WEIGHT'
               LEFT OUTER JOIN BarWeight bmaxW ON bmaxW.EquipmentId = eq.ID
                                                  AND bmaxW.PropertyType = N'MAX_WEIGHT'
			LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID
                                                  AND bQty.PropertyType = N'BAR_QUANTITY';
GO 

SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesMonitorInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesMonitorInfo];
GO
/*
   View: v_ScalesMonitorInfo
    Возвращает данные из контроллера а также расчитывает количество прудков для весов.
	Используется на экране маркиорвщицы для показа данных на доп. мониторе.
*/
CREATE VIEW [dbo].[v_ScalesMonitorInfo]
AS
     WITH BarWeight
          AS (SELECT CAST(par.[Value] AS FLOAT) PropertyValue,
                     pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] IN(N'BAR_WEIGHT', N'BAR_QUANTITY')
              AND pr.ID = par.PropertyType
              AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
          AND ep.[Value] = par.JobOrder),
          Kep_Data
          AS (SELECT *
              FROM
              (
                  SELECT ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                         kl.[WEIGHT_CURRENT],
                         kl.[AUTO_MANU],
                         kl.[POCKET_LOC],
                         kl.[NUMBER_POCKET]
                  FROM dbo.KEP_logger kl
                  WHERE kl.[TIMESTAMP] >= DATEADD(hour, -1, GETDATE())
              ) ww
              WHERE ww.RowNumber = 1)
          SELECT eq.ID AS ID,
                 eq.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) WEIGHT_CURRENT,
                 kd.AUTO_MANU,
                 kd.POCKET_LOC,
                 CAST(FLOOR(dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) / bw.PropertyValue) AS   INT) RodsQuantity,
                 CAST(bQty.PropertyValue AS INT)		BAR_QUANTITY
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1
                                              AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID
                                               AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID
                                                  AND bQty.PropertyType = N'BAR_QUANTITY';
GO 

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_SegmentParameter_Order', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_SegmentParameter_Order];
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

IF OBJECT_ID ('dbo.v_WorkDefinitionPropertiesAll', N'V') IS NOT NULL
   DROP VIEW dbo.v_WorkDefinitionPropertiesAll;
GO
/*
   View: v_WorkDefinitionPropertiesAll
    Возвращает свойства WorkDefinition.
*/
CREATE VIEW [dbo].[v_WorkDefinitionPropertiesAll]
AS
SELECT ps.[ID],
       pt.[Description],
       ps.[Value],
       pso.[Value] comm_order,
       es.[EquipmentID],
       ps.[WorkDefinitionID],
       pt.[Value] Property
FROM [dbo].[ParameterSpecification] ps
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
     INNER JOIN [dbo].[v_ParameterSpecification_Order] pso ON (pso.WorkDefinitionID=ps.[WorkDefinitionID])
     INNER JOIN [dbo].[OpEquipmentSpecification] es ON (es.[WorkDefinition]=ps.[WorkDefinitionID])
UNION ALL
SELECT sp.ID,
       pt.Description,
       sp.[Value],
       spo.[Value] comm_order,
       eq.[ID] [EquipmentID],
       NULL,
       pt.[Value] Property
FROM dbo.OpSegmentRequirement sr
     INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
     INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
     INNER JOIN [dbo].[v_SegmentParameter_Order] spo ON (spo.OpSegmentRequirement=sp.OpSegmentRequirement)
     CROSS JOIN [dbo].[Equipment] eq
WHERE NOT EXISTS (SELECT NULL 
                  FROM [dbo].[v_ParameterSpecification_Order] pso 
                  WHERE (pso.[Value]=spo.[Value])
                    AND (pso.[EquipmentID]=eq.[ID]));
GO