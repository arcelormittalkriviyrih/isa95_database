
   IF COLUMNPROPERTY(OBJECT_ID('PackagingUnitsProperty','U'),'ValueTime','ColumnId') IS  NULL  
   BEGIN  
  	  ALTER TABLE [dbo].[PackagingUnitsProperty]  
  	  add [ValueTime] [datetime] NULL
   END  