   IF COLUMNPROPERTY(OBJECT_ID('PackagingUnits','U'),'PackagingDefinitionID','ColumnId') IS NOT NULL  
   BEGIN  
  	  ALTER TABLE dbo.PackagingUnits  
  	  DROP COLUMN PackagingDefinitionID
   END