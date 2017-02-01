IF (OBJECT_ID ('dbo.KEP_Analytics_Weight',N'U') IS NOT NULL and OBJECT_ID ('AMKR_WEIGHING.KEP_Analytics_Weight',N'U') IS NULL)
	ALTER SCHEMA AMKR_WEIGHING TRANSFER OBJECT::dbo.KEP_Analytics_Weight;  
go
IF (OBJECT_ID ('dbo.KEP_Analytics_Weight_archive',N'U') IS NOT NULL and OBJECT_ID ('AMKR_WEIGHING.KEP_Analytics_Weight_archive',N'U') IS NULL)
	ALTER SCHEMA AMKR_WEIGHING TRANSFER OBJECT::dbo.KEP_Analytics_Weight_archive; 
go
