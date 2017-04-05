IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_DocumentationsClass')
BEGIN
CREATE SEQUENCE [dbo].[gen_DocumentationsClass] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
 
 
 ALTER TABLE [dbo].[DocumentationsClass] 
 ADD CONSTRAINT DEF_ID_DocumentationsClass  DEFAULT (NEXT VALUE FOR [dbo].[gen_DocumentationsClass]) FOR [ID]

END



