--- use DB as default one
USE [KRR-PA-ISA95_PRODUCTION]
GO

-- change data type from INT to REAL
ALTER TABLE [dbo].[MaterialActual] ALTER COLUMN Quantity real
GO

-- change data type from INT to REAL
ALTER TABLE [dbo].[MaterialActualProperty] ALTER COLUMN Quantity real
GO