
/*add new properties for transport*/
insert into [dbo].[PackagingClassProperty]
	([Description]
	,[Value]
	,[ValueUnitofMeasure]
	,[PackagingClassID])
select
	 R.[Description]
	,isnull(R.[Value], K.[Value])	as [Value]
	,R.[ValueUnitofMeasure]
	,PC.[ID]						as [PackagingClassID]
from (values	
	 (N'Вагон УЗ')
	,(N'Вагон местный')
	,(N'Автомобиль')
	,(N'Полувагон УЗ')
) as T([Description])
cross join (values
	 (N'Wagon number template', cast(null as nvarchar(500)), null)
	,(N'Грузоподъемность', '70', N'ton')
	,(N'Тара', '50', N'ton')
) as R([Description], [Value], [ValueUnitofMeasure])
left join (values	
	 (N'Вагон УЗ', N'^[2-9]{1}[0-9]{7}$')
	,(N'Вагон местный', N'^[0-9]{3,8}$')
	,(N'Автомобиль', N'^[A-zА-я]{0,3}[0-9]{1,6}(\-[0-9]{1,3})?[A-zА-я]{0,3}\-?[0-9]{0,3}$')
) as K([Description], [Value])
on T.[Description] = K.[Description] and R.[Description] = N'Wagon number template'
join [dbo].[PackagingClass] PC
on T.[Description] = PC.[Description]
left join [dbo].[PackagingClassProperty] PUP
on PUP.[PackagingClassID] = PC.[ID]
where PUP.[ID] is null


GO