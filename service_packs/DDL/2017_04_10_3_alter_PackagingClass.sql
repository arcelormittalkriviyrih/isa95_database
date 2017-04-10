IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_PackagingClass')
BEGIN
CREATE SEQUENCE [dbo].[gen_PackagingClass] 
 AS [int]
 START WITH 2
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
 
 
 ALTER TABLE [dbo].PackagingClass 
 ADD CONSTRAINT DEF_ID_PackagingClass  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingClass]) FOR [ID]

END