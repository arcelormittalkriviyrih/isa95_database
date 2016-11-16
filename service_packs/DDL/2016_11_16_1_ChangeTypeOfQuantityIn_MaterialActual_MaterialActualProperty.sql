
IF OBJECT_ID ('MaterialActual') IS NOT NULL
	-- change data type from INT to REAL
	ALTER TABLE dbo.MaterialActual ALTER COLUMN Quantity real
GO

IF OBJECT_ID ('MaterialActualProperty') IS NOT NULL
	-- change data type from INT to REAL
	ALTER TABLE dbo.MaterialActualProperty ALTER COLUMN Quantity real
GO
