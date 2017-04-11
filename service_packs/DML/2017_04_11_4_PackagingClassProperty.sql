
INSERT INTO [dbo].[PackagingClassProperty]
           ([Description],[Value], PackagingClassProperty, [PackagingClassID])
SELECT  N'Wagon number template',
      case 
	  when [Description]=N'лафет-короб' then N'XXX-XXX'
	  when [Description]=N'полувагон' then N'XXXXX'
	  when [Description]=N'спецвагон' then N'XXXXXXXX'
	  when [Description]=N'цистерна' then N'XXXXXXXX'
	  end
      , 1,[ID]
  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[PackagingClass] where Description not like N'%ж\д вагоны%'


