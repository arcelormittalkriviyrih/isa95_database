--------------------------------------------------------------
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.get_GlobalOption', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_GlobalOption;
GO
/*
   Function: get_GlobalOption

   Функция возвращает значение глобальной опции
      
   Parameters:

       OptionCode- код опции.
     
   Returns:
	  
	  значение опции.

*/
CREATE FUNCTION dbo.get_GlobalOption(@OptionCode [nvarchar](50))
RETURNS nvarchar(255)
AS
BEGIN

DECLARE @OptionValue nvarchar(255);

SELECT @OptionValue=o.OptionValue
FROM dbo.GlobalOptions o
WHERE o.OptionCode=@OptionCode;

RETURN @OptionValue;

END;
GO