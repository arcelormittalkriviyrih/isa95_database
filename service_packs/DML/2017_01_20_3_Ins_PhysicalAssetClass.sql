SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Author: Timur Kapalov
Description: Создание новый классов датчиков давления
*/

INSERT INTO [dbo].[PhysicalAssetClass]
	([Description]
	,[Manufacturer]
	,[ParentID])
VALUES
(N'Sitrans P220',N'Siemens',10002),
(N'Sitrans P250',N'Siemens',10002),
(N'STD110',N'Honeywell',10019),
(N'STD120',N'Honeywell',10019),
(N'STD720',N'Honeywell',10019),
(N'STD810',N'Honeywell',10019),
(N'STD924',N'Honeywell',10019),
(N'STG 14L',N'Honeywell',10019),
(N'STG 74L',N'Honeywell',10019),
(N'STX2100',N'Honeywell',10019),
(N'АИР 10/М1ДА',N'Элемер',10005),
(N'АИР 10/М1',N'Элемер',10002),
(N'АИР 20/М2',N'Элемер',10002),
(N'Метран 100',N'Метран',10002),
(N'Метран 22',N'Метран',10002),
(N'Метран 45',N'Метран',10002),
(N'Метран 55',N'Метран',10002),
(N'Метран 100',N'Метран',10019),
(N'Метран 22',N'Метран',10019),
(N'Метран 55',N'Метран',10019)


GO
