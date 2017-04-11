
INSERT INTO [dbo].[PackagingClassProperty]
           ([Description],[Value], PackagingClassProperty, [PackagingClassID])
SELECT  N'Wagon number template',
      case 
	  when [Description]=N'Лафет-короб' then N'XXX-XXX'
	  when [Description]=N'Полувагон' then N'XXXXX'
	  when [Description]=N'Спецвагон' then N'XXXXXXXX'
	  when [Description]=N'Цистерна' then N'XXXXXXXX'
	  end
      , 1,[ID]
  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[PackagingClass] where Description not like N'%ЖД вагоны%'


