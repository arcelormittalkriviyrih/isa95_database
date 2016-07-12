IF OBJECT_ID ('dbo.get_TableVarchar', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_TableVarchar;
GO

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

IF OBJECT_ID ('dbo.get_TableInteger', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_TableInteger;
GO

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

--------------------------------------------------------------
-- Процедура upd_MaterialLotProdOrder
IF OBJECT_ID ('dbo.upd_MaterialLotProdOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_MaterialLotProdOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_MaterialLotProdOrder]
@MaterialLotIDs   NVARCHAR(MAX),
@PROD_ORDER       NVARCHAR(50)
AS
BEGIN

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
   PRINT @MaterialLotID

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

   FETCH NEXT FROM selMaterialLots INTO @MaterialLotID;
END

CLOSE selMaterialLots;

DEALLOCATE selMaterialLots;

END;
GO
