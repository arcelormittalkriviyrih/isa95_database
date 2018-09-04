
IF OBJECT_ID ('dbo.v_WGT_WaybillList',N'V') IS NOT NULL
  DROP VIEW [dbo].[v_WGT_WaybillList];
GO

/*
   View: v_WGT_WaybillList
   Список путевых для jstree
*/

create view [dbo].[v_WGT_WaybillList]
as
with CTE as(
select
	 [DocumentationsID]														as [DocumentationsID]
	,cast(dense_rank() over(ORDER BY [DocumentationsID] desc) as int)		as [N_DocumentationsID]
	,[Номер путевой]														as [WaybillNumber]
	,[Цех отправления]														as [SenderShopID]
	,E.[Description]														as [SenderShop]
	,D.[StartTime]															as [CreateDT]
	,D.[Status]																as [Status]
	,year(D.[StartTime])													as [YYYY]
	,cast(dense_rank() over(ORDER BY year(D.[StartTime]) desc) as int)		as [N_YYYY]
	,month(D.[StartTime])													as [MM]
	,cast(dense_rank() over(order by convert(nvarchar(7), D.[StartTime], 111) desc) as int)		as [N_MM]
	,[Приемосдатчик]														as [Creator]
	,N'№' + [Номер путевой] + N' от ' + convert(nvarchar, D.[StartTime], 104) + ' (' + E.[Description] + ')' as [Description]
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
		where DP.Description in (N'Номер путевой', N'Цех отправления', N'Приемосдатчик')) as T
	where RN = 1
) as T1
pivot
(min([Value]) 
for [Description] in ([Номер путевой], [Цех отправления], [Приемосдатчик])
) as pvt
left join [dbo].[Equipment] E
on pvt.[Цех отправления] = E.ID
inner join [dbo].[Documentations] D
on D.ID = pvt.DocumentationsID
inner join [dbo].[DocumentationsClass] DC
on DC.ID = D.DocumentationsClassID
where DC.Description = N'Путевая'
--order by [DocumentationsID]
),

CTE1 as (
select 
	 [DocumentationsID]
	,[N_DocumentationsID] + (select max([N_YYYY]) + max([N_MM]) from CTE) [N_DocumentationsID]
	,[WaybillNumber]
	,[SenderShopID]
	,[SenderShop]
	,[CreateDT]
	,[Status]
	,[YYYY]
	,[N_YYYY]
	,[MM]
	,[N_MM] + (select max([N_YYYY]) from CTE)		as [N_MM]
	,[Creator]
	,[Description]
from CTE)

select
	 T3.[ID]
	,T3.[ParentID]
	,T3.[DocumentationsID]
	,T3.[Description]
	,T4.[Creator]
	,T4.[SenderShopID]
	,T4.[Status]
from(
select distinct
	[N_YYYY]							as [ID]
	,'#'								as [ParentID]
	,null								as [DocumentationsID]
	,cast([YYYY] as nvarchar)			as [Description]
from CTE1
union all
select distinct
	[N_MM]								as [ID]
	,cast([N_YYYY] as nvarchar)			as [ParentID]
	,null								as [DocumentationsID]
	,datename(month, dateadd(month, [MM], -1))			as [Description]
from CTE1
union all
select distinct
	[N_DocumentationsID]
	,cast([N_MM] as nvarchar)
	,[DocumentationsID]
	,[Description]
from CTE1
) as T3
left join CTE T4
on T3.DocumentationsID = T4.DocumentationsID and T3.DocumentationsID is not null


GO