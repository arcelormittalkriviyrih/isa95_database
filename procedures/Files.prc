--------------------------------------------------------------
IF OBJECT_ID ('dbo.gen_Files',N'SO') IS NULL
   CREATE SEQUENCE dbo.gen_Files AS INT START WITH 1 INCREMENT BY 1 NO CACHE;
GO

--------------------------------------------------------------
-- Процедура вставки в таблицу Files
IF OBJECT_ID ('dbo.ins_Files',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_Files;
GO

CREATE PROCEDURE dbo.ins_Files
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

--------------------------------------------------------------
-- Процедура редактирования таблицы Files
IF OBJECT_ID ('dbo.upd_Files',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_Files;
GO

CREATE PROCEDURE dbo.upd_Files
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

--------------------------------------------------------------
-- Процедура удаления из таблицы Files
IF OBJECT_ID ('dbo.del_Files',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_Files;
GO

CREATE PROCEDURE dbo.del_Files
   @ID INT
AS
BEGIN

  DELETE FROM dbo.Files
  WHERE ID=@ID;

END;
GO

--------------------------------------------------------------
-- Процедура вычитки из таблицы Files
IF OBJECT_ID ('dbo.get_Files', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_Files;
GO

CREATE FUNCTION dbo.get_Files(@ID INT)
RETURNS @retFiles TABLE (ID         INT,
                         FileName   NVARCHAR(255),
                         Encoding   NVARCHAR(255),
                         FileType   NVARCHAR(50),
                         Data       [varbinary](MAX))
AS
BEGIN

  INSERT @retFiles
  SELECT ID,
         FileName,
         Encoding,
         FileType,
         Data
  FROM dbo.Files
  WHERE ID=@ID;

  RETURN;

END;
GO
