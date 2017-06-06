/*drop column [Weight]*/
IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'Weight','ColumnId') IS NOT NULL  
BEGIN  
  ALTER TABLE [dbo].[WeightingOperations]  
  DROP COLUMN Weight
END  

/*add columns [Brutto], [Tara], [Netto], [OperationType]*/
IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'Brutto','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[WeightingOperations]
	ADD [Brutto] [real] NULL
END

IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'Tara','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[WeightingOperations]
	ADD [Tara] [real] NULL
END

IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'Netto','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[WeightingOperations]
	ADD [Netto] [real] NULL
END

IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'OperationType','ColumnId') IS NULL
BEGIN
   ALTER TABLE [dbo].[WeightingOperations]
	ADD [OperationType] [nvarchar](50) NULL
END


/*add column [MaterialDefinitionID] with FK*/
IF COLUMNPROPERTY(OBJECT_ID('WeightingOperations','U'),'MaterialDefinitionID','ColumnId') IS NULL
BEGIN
	ALTER TABLE [dbo].[WeightingOperations]
	ADD [MaterialDefinitionID] [int] NULL
	
	ALTER TABLE [dbo].[WeightingOperations]  WITH CHECK 
	ADD CONSTRAINT [FK_WeightingOperations_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
	REFERENCES [dbo].[MaterialDefinition] ([ID])
	
	ALTER TABLE [dbo].[WeightingOperations] CHECK CONSTRAINT [FK_WeightingOperations_MaterialDefinition];
END

GO
