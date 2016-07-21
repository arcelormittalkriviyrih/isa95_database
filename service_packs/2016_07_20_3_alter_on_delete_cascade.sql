
ALTER TABLE [dbo].[EquipmentProperty]  DROP CONSTRAINT [FK_EquipmentProperty_Equipment]
GO

ALTER TABLE [dbo].[EquipmentProperty]  WITH CHECK ADD  CONSTRAINT [FK_EquipmentProperty_Equipment] FOREIGN KEY([EquipmentID])
REFERENCES [dbo].[Equipment] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[MaterialDefinitionProperty] DROP CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinition]
GO

ALTER TABLE [dbo].[MaterialDefinitionProperty]  WITH CHECK ADD  CONSTRAINT [FK_MaterialDefinitionProperty_MaterialDefinition] FOREIGN KEY([MaterialDefinitionID])
REFERENCES [dbo].[MaterialDefinition] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[PersonProperty] DROP CONSTRAINT [FK_PersonProperty_Person]
GO

ALTER TABLE [dbo].[PersonProperty]  WITH CHECK ADD  CONSTRAINT [FK_PersonProperty_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([ID]) ON DELETE CASCADE
GO