SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

INSERT INTO [dbo].[PhysicalAsset]  (ID,[Description])
VALUES (0,N'Root')

  ALTER SEQUENCE gen_PhysicalAsset
    RESTART WITH 10121


INSERT INTO [dbo].[PhysicalAsset]  ([Description], [EquipmentLevel] ,[PhysicalAsset] ,[PhysicalAssetClassID])
SELECT N'LafetScrapBox '+[Description], N'Storage Unit', 0,543
FROM [dbo].[PackagingUnits]
WHERE id>0
ORDER BY id



INSERT INTO [dbo].[PhysicalAssetProperty]     ([Description], [Value], [PhysicalAssetID])
SELECT  N'Weight tara. '+pp.descr,  pp.value , pa.ID
FROM  [dbo].[PhysicalAsset]  pa
         left join
             (select  'LafetScrapBox '+pu.[Description] descr, pup.value  
           FROM  [PackagingUnits] pu left join   [dbo].[PackagingUnitsProperty] pup  on pu.id=pup.PackagingUnitsID
          WHERE pup.PackagingDefinitionPropertyID=2 and pu.ID>0
               ) pp  on pa.[Description]=pp.descr
WHERE [Description] like 'LafetScrapBox%'


INSERT INTO [dbo].[PhysicalAssetProperty]     ([Description], [Value], [PhysicalAssetID])
SELECT  N'Weighing time. '+pp.descr,  pp.value , pa.ID
FROM  [dbo].[PhysicalAsset]  pa
         left join
             (select  'LafetScrapBox '+pu.[Description] descr, pup.value  
           FROM  [PackagingUnits] pu left join   [dbo].[PackagingUnitsProperty] pup  on pu.id=pup.PackagingUnitsID
          WHERE pup.PackagingDefinitionPropertyID=3 and pu.ID>0
               ) pp  on pa.[Description]=pp.descr
WHERE [Description] like 'LafetScrapBox%'

GO

