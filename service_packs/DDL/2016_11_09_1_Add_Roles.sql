USE [KRR-PA-ISA95_PRODUCTION]
GO


IF not exists (select * from sys.database_principals where name = 'EUROPE\lagnaumenko')
begin
	CREATE USER [EUROPE\lagnaumenko] FOR LOGIN [EUROPE\lagnaumenko]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\lagnaumenko]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\lagnaumenko]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\lagnaumenko]

GO



