

IF OBJECT_ID ('dbo.v_AcceptanceMaterial', N'V') IS NOT NULL
   DROP VIEW dbo.v_AcceptanceMaterial;
GO


CREATE VIEW [dbo].[v_AcceptanceMaterial]
AS
SELECT     dbo.MaterialLot.ID, dbo.MaterialLot.FactoryNumber, dbo.MaterialDefinition.Description, dbo.MaterialLot.Status, dbo.MaterialLot.Location
FROM         dbo.MaterialDefinition INNER JOIN
                      dbo.MaterialLot ON dbo.MaterialDefinition.ID = dbo.MaterialLot.MaterialDefinitionID
GO