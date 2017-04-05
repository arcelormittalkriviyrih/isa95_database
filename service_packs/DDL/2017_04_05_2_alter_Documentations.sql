
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_Documentations')
BEGIN
CREATE SEQUENCE [dbo].[gen_Documentations] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
 
 
 ALTER TABLE [dbo].[Documentations] 
 ADD CONSTRAINT DEF_ID_Documentations DEFAULT (NEXT VALUE FOR [dbo].[gen_Documentations]) FOR [ID]
END


IF COLUMNPROPERTY(OBJECT_ID('Documentations','U'),'DocumentationsClassID','ColumnId') IS NULL
ALTER TABLE [dbo].Documentations
ADD  DocumentationsClassID int NULL


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DocumentationsID_DocumentationsClass]') AND parent_object_id = OBJECT_ID(N'[dbo].[Documentations]'))
ALTER TABLE [dbo].[Documentations]  WITH CHECK ADD  CONSTRAINT [FK_DocumentationsID_DocumentationsClass] FOREIGN KEY([DocumentationsClassID])
REFERENCES [dbo].[DocumentationsClass] ([ID])

IF COLUMNPROPERTY(OBJECT_ID('Documentations','U'),'StartTime','ColumnId') IS NULL
ALTER TABLE [dbo].Documentations
ADD  [StartTime] [datetimeoffset](7) NULL


IF COLUMNPROPERTY(OBJECT_ID('Documentations','U'),'EndTime','ColumnId') IS NULL
ALTER TABLE [dbo].Documentations
ADD  [EndTime] [datetimeoffset](7) NULL


IF COLUMNPROPERTY(OBJECT_ID('Documentations','U'),'DocumentationsClassID','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].Documentations
   DROP CONSTRAINT [FK_Documentations_DocumentationsDefinition]

   ALTER TABLE [dbo].Documentations
   DROP COLUMN  DocumentationsDefinitionID 
END



