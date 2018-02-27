
IF OBJECT_ID ('dbo.v_WGT_WeightsheetList',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WeightsheetList];
GO

/*
   View: v_WGT_WeightsheetList
   Список отвесных для jstree
*/

CREATE view [dbo].[v_WGT_WeightsheetList]
as
with CTE as(
select
	 [DocumentationsID]														as [DocumentationsID]
	,cast(dense_rank() over(ORDER BY [DocumentationsID] desc) as int)		as [N_DocumentationsID]
	,[Номер отвесной]														as [WaybillNumber]
	,[Весы]																	as [WeightbridgeID]
	,E.[Description]														as [Weightbridge]
	,D.[StartTime]															as [CreateDT]
	,D.[Status]																as [Status]
	,year(D.[StartTime])													as [YYYY]
	,cast(dense_rank() over(ORDER BY year(D.[StartTime]) desc) as int)		as [N_YYYY]
	,P.[PersonName]															as [Creator]
	,N'№' + [Номер отвесной] + N' от ' + convert(nvarchar(5), D.[StartTime], 104)/* + ' (' + E.[Description] + ')'*/ as [Description]
from(
	select 
		 [Description]
		,[Value]
		,[DocumentationsID]
	from(
		select
			 --[ID]
			 [Description]
			,[Value]
			,[DocumentationsID]
			--,cast([ValueTime] as smalldatetime) as [ValueTime]
			--,[DocumentationsClassPropertyID]
			,row_number() over (partition by [DocumentationsID], [DocumentationsClassPropertyID] order by ID desc) as RN
		from [dbo].[DocumentationsProperty] DP
		where DP.Description in (N'Номер отвесной', N'Весы', N'Весовщик')) as T
	where RN = 1
) as T1
pivot
(min([Value]) 
for [Description] in ([Номер отвесной], [Весы], [Весовщик])
) as pvt
left join [dbo].[Equipment] E
on pvt.[Весы] = E.ID
inner join [dbo].[Documentations] D
on D.ID = pvt.DocumentationsID
inner join [dbo].[Person] P
on pvt.[Весовщик] = P.ID
inner join [dbo].[DocumentationsClass] DC
on DC.ID = D.DocumentationsClassID
inner join [dbo].[DocumentationsClass] DC1
on DC1.ID = DC.ParentID
where DC1.Description in (N'Отвесная')
--order by [DocumentationsID]
),

CTE1 as (
select 
	 [DocumentationsID]
	,[N_DocumentationsID] + (select max([N_YYYY]) from CTE) [N_DocumentationsID]
	,[WaybillNumber]
	,[WeightbridgeID]
	,[Weightbridge]
	,[CreateDT]
	,[Status]
	,[YYYY]
	,[N_YYYY]
	,[Creator]
	,[Description]
from CTE)


select
	 T3.[ID]
	,T3.[ParentID]
	,T3.[DocumentationsID]
	,T3.[Description]
	,T4.[Creator]
	,T4.[WeightbridgeID]
	,T4.[Weightbridge]
	,T4.[Status]
from(
	select distinct
		 [N_YYYY]							as [ID]
		,'#'								as [ParentID]
		,null								as [DocumentationsID]
		,cast([YYYY] as nvarchar)			as [Description]
		--,[Creator]
		--,[SenderShopID]
	from CTE1
	union all
	select distinct
		 [N_DocumentationsID]
		,cast([N_YYYY] as nvarchar)
		,[DocumentationsID]
		,[Description]
		--,[Creator]
		--,[SenderShopID]
	from CTE1
) as T3
left join CTE T4
on T3.DocumentationsID = T4.DocumentationsID and T3.DocumentationsID is not null


GO