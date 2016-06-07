-----------------------------------------------------------------
-- alter [dbo].[Parameter] table structure
ALTER TABLE [dbo].[Parameter] ADD [PropertyType] [int] NULL
GO

ALTER TABLE [dbo].[Parameter] WITH CHECK ADD CONSTRAINT [FK_Parameter_PropertyTypes] FOREIGN KEY(PropertyType) REFERENCES [dbo].[PropertyTypes] (ID)
GO

ALTER TABLE [dbo].[Parameter] CHECK CONSTRAINT [FK_Parameter_PropertyTypes]
GO
