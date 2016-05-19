ALTER TABLE [dbo].[Files] ADD [Status] nVARCHAR(250) NULL;
go
update [dbo].[Files] set [Status]='Разработка';
go
alter TABLE [dbo].[Files] ALTER COLUMN [Status] nVARCHAR(250) not NULL;
go
ALTER TABLE [dbo].[Files] ADD [Name] nVARCHAR(250) NULL;
go
update [dbo].[Files] set [Name]=[FileName];
go
alter TABLE [dbo].[Files] ALTER COLUMN [Name] nVARCHAR(250) not NULL;
go
CREATE UNIQUE NONCLUSTERED INDEX [u_Name] ON [dbo].[Files]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

