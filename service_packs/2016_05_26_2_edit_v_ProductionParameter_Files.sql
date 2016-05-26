drop view [dbo].[v_ProductionParameter_Files];
GO

CREATE VIEW [dbo].[v_ProductionParameter_Files]
AS
SELECT newID() ID,
       ProductionParameter.ProductSegmentID,
       ProductionParameter.ProcessSegmentID,
       ProductionParameter.Parameter,
       ProductionParameter.PropertyType,
       Files.FileType,
       Files.Data,
       PropertyTypes.Value
FROM [dbo].[Files] Files
     INNER JOIN [dbo].[ProductionParameter] ProductionParameter ON (ProductionParameter.Parameter=Files.ID)
     INNER JOIN [dbo].[PropertyTypes] PropertyTypes ON (PropertyTypes.ID=ProductionParameter.PropertyType);

GO


