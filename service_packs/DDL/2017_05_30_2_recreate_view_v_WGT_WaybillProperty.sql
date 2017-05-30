
IF OBJECT_ID ('dbo.v_WGT_WaybillProperty',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WaybillProperty];
GO

/*
   View: v_WGT_WaybillProperty
   Возвращает свойства путевых
*/
CREATE view [dbo].[v_WGT_WaybillProperty]
as
select
	 [ID]
	,[DocumentationsID]
	,[Description]
	,[Value]
	--,[DocumentationsID]
	,[ValueTime]
	--,[DocumentationsClassPropertyID]
	,case [Description]
		when N'Номер путевой'										then N'WaybillNumber'
		when N'Приемосдатчик'										then N'Consigner'
		when N'Цех отправления'										then N'SenderShop'
		when N'Место погрузки'										then N'SenderDistrict'
		when N'Цех получения'										then N'ReceiverShop'
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
	 end				as [Description2]
	
	,case [Description]
		when N'Номер путевой'										then [Value]
		when N'Приемосдатчик'										then (select top 1 [PersonName] from [dbo].[PersonProperty] PP join [dbo].[Person] P on P.ID = PP.[PersonID] where LOWER(PP.[Value]) = LOWER(T1.Value))--[Value]
		when N'Цех отправления'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Место погрузки'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Цех получения'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Место выгрузки'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
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
	from [dbo].[DocumentationsProperty]) as T1
where RN = 1

GO