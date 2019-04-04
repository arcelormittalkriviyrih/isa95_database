
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

IF Object_ID('tempdb..#tmp_mat2') is not null
drop table #tmp_mat2

declare @ecid int;
declare @ecid2 int;
declare @equ int;

set @ecid = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Сталеплавильный департамент' and [EquipmentLevel] = N'Area'); 
set @ecid2 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
			where [EquipmentLevel] = N'Process Cell' and [Description] = N'Производственный участок');

IF @ecid is NULL or @ecid2 is NULL
RETURN;

select
	 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
into #tmp_mat2
from (values
			(N'Сталеплавильный департамент',  N'Process Cell',  @ecid2, @ecid )
			,(N'Конвертерные цеха',  N'Process Cell',  @ecid2, @ecid )
			,(N'Мартеновский цех',  N'Process Cell',  @ecid2, @ecid )
			,(N'Копровой цех',  N'Process Cell',  @ecid2, @ecid )
			,(N'Цех подготовки составов',  N'Process Cell',  @ecid2, @ecid )
			,(N'Огнеупорно-известковый цех',  N'Process Cell',  @ecid2, @ecid )
) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]  )

-- drop table #tmp_mat2
-- insert Equipment-ProcessCell (Сталеплавильный департамент)
 		merge [dbo].[Equipment]  as trg 
		using
		(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
			from  #tmp_mat2) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


		-- insert property SAP_CODE for Equipment-ProcessCell (Сталеплавильный департамент)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment] from  #tmp_mat2) as T
						on MD.[Description] = T.[Description] 
						join [dbo].[EquipmentClassProperty] MCP
						on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
						where MCP.[Value] = N'SAP_CODE' and MD.EquipmentClassID = @ecid2) as t2
				on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);


GO