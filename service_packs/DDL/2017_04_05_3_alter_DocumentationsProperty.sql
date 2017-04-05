IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_DocumentationsProperty')
BEGIN
CREATE SEQUENCE [dbo].[gen_DocumentationsProperty] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
 
 
 ALTER TABLE [dbo].[DocumentationsProperty] 
 ADD CONSTRAINT DEF_ID_DocumentationsProperty DEFAULT (NEXT VALUE FOR [dbo].[gen_DocumentationsProperty]) FOR [ID]
END




IF COLUMNPROPERTY(OBJECT_ID('DocumentationsProperty','U'),'DocumentationsDefinitionPropertyID','ColumnId') IS NOT NULL
BEGIN
   ALTER TABLE [dbo].DocumentationsProperty
   DROP CONSTRAINT [FK_DocumentationsProperty_DocumentationsDefinitionProperty]

   ALTER TABLE [dbo].DocumentationsProperty
   DROP COLUMN  [DocumentationsDefinitionPropertyID] 
END



IF COLUMNPROPERTY(OBJECT_ID('DocumentationsProperty','U'),'ValueTime','ColumnId') IS NULL
ALTER TABLE [dbo].DocumentationsProperty
add  [ValueTime] [datetimeoffset](7) NULL