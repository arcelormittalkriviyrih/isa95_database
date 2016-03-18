--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_Property',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_Property AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_ClassDefinitionProperty',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_ClassDefinitionProperty AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу PropertyTypes
IF OBJECT_ID ('dbo.ins_PropertyTypes',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_PropertyTypes;
GO

CREATE PROCEDURE dbo.ins_PropertyTypes
   @Description                          NVARCHAR(50),
   @PropertyTypesID             INT OUTPUT
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

--------------------------------------------------------------
-- Процедура редактирования таблицы PropertyTypes
IF OBJECT_ID ('dbo.upd_PropertyTypes',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_PropertyTypes;
GO

CREATE PROCEDURE dbo.upd_PropertyTypes
   @ID          INT,
   @Description NVARCHAR(50)
AS
BEGIN

  UPDATE dbo.PropertyTypes
  SET Description=@Description
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура удаления из таблицы PropertyTypes
IF OBJECT_ID ('dbo.del_PropertyTypes',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_PropertyTypes;
GO

CREATE PROCEDURE dbo.del_PropertyTypes
   @ID INT
AS
BEGIN

  DELETE FROM dbo.PropertyTypes
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы PropertyTypes
IF OBJECT_ID ('dbo.get_PropertyTypes', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_PropertyTypes;
GO

CREATE FUNCTION dbo.get_PropertyTypes(@ID INT)
RETURNS @retPropertyTypes TABLE (ID          INT,
                                 Description NVARCHAR(50))
AS
BEGIN

  INSERT @retPropertyTypes
  SELECT ID,
         Description
  FROM dbo.PropertyTypes
  WHERE ID=@ID;

  RETURN;

END;
GO
