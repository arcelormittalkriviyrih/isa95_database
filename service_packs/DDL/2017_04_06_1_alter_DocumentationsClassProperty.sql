
IF COLUMNPROPERTY(OBJECT_ID('DocumentationsClassProperty','U'),'DocumentationsClassProperty','ColumnId') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[DocumentationsClassProperty]
	ALTER COLUMN [DocumentationsClassProperty] int NULL
END


IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_DocumentationsClassProperty')
BEGIN
CREATE SEQUENCE [dbo].[gen_DocumentationsClassProperty] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 

 
 ALTER TABLE [dbo].[DocumentationsClassProperty] 
 ADD CONSTRAINT DEF_ID_DocumentationsClassProperty  DEFAULT (NEXT VALUE FOR [dbo].[gen_DocumentationsClassProperty]) FOR [ID]

END