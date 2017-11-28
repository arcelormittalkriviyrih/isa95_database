
IF OBJECT_ID ('dbo.v_WGT_WeightsheetProperty',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WeightsheetProperty];
GO

/*
   View: v_WGT_WeightsheetProperty
   Возвращает свойства отвесных
*/
CREATE view [dbo].[v_WGT_WeightsheetProperty]
as
select
	 T1.[ID]
	,T1.[DocumentationsID]
	,T1.[Description]
	,T1.[Value]
	--,[DocumentationsID]
	,T1.[ValueTime]
	--,[DocumentationsClassPropertyID]
	,case T1.[Description]
		when N'Номер отвесной'										then N'WeightsheetNumber'
		when N'Весовщик'											then N'Weigher'
		when N'Цех отправления'										then N'SenderShop'
		when N'Цех получения'										then N'ReceiverShop'
		when N'Весы'												then N'Weightbridge'
		when N'DocumentationsClassID'								then N'DocumentType'
		else T1.[Description]
	 end				as [Description2]
	
	,case T1.[Description]
		when N'Номер отвесной'										then [Value]
		when N'Весовщик'											then (select top 1 [PersonName] from [dbo].[Person]		where ID = Value)
		when N'Цех отправления'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Цех получения'										then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'Весы'												then (select top 1 [Description] from [dbo].[Equipment] where ID = Value)
		when N'DocumentationsClassID'								then (select top 1 [Description] from [dbo].[DocumentationsClass] where ID = Value)
		when N'Status'												then [Value]
		when N'StartTime'											then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
		when N'EndTime'												then convert(nvarchar(10) ,cast([Value] as datetime), 104) + ' ' + convert(nvarchar(5) ,cast([Value] as datetime), 108)
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
		 (cast([DocumentationsClassID] as nvarchar(100)), 'DocumentationsClassID')
		,(cast([Status] as nvarchar(100)), 'Status')
		,(cast(cast([StartTime] as datetime) as nvarchar), 'StartTime')
		,(cast(cast([EndTime] as datetime) as nvarchar), 'EndTime')) as upvt([Value], [Description])
	--select
	--	 isnull(ROW_NUMBER() over (order by [DocumentationsID]) + (select max(ID) from [DocumentationsProperty]), 0) [ID]
	--	,N'Вид документа'			as [Description]
	--	,cast(T2.ID as nvarchar)	as [Value]
	--	,T2.DocumentationsID
	--	,getdate()					as [ValueTime]
	--	,null						as [DocumentationsClassPropertyID]
	--	,1							as RN
	--from (
	--	select distinct
	--		 [DocumentationsID]
	--		,DC.ID
	--	from [DocumentationsProperty] DP
	--	join [Documentations] D
	--	on D.ID = DP.DocumentationsID
	--	join [DocumentationsClass] DC
	--	on DC.ID = D.[DocumentationsClassID]) as T2
		) as T1
inner join [dbo].[Documentations] D
on T1.[DocumentationsID] = D.ID
inner join [dbo].[DocumentationsClass] DC
on D.DocumentationsClassID = DC.ID
where RN = 1 and DC.Description in (N'Тарирование', N'Загрузка', N'Отгрузка', N'Контроль брутто')



GO