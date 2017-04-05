
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = N'gen_WeightingOperations')
BEGIN
CREATE SEQUENCE [dbo].[gen_WeightingOperations] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 NO CACHE  
END
GO


IF OBJECT_ID ('dbo.WeightingOperations',N'U') IS NOT NULL
  DROP TABLE [dbo].[WeightingOperations];
GO

/*
   Table: WeightingOperations
    Операции взвешивания для вагонов
*/

CREATE TABLE [dbo].[WeightingOperations](
	[ID] [int] NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Weight] [real] NULL,
	[OperationTime] [datetimeoffset](7) NULL,
	[Status] [nvarchar](50) NULL,
	[EquipmentID] [int] NULL,
	[PackagingUnitsDocsID] [int] NULL,
	[DocumentationsID] [int] NULL,
 CONSTRAINT [PK_WeightingOperations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[WeightingOperations] ADD  CONSTRAINT [DEF_ID_WeightingOperations]  DEFAULT (NEXT VALUE FOR [dbo].[gen_WeightingOperations]) FOR [ID]
GO

ALTER TABLE [dbo].[WeightingOperations]  WITH CHECK ADD  CONSTRAINT [FK_WeightingOperations_Documentations] FOREIGN KEY([DocumentationsID])
REFERENCES [dbo].[Documentations] ([ID])
GO

ALTER TABLE [dbo].[WeightingOperations] CHECK CONSTRAINT [FK_WeightingOperations_Documentations]
GO

ALTER TABLE [dbo].[WeightingOperations]  WITH CHECK ADD  CONSTRAINT [FK_WeightingOperations_PackagingUnitsDocs] FOREIGN KEY(PackagingUnitsDocsID)
REFERENCES [dbo].[PackagingUnitsDocs] ([ID])
GO

ALTER TABLE [dbo].[WeightingOperations] CHECK CONSTRAINT [FK_WeightingOperations_PackagingUnitsDocs]
GO

ALTER TABLE [dbo].[WeightingOperations]  WITH CHECK ADD  CONSTRAINT [FK_WeightingOperations_Equipment] FOREIGN KEY(EquipmentID)
REFERENCES [dbo].[Equipment] ([ID])
GO

ALTER TABLE [dbo].[WeightingOperations] CHECK CONSTRAINT [FK_WeightingOperations_Equipment]
GO

