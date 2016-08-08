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
