   IF COLUMNPROPERTY(OBJECT_ID('PackagingUnitsProperty','U'),'PackagingDefinitionPropertyID','ColumnId') IS NOT NULL  
   BEGIN  
  	  ALTER TABLE [dbo].[PackagingUnitsProperty]  
  	  DROP COLUMN PackagingDefinitionPropertyID
   END  