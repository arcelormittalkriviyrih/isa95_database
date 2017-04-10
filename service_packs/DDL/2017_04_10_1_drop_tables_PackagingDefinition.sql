
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnits_PackagingDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnits]'))
ALTER TABLE [dbo].[PackagingUnits] 
DROP CONSTRAINT [FK_PackagingUnits_PackagingDefinition] 


IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PackagingUnitsProperty_PackagingDefinitionProperty]') AND parent_object_id = OBJECT_ID(N'[dbo].[PackagingUnitsProperty]'))
ALTER TABLE [dbo].[PackagingUnitsProperty] 
DROP CONSTRAINT [FK_PackagingUnitsProperty_PackagingDefinitionProperty] 

IF COLUMNPROPERTY(OBJECT_ID('PackagingUnitsProperty','U'),'PackagingDefinitionPropertyID','ColumnId') IS NOT NULL
BEGIN
	ALTER TABLE [dbo].[PackagingUnitsProperty]
	DROP COLUMN PackagingDefinitionPropertyID
END


IF OBJECT_ID ('dbo.PackagingDefinitionAssemblies',N'U') IS NOT NULL
  DROP TABLE [dbo].PackagingDefinitionAssemblies;


IF OBJECT_ID ('dbo.PackagingDefinitionProperty',N'U') IS NOT NULL
  DROP TABLE [dbo].PackagingDefinitionProperty;
  
  

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OpPackagingActual_PackagingDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[OpPackagingActual]'))
ALTER TABLE [dbo].OpPackagingActual 
DROP CONSTRAINT [FK_OpPackagingActual_PackagingDefinition] 

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OpPackagingCapability_PackagingDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[OpPackagingCapability]'))
ALTER TABLE [dbo].OpPackagingCapability 
DROP CONSTRAINT FK_OpPackagingCapability_PackagingDefinition 

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OpPackagingRequirement_PackagingDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[OpPackagingRequirement]'))
ALTER TABLE [dbo].OpPackagingRequirement 
DROP CONSTRAINT FK_OpPackagingRequirement_PackagingDefinition 

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OpPackagingSpecification_PackagingDefinition]') AND parent_object_id = OBJECT_ID(N'[dbo].[OpPackagingSpecification]'))
ALTER TABLE [dbo].OpPackagingSpecification 
DROP CONSTRAINT FK_OpPackagingSpecification_PackagingDefinition 



IF OBJECT_ID ('dbo.PackagingDefinition',N'U') IS NOT NULL
  DROP TABLE [dbo].PackagingDefinition;
  