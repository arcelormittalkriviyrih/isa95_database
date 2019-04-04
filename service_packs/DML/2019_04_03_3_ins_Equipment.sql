

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

declare @ecid int;
declare @ecid2 int;
declare @ecid3 int;
declare @ecid4 int;

set @ecid = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Внешние предприятия'); 
set @ecid2 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
			where [EquipmentLevel] = N'Area' and [Description] = N'Цеха');
set @ecid3 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
			where [EquipmentLevel] = N'Process Cell' and [Description] = N'Производственный участок');

IF @ecid is NULL or @ecid2 is NULL or @ecid3 is NULL
RETURN;

select
	 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
into #tmp_mat2
from (values
			(N'ЧП КРАТ',  N'Area',  @ecid2, @ecid )
			,(N'Объединение Хорс',  N'Area',  @ecid2, @ecid )
			,(N'ТОВ Гросдорф',  N'Area',  @ecid2, @ecid )
			,(N'ТОВ НВП Агринол',  N'Area',  @ecid2, @ecid )
			,(N'КП Промремонт',  N'Area',  @ecid2, @ecid )
			,(N'ООО Стройиндустрия',  N'Area',  @ecid2, @ecid )
			,(N'ООО Меттраснсервис',  N'Area',  @ecid2, @ecid )
			,(N'ООО Проммонтажбуд',  N'Area',  @ecid2, @ecid )
			,(N'ООО Растро',  N'Area',  @ecid2, @ecid )
			,(N'ООО "Литейно-механический завод"',  N'Area',  @ecid2, @ecid )			
) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]  )

-- drop table #tmp_mat2
-- drop table #tmp_mat3
-- insert Equipment-ProcessCell (Внешние предприятия)
 		merge [dbo].[Equipment]  as trg 
		using
		(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
			from  #tmp_mat2) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


		-- insert property CONSIGNER for Equipment-Area (Внешние предприятия)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N'true'							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join #tmp_mat2 as T
			on MD.[Description] = T.[Description]
			join [dbo].[EquipmentClassProperty] MCP
			on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
			where MCP.[Value] = N'CONSIGNER') as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);

		-- insert property CONSIGNEE for Equipment-Area (Внешние предприятия)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N'true'							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join #tmp_mat2 as T
			on MD.[Description] = T.[Description]
			join [dbo].[EquipmentClassProperty] MCP
			on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
			where MCP.[Value] = N'CONSIGNEE') as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);


	-- insert property SAP_CODE for Equipment-Area (Внешние предприятия)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join #tmp_mat2 as T
			on MD.[Description] = T.[Description]
			join [dbo].[EquipmentClassProperty] MCP
			on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
			where MCP.[Value] = N'SAP_CODE') as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);


		--insert Equipment-ProcessCell (Внешние предприятия)
		merge [dbo].[Equipment]  as trg 
		using
		(select  #tmp_mat2.[Description] , N'Process Cell' [EquipmentLevel] , @ecid3 [EquipmentClassID], eq.[id] [Equipment] from  #tmp_mat2 
			join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
			on #tmp_mat2.[Description] = eq.[Description]) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);

		-- insert property SAP_CODE for Equipment-ProcessCell (Внешние предприятия)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select 	#tmp_mat2.[Description] , N'Process Cell' [EquipmentLevel] , @ecid3 [EquipmentClassID] , eq.[id] [Equipment]
						from  #tmp_mat2 
						join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
						on #tmp_mat2.[Description] = eq.[Description]
						where eq.EquipmentClassID = @ecid3) as T
			on MD.[Description] = T.[Description] 
			join [dbo].[EquipmentClassProperty] MCP
			on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
			where MCP.[Value] = N'SAP_CODE' and MD.EquipmentClassID = @ecid3) as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);

		--insert Equipment-ProcessCell (Внешние предприятия - ООО "Литейно-механический завод")

		set @ecid4 = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'ООО "Литейно-механический завод"'); 

		select
			 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
		into #tmp_mat3
		from (values
					 (N'Фасонночугуннолитейный цех (ФЧЛЦ)', N'Process Cell', @ecid3, @ecid4 )
					,(N'Фасонносталелитейный цех (ФСЛЦ)', N'Process Cell', @ecid3, @ecid4 )			
		) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment] )

		merge [dbo].[Equipment]  as trg 
		using
		(select  #tmp_mat3.[Description] , #tmp_mat3.[EquipmentLevel] , @ecid3 [EquipmentClassID], @ecid4 [Equipment] from  #tmp_mat3 ) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


		-- insert property SAP_CODE for Equipment-ProcessCell (Внешние предприятия - ООО "Литейно-механический завод")
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select 	#tmp_mat3.[Description] , N'Process Cell' [EquipmentLevel] , @ecid3 [EquipmentClassID] , eq.[id] [Equipment]
						from  #tmp_mat3 
						join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
						on #tmp_mat3.[Description] = eq.[Description]
						where eq.EquipmentClassID = @ecid3) as T
			on MD.[Description] = T.[Description] 
			join [dbo].[EquipmentClassProperty] MCP
			on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
			where MCP.[Value] = N'SAP_CODE' and MD.EquipmentClassID = @ecid3) as t2
		on (trg.[Description]=t2.[Description] and trg.[Value]=t2.[Value] and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);

GO