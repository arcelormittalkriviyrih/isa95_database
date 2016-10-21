--------------------------------------------------------------
IF OBJECT_ID ('dbo.get_PropertyTypeIdByValue', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_PropertyTypeIdByValue];
GO
/*
   Function: get_PropertyTypeIdByValue

   Функция вычитки поля ID из таблицы PropertyTypes по значению поля Value

   Parameters:

      Value                       - Value свойства,

   Returns:

      ID свойства.

*/
CREATE FUNCTION [dbo].[get_PropertyTypeIdByValue](@Value [nvarchar](50)
                                                 )
RETURNS INT
AS
BEGIN

DECLARE @Id INT;

SELECT @Id=[ID]
FROM [dbo].[PropertyTypes] ep
WHERE ep.[Value]=@Value;

RETURN @Id;

END;
GO
