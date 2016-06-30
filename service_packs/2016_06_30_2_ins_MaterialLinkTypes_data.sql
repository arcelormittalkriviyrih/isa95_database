BEGIN TRANSACTION;

INSERT INTO [dbo].[MaterialLinkTypes] ([ID],[Description]) VALUES (0,N'печать');

INSERT INTO [dbo].[MaterialLinkTypes] ([ID],[Description]) VALUES (1,N'перемаркировка');

INSERT INTO [dbo].[MaterialLinkTypes] ([ID],[Description]) VALUES (2,N'сортировка');

INSERT INTO [dbo].[MaterialLinkTypes] ([ID],[Description]) VALUES (3,N'отбраковка');

INSERT INTO [dbo].[MaterialLinkTypes] ([ID],[Description]) VALUES (4,N'разделение пачки');

COMMIT;
GO

