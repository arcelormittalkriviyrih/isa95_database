SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_PersonProperty_remote_print', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_PersonProperty_remote_print];
GO
/*
   View: v_PersonProperty_PersonProperty_remote_print
   Просмотр свойства текущего пользователя котрое разрешает удалённую печать
*/
CREATE VIEW [dbo].[v_PersonProperty_remote_print]
AS
SELECT TOP 1 pp.[ID], pp.[Value], pp.[Description], pp.[PersonID], pp.[ClassPropertyID]
FROM [dbo].[PersonProperty] pp
     INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'REMOTE_PRINT')
WHERE pp.[PersonID] = dbo.get_CurrentPerson()	
GO


