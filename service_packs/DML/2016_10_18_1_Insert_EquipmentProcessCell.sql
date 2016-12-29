SET NOCOUNT ON


INSERT INTO [dbo].[EquipmentClass]           ([Description]           ,[EquipmentLevel]           ,[ParentID]           ,[ID])
VALUES           ( N'Производственный участок', N'Process Cell', 9, 11)

---------------------

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (130, N'Миксерное отделение', N'Process Cell', 112, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (131, N'Миксерный блок 1', N'Process Cell', 130, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (132, N'Миксерный блок 2', N'Process Cell', 130, 11)
  

  
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (133, N'Конвертерное отделение', N'Process Cell', 112, 11)
  
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (134, N'Конвертерный блок 1', N'Process Cell', 133, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (135, N'Конвертерный блок 2', N'Process Cell', 134, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (136, N'Конвертер 1', N'Process Cell', 134, 11)
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (137, N'Конвертер 2', N'Process Cell', 134, 11)
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (138, N'Конвертер 3', N'Process Cell', 134, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (139, N'Конвертер 4', N'Process Cell', 135, 11)
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (140, N'Конвертер 5', N'Process Cell', 135, 11)
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (141, N'Конвертер 6', N'Process Cell', 135, 11)


  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (142, N'Разливочное отделение', N'Process Cell', 112, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (143, N'ОНРС', N'Process Cell', 112, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (144, N'УПК',  N'Process Cell', 143, 11)
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (145, N'МНЛЗ', N'Process Cell', 143, 11)


  
  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (146, N'Участок Копр.№1', N'Process Cell', 115, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (147, N'Участок Копр.№2', N'Process Cell', 115, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (148, N'Участок Копр.№4', N'Process Cell', 115, 11)

  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (149, N'Керамет Копр.№4', N'Process Cell', 148, 11)

 INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (150, N'Керамет Копр.№3', N'Process Cell', 115, 11)


  INSERT INTO [dbo].[Equipment] ([ID],[Description],[EquipmentLevel],[Equipment] ,[EquipmentClassID])
  VALUES (151, N'Двухванная печь', N'Process Cell', 113, 11)