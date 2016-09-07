--------------------------------------------------------------
/*
Заполнение таблиц PackagingClassProperty, PackagingDefinitionProperty
PackagingUnits, PackagingUnitsProperty
данными 
по проекту Копр4
*/

INSERT INTO [dbo].[PackagingClassProperty]
           ([ID]
           ,[Description]
           ,[Value]
           ,[ValueUnitofMeasure]
           ,[PropertyType]
           ,[PackagingClassProperty]
           ,[PackagingClassID])
     VALUES
	 (1, N'Тара', null, null, null, 1,1 )




INSERT INTO [dbo].[PackagingDefinitionProperty]
           ([ID]
           ,[Description]
           ,[Value]
           ,[ValueUnitofMeasure]
           ,[PropertyType]
           ,[PackagingClassPropertyID]
           ,[PackagingDefinitionProperty]
           ,[PackagingDefinitionID])

     VALUES
	 (1,  N'Лом',  null, null, null, 1, 1, 1),
	 (2,  N'Вес тары',  null, 't', null, 1, 1, 1),
	 (3,  N'Время тарирования',  null, 'dd.mm.yyyy hh:mm:ss', null, 1, 1, 1)
         

 INSERT INTO [dbo].[PackagingUnits]
           ([ID]           ,[Description]        ,[PackagingDefinitionID]           ,[Location])
   VALUES (0,'Root', 1,1)



INSERT INTO [dbo].[PackagingUnitsProperty]
           ([ID]
           ,[Description]
           ,[PackagingDefinitionPropertyID]
           ,[PackagingUnitsProperty]
           ,[PackagingUnitsID])
VALUES(  0, 'Root', 1, 0, 0)

