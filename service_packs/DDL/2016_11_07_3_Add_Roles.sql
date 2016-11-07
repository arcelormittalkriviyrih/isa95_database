USE [KRR-PA-ISA95_PRODUCTION]
GO

IF SUSER_ID('EUROPE\dsguk') IS NULL
begin
                CREATE USER [EUROPE\dsguk] FOR LOGIN [EUROPE\dsguk]
                GO
end
GO

ALTER ROLE [db_denydatareader] ADD MEMBER [EUROPE\dsguk]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [EUROPE\dsguk]
GO
ALTER ROLE [db_ExecuteProcerures] ADD MEMBER [EUROPE\dsguk]
GO


IF SUSER_ID('EUROPE\lgnaumenko') IS NULL
begin
                CREATE USER [EUROPE\lgnaumenko] FOR LOGIN [EUROPE\lgnaumenko]
                GO
end
GO

ALTER ROLE  [db_datawriter] ADD MEMBER [EUROPE\lgnaumenko]
GO
ALTER ROLE  [db_datareader]  ADD MEMBER [EUROPE\lgnaumenko]
GO
ALTER ROLE  [db_ExecuteProcerures] ADD MEMBER [EUROPE\lgnaumenko]
GO


IF SUSER_ID('EUROPE\tvkolomits') IS NULL
begin
                CREATE USER [EUROPE\tvkolomits] FOR LOGIN [EUROPE\tvkolomits]
                GO
end
GO

ALTER ROLE  [db_datawriter] ADD MEMBER [EUROPE\tvkolomits]
GO
ALTER ROLE  [db_datareader]  ADD MEMBER [EUROPE\tvkolomits]
GO
ALTER ROLE  [db_ExecuteProcerures] ADD MEMBER [EUROPE\tvkolomits]
GO


IF SUSER_ID('EUROPE\ovsaenko') IS NULL
begin
                CREATE USER [EUROPE\ovsaenko] FOR LOGIN [EUROPE\ovsaenko]
                GO
end
GO

ALTER ROLE  [db_datawriter] ADD MEMBER [EUROPE\ovsaenko]
GO
ALTER ROLE  [db_datareader]  ADD MEMBER [EUROPE\ovsaenko]
GO
ALTER ROLE  [db_ExecuteProcerures] ADD MEMBER [EUROPE\ovsaenko]
GO


IF SUSER_ID('EUROPE\aachumak') IS NULL
begin
                CREATE USER [EUROPE\aachumak] FOR LOGIN [EUROPE\aachumak]
                GO
end
GO

ALTER ROLE  [db_datawriter] ADD MEMBER [EUROPE\aachumak]
GO
ALTER ROLE  [db_datareader]  ADD MEMBER [EUROPE\aachumak]
GO
ALTER ROLE  [db_ExecuteProcerures] ADD MEMBER [EUROPE\aachumak]
GO


IF SUSER_ID('EUROPE\maromanov') IS NULL
begin
                CREATE USER [EUROPE\maromanov] FOR LOGIN [EUROPE\maromanov]
                GO
end
GO

ALTER ROLE  [db_datawriter] ADD MEMBER [EUROPE\maromanov]
GO
ALTER ROLE  [db_datareader]  ADD MEMBER [EUROPE\maromanov]
GO
ALTER ROLE  [db_ExecuteProcerures] ADD MEMBER [EUROPE\maromanov]
GO

