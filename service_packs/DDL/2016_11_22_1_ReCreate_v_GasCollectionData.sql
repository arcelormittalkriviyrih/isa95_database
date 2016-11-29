SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_GasCollectionData',N'V') IS NOT NULL
  DROP VIEW dbo.v_GasCollectionData;
GO

SET ANSI_PADDING OFF
GO

-- create view "v_GasCollectionData" for view data from web
CREATE VIEW dbo.v_GasCollectionData AS
SELECT newID() ID, sr.ActualStartTime as dtStart, sr.ActualEndTime as dtEnd, ma.Quantity as FE, map.Quantity as TE, mape.Quantity AS PE, mapq.Quantity as QE, sr.SegmentState as type,  e.ID as IDeq , e.Description
FROM dbo.SegmentResponse sr, dbo.EquipmentActual ea, dbo.Equipment e, dbo.MaterialActual ma
LEFT OUTER JOIN dbo.MaterialActualProperty map ON (ma.ID=map.MaterialActual AND map.Description='TE')
LEFT OUTER JOIN dbo.MaterialActualProperty mape ON (ma.ID=mape.MaterialActual AND mape.Description='PE') 
LEFT OUTER JOIN dbo.MaterialActualProperty mapq ON (ma.ID=mapq.MaterialActual AND mapq.Description='QE')
WHERE ma.SegmentResponseID=sr.ID AND ea.SegmentResponseID=sr.id AND ea.EquipmentID=e.ID
