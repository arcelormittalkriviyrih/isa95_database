
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_WeightingOperationsProperty')
BEGIN
CREATE SEQUENCE [dbo].[gen_WeightingOperationsProperty] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE 
END


IF OBJECT_ID ('dbo.WeightingOperationsProperty',N'U') IS NOT NULL
  DROP TABLE [dbo].[WeightingOperationsProperty];
GO

/*
   Table: WeightingOperationsProperty
    Свойства опреаций взвешивания
*/
CREATE TABLE [dbo].[WeightingOperationsProperty](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Value] [nvarchar](50) NULL,
	[ValueUnitofMeasure] [nvarchar](50) NULL,
	[PropertyType] [nvarchar](50) NULL,
	[WeightingOperationsID] [int] NOT NULL,
	[ValueTime] [datetimeoffset](7) NULL,
CONSTRAINT [PK_WeightingOperationsProperty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WeightingOperationsProperty] ADD CONSTRAINT [DEF_ID_WeightingOperationsProperty] DEFAULT (NEXT VALUE FOR [dbo].[gen_WeightingOperationsProperty]) FOR [ID]
GO

ALTER TABLE [dbo].[WeightingOperationsProperty] WITH CHECK ADD CONSTRAINT [FK_WeightingOperationsProperty_WeightingOperations] FOREIGN KEY([WeightingOperationsID])
REFERENCES [dbo].[WeightingOperations] ([ID])
GO

ALTER TABLE [dbo].[WeightingOperationsProperty] CHECK CONSTRAINT [FK_WeightingOperationsProperty_WeightingOperations]
GO