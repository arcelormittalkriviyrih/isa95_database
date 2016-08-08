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