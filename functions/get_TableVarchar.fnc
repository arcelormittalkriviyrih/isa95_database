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