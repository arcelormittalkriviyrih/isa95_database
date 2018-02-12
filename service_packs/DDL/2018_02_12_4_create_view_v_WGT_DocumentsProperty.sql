
IF OBJECT_ID ('dbo.v_WGT_DocumentsProperty',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_DocumentsProperty];
GO

/*
   View: v_WGT_DocumentsProperty
   Возвращает свойства документов (объед. св-ва отвесных и путевых)
*/

CREATE view [dbo].[v_WGT_DocumentsProperty]
as
select
	 isnull(T1.[ID], 0)		as [ID]
	,T1.[DocumentationsID]
	,T1.[Description]
	,T1.[Value]
	--,[DocumentationsID]
	,T1.[ValueTime]
	--,[DocumentationsClassPropertyID]
	,case T1.[Description]
		when N'Статус'												then N'Status'
		when N'Номер отвесной'										then N'WeightsheetNumber'
		when N'Номер путевой'										then N'WaybillNumber'
		when N'Весовщик'											then N'Weigher'
		when N'Приемосдатчик'										then N'Consigner'
		when N'Цех отправления'										then N'SenderShop'
		when N'Цех получения'										then N'ReceiverShop'
		when N'Место погрузки'										then N'SenderDistrict'
		when N'Место выгрузки'										then N'ReceiverDistrict'
		when N'Станция отправления'									then N'SenderRWStation'
		when N'Станция назначения'									then N'ReceiverRWStation'
		when N'Род вагона'											then N'WagonType'
		when N'Род груза'											then N'CargoType'
		when N'Время прибытия (станция отправления)'				then N'SenderArriveDT'
		when N'Время подачи под погрузку (станция отправления)'		then N'SenderStartLoadDT'
		when N'Время окончания выгрузки (станция отправления)'		then N'SenderEndLoadDT'
		when N'Время прибытия (станция назначения)'					then N'ReceiverArriveDT'
		when N'Время подачи под погрузку (станция назначения)'		then N'ReceiverStartLoadDT'
		when N'Время окончания выгрузки (станция назначения)'		then N'ReceiverEndLoadDT'
		when N'Весы'												then N'Weightbridge'
		when N'Вид документа'										then N'DocumentType'
		when N'Время создания'										then N'StartTime'
		when N'Время изменения'										then N'EndTime'
		else T1.[Description]
	 end				as [Description2]
	
	,case T1.[Description]
		when N'Статус'												then [Value]
		when N'Номер отвесной'										then [Value]
		when N'Номер путевой'										then [Value]
		when N'Весовщик'											then (select top 1 [PersonName] from [dbo].[Person]		where ID = Value)
		when N'Приемосдатчик'										then (select top 1 [PersonName] from [dbo].[PersonProperty] PP join [dbo].[Person] P on P.ID = PP.[PersonID] where LOWER(PP.[Value]) = LOWER(T1.Value))
		when N'Цех получения'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Цех отправления'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Место погрузки'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Место выгрузки'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Весы'												then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Вид документа'										then (select top 1 [Description] from [dbo].[DocumentationsClass] where ID = Value)
		when N'Станция отправления'									then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Станция назначения'									then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Род вагона'											then (select top 1 [Description] from [dbo].[PackagingClass] where ID = Value)
		when N'Род груза'											then (select top 1 [Description] from [dbo].[MaterialDefinition] where ID = Value)
		when N'Время прибытия (станция отправления)'				then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время подачи под погрузку (станция отправления)'		then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время окончания выгрузки (станция отправления)'		then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время прибытия (станция назначения)'					then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время подачи под погрузку (станция назначения)'		then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время окончания выгрузки (станция назначения)'		then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время создания'										then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'Время изменения'										then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
end				as [Value2]
from (
	select
		 [ID]
		,[Description]
		,[Value]
		,[DocumentationsID]
		,cast([ValueTime] as smalldatetime) as [ValueTime]
		,[DocumentationsClassPropertyID]
		,row_number() over (partition by [DocumentationsID], [DocumentationsClassPropertyID] order by ID desc) as RN
	from [dbo].[DocumentationsProperty]
	
	union all

	SELECT
		 isnull(ROW_NUMBER() over (order by D.ID) + (select max(ID) from [DocumentationsProperty]), 0) [ID]
		,upvt.[Description]
		,upvt.[Value]
		,D.ID								as [DocumentationsID]
		,getdate()							as [ValueTime]
		,null								as [DocumentationsClassPropertyID]
		,1									as [RN]
	FROM [dbo].[Documentations] D
	CROSS APPLY (
	VALUES 
		 (cast([DocumentationsClassID] as nvarchar(100)), N'Вид документа')
		,(cast([Status] as nvarchar(100)), N'Статус')
		,(convert(nvarchar(19), [StartTime], 126), N'Время создания')
		,(convert(nvarchar(19), [EndTime], 126), N'Время изменения')) as upvt([Value], [Description])
	) as T1
inner join [dbo].[Documentations] D
on T1.[DocumentationsID] = D.ID
inner join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
where RN = 1


GO