SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PACKS_LEFT',N'Сколько осталось напечатать пачек');

COMMIT;
GO
