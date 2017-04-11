IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_PackagingClassProperty')
BEGIN
CREATE SEQUENCE [dbo].[gen_PackagingClassProperty] 
 AS [int]
 START WITH 2
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
 
 
 ALTER TABLE [dbo].PackagingClassProperty 
 ADD CONSTRAINT DEF_ID_PackagingClassProperty  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingClassProperty]) FOR [ID]

END
