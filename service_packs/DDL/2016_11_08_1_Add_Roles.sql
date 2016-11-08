USE [KRR-PA-ISA95_PRODUCTION]
GO

IF not exists (select * from sys.database_principals where name = 'EUROPE\dsguk')
begin
	CREATE USER [EUROPE\dsguk] FOR LOGIN [EUROPE\dsguk]
end


ALTER ROLE [db_datareader]			ADD MEMBER [EUROPE\dsguk]
ALTER ROLE [db_datawriter]			ADD MEMBER [EUROPE\dsguk]
ALTER ROLE [db_ExecuteProcerures]	ADD MEMBER [EUROPE\dsguk]


IF not exists (select * from sys.database_principals where name = 'EUROPE\lgnaumenko')
begin
	CREATE USER [EUROPE\lgnaumenko] FOR LOGIN [EUROPE\lgnaumenko]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\lgnaumenko]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\lgnaumenko]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\lgnaumenko]


IF not exists (select * from sys.database_principals where name = 'EUROPE\tvkolomits')
begin
	CREATE USER [EUROPE\tvkolomits] FOR LOGIN [EUROPE\tvkolomits]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\tvkolomits]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\tvkolomits]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\tvkolomits]


IF not exists (select * from sys.database_principals where name = 'EUROPE\ovsaenko')
begin
	CREATE USER [EUROPE\ovsaenko] FOR LOGIN [EUROPE\ovsaenko]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\ovsaenko]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\ovsaenko]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\ovsaenko]


IF not exists (select * from sys.database_principals where name = 'EUROPE\aachumak')
begin
	CREATE USER [EUROPE\aachumak] FOR LOGIN [EUROPE\aachumak]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\aachumak]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\aachumak]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\aachumak]


IF not exists (select * from sys.database_principals where name = 'EUROPE\maromanov')
begin
	CREATE USER [EUROPE\maromanov] FOR LOGIN [EUROPE\maromanov]
end

ALTER ROLE  [db_datawriter]			ADD MEMBER [EUROPE\maromanov]
ALTER ROLE  [db_datareader]			ADD MEMBER [EUROPE\maromanov]
ALTER ROLE  [db_ExecuteProcerures]	ADD MEMBER [EUROPE\maromanov]

GO



