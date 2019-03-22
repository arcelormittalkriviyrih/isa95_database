SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_PersonProperty_view_only', 'V') IS NOT NULL
   DROP VIEW [dbo].[v_PersonProperty_view_only];
GO
/*
    View: v_PersonProperty_view_only
    Просмотр свойства текущего пользователя котрое разрешает только просмотр отвесных и путевых
*/
CREATE VIEW [dbo].[v_PersonProperty_view_only]
AS
SELECT TOP 1 pp.[ID], pp.[Value], pp.[Description], pp.[PersonID], pp.[ClassPropertyID]
FROM [dbo].[PersonProperty] pp
     INNER JOIN [dbo].[PersonnelClassProperty] pcp ON (pcp.[ID]=pp.[ClassPropertyID] AND pcp.[Value]=N'VIEW_ONLY')
WHERE pp.[PersonID] = dbo.get_CurrentPerson()	
GO


