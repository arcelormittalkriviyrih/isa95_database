--- use DB as default one
USE [KRR-PA-CNT-GasForISA95]
GO

-- change data type from INT to REAL
ALTER TABLE [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialActual] ALTER COLUMN Quantity real
GO

-- change data type from INT to REAL
ALTER TABLE [KRR-PA-ISA95_PRODUCTION].[dbo].[MaterialActualProperty] ALTER COLUMN Quantity real
GO