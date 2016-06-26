SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

delete from ProductionParameter where PropertyType='1';
delete from PropertyTypes where [Value] is NULL;
update PropertyTypes set [Description]=N'Отпуск' where [Value]=N'LEAVE_NO';
update PropertyTypes set [Description]=N'Смена' where [Value]=N'CHANGE_NO';