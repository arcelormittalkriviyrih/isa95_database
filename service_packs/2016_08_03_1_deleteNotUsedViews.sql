IF OBJECT_ID ('dbo.v_ProductionResponse', 'V') IS NOT NULL
	DROP VIEW dbo.v_ProductionResponse;
GO

IF OBJECT_ID ('dbo.v_ProductionParameter_Files', 'V') IS NOT NULL
	DROP VIEW dbo.v_ProductionParameter_Files;
GO

IF OBJECT_ID ('dbo.v_Property', N'V') IS NOT NULL
   DROP VIEW dbo.v_Property;
GO

IF OBJECT_ID ('dbo.v_MaterialLot_Request', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLot_Request;
GO

