SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_ScrapTypes',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_ScrapTypes;
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_KP4_ScrapTypes]
AS

select distinct
	scrap_type.ID,
	scrap_type.[Description],
	scrap_class.ID as ScrapClassID,
	scrap_class.[Description] as ScrapClass
from 
	dbo.MaterialDefinition scrap_type,
	dbo.MaterialDefinition scrap_class,
	dbo.MaterialClass AS MC
where 
		scrap_type.MaterialDefinitionID = scrap_class.ID
	and scrap_class.MaterialClassID = MC.ID
	and MC.Code = N'Scrap'


GO