
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [KRR-PA-ISA95_PRODUCTION]

  insert into [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment]
  ( [id], [Description]  ,[EquipmentLevel]      ,[Equipment]           ,[EquipmentClassID])
  values
   (367, N'Горный департамент' , N'Site' , 100 , 21)
  ,(368, N'КХП' , N'Site' , 100 , 20)
 
GO

    insert into [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment]
  (   [Description]  ,[EquipmentLevel]      ,[Equipment]           ,[EquipmentClassID])
  values
   (N'ТЕЦ-1' , N'Area' , 350 , 9)
  ,(N'ТЕЦ-2' , N'Area' , 350 , 9)
  ,(N'ТЕЦ-3' , N'Area' , 350 , 9)
  ,(N'ТЕЦ-3' , N'Area' , 350 , 9)
  ,(N'Коксовый цех' , N'Area' , 368 , 9)
  ,(N'Сортировка' , N'Area' , 368 , 9)
  ,(N'Углеподготовка' , N'Area' , 368 , 9)
  ,(N'РОФ-1' , N'Area' , 367 , 9)
  ,(N'РОФ-2' , N'Area' , 367 , 9)
  ,(N'ДФ-1' , N'Area' , 367 , 9)
  ,(N'ДФ-2' , N'Area' , 367 , 9)
  ,(N'Агломашина 1 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Агломашина 2 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Агломашина 3 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Агломашина 4 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Агломашина 5 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Агломашина 6 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ1 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ2 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ3 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ4 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ5 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Эксгаустер АМ6 АЦ-1' , N'Production Unit' , 105 , 11)
  ,(N'Конвейер ПС1-1 АЦ-1' , N'Unit' , 105 , 11)
  ,(N'Конвейер ПС1-2 АЦ-1' , N'Unit' , 105 , 11)
  ,(N'Конвейер ПС1-3 АЦ-1' , N'Unit' , 105 , 11)
  ,(N'Конвейер ПС1-4 АЦ-1' , N'Unit' , 105 , 11)
  ,(N'Агломашина 1 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Агломашина 2 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Агломашина 3 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Агломашина 4 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Агломашина 5 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Агломашина 6 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ1 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ2 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ3 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ4 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ5 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Эксгаустер АМ6 АЦ-2' , N'Production Unit' , 106 , 11)
  ,(N'Конвейер ПС2-1 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Конвейер ПС2-2 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Конвейер ПС2-3 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Конвейер ПС2-4 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Конвейер КП-1 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Конвейер КП-2 АЦ-2' , N'Unit' , 106 , 11)
  ,(N'Агломашина 1 АЦМП' , N'Production Unit' , 110 , 11)
  ,(N'Агломашина 2 АЦМП' , N'Production Unit' , 110 , 11)
  ,(N'Агломашина 3 АЦМП' , N'Production Unit' , 110 , 11)
  ,(N'Агломашина 4 АЦМП' , N'Production Unit' , 110 , 11)
  ,(N'Агломашина 5 АЦМП' , N'Production Unit' , 110 , 11)
  ,(N'Конвейер Ш15 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер Ш16 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер Ш17 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер Ш18 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер ОИ-1 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер ОИ-3 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер ОИ-4 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер ПБ-1 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Конвейер ПБ-2 АЦ-3' , N'Unit' , 107 , 11)
  ,(N'Дымосос конвертора 1' , N'Production Unit' , 134 , 11)
  ,(N'Дымосос конвертора 2' , N'Production Unit' , 134 , 11)
  ,(N'Дымосос конвертора 3' , N'Production Unit' , 134 , 11)
  ,(N'Дымосос конвертора 4' , N'Production Unit' , 135 , 11)
  ,(N'Дымосос конвертора 5' , N'Production Unit' , 135 , 11)
  ,(N'Дымосос конвертора 6' , N'Production Unit' , 135 , 11)

GO