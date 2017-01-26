SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_PhysicalAssetTab',N'V') IS NOT NULL
  DROP VIEW dbo.v_PhysicalAssetTab;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_PhysicalAssetTab]
AS
SELECT        dbo.PhysicalAsset.ID, dbo.PhysicalAsset.Description, dbo.PhysicalAsset.FixedAssetID, dbo.PhysicalAsset.PhysicalAssetClassID AS PAClassID, 
                         dbo.PhysicalAsset.PhysicalAssetClassID
FROM            dbo.PhysicalAsset INNER JOIN
                         dbo.PhysicalAssetClass ON dbo.PhysicalAsset.PhysicalAssetClassID = dbo.PhysicalAssetClass.ID

GO



