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