SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.v_KP4_AllWorkPerformance',N'V') IS NOT NULL
  DROP VIEW dbo.v_KP4_AllWorkPerformance;
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[v_KP4_AllWorkPerformance]
AS

with 
TTT as(
select
	year([StartTime])																		as [YYYY],
	cast(dense_rank() over(ORDER BY year([StartTime]) desc) as int)							as [N_YYYY],
	month([StartTime])																		as [MM],
	cast(dense_rank() over(order by convert(nvarchar(7), [StartTime], 111) desc) as int)	as [N_MM],
	day([StartTime])																		as [DD],
	cast(dense_rank() over(order by convert(nvarchar, [StartTime], 111) desc) as int)		as [N_DD],
	[ID]																					as [WorkPerfomanceID],
	cast(dense_rank() over(order by [ID] desc) as int)										as [N_WorkPerfomanceID],
	[Description],
	[StartTime]
from
(	select top (100) percent
		 [ID]
		,[StartTime]
		,[Description]
	from [dbo].[WorkPerformance]
	where 
			[WorkState] = 'Closed' 
		and [WorkType] like 'WSH_%'
		and isnumeric([Description]) = 1
	order by [ID]
) as T),

RRR as(
select
	[YYYY],
	[N_YYYY],
	[MM],
	[N_MM] + (select max([N_YYYY]) from TTT) as [N_MM],
	[DD],
	[N_DD] + (select max([N_YYYY])+ max([N_MM]) from TTT) as [N_DD],
	[WorkPerfomanceID],
	[N_WorkPerfomanceID] + (select max([N_YYYY])+ max([N_MM]) + max([N_DD]) from TTT) as [N_WorkPerfomanceID],
	[Description],
	[StartTime]
from TTT)


select distinct
	[N_YYYY]	[ID],
	'#'		[ParentID],
	null		[WorkPerfomanceID],
	cast([YYYY] as nvarchar)	[Description]
from RRR
union all
select distinct
	[N_MM]		[ID],
	cast([N_YYYY] as nvarchar)	[ParentID],
	null		[WorkPerfomanceID],
	datename(month, dateadd(month, [MM], -1))	[Description]
from RRR
union all
select distinct
	[N_DD]		[ID],
	cast([N_MM] as nvarchar)		[ParentID],
	null		[WorkPerfomanceID],
	cast([DD] as nvarchar)		[Description]
from RRR
union all
select distinct
	[N_WorkPerfomanceID]	[ID],
	cast([N_DD] as nvarchar)					[ParentID],
	[WorkPerfomanceID]		[WorkPerfomanceID],
	N'№' + [Description] + ' (' + convert(nvarchar(5), [StartTime], 108) + ')'		[Description]
from RRR





GO