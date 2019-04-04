SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

declare @ecid int;
declare @ecid2 int;
declare @equ int;

set @ecid = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Аглодоменный департамент' and [EquipmentLevel] = N'Site'); 
set @equ = (SELECT top 1 [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass] where [Description] = N'Цеха');
set @ecid2 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
		where [EquipmentLevel] = N'Process Cell' and [Description] = N'Производственный участок');

IF @ecid is NULL or @equ is NULL or @ecid2 is NULL 
RETURN;

select 1

select
	 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
into #tmp_mat2
from (values
		 (N'Аглодоменный департамент (АДД)','Area',@ecid ,@equ)
		,(N'Аглодоменный цех (АЦ МП)','Area',@ecid ,@equ)
		,(N'Рудный двор (РД АЦ МП)','Area',@ecid ,@equ)
		,(N'Агломерационный цех №1 (АЦ-1)','Area',@ecid ,@equ)
		,(N'Агломерационный цех №2 (АЦ-2)','Area',@ecid ,@equ)
		,(N'Агломерационный цех №3 (АЦ-3)','Area',@ecid ,@equ)
		,(N'Доменный цех №1 (ДЦ-1)','Area',@ecid ,@equ)
		,(N'Шлакоперерабатывающий участок (ШПУ)','Area',@ecid ,@equ)
		,(N'Доменный цех №2 (ДЦ-2)','Area',@ecid ,@equ)
		,(N'Доменная печь №5 (ДП-5)','Area',@ecid ,@equ) 
) as T([Description] ,[EquipmentLevel],[Equipment]  ,[EquipmentClassID])

-- drop table #tmp_mat2
-- insert Equipment-Area (Аглодоменный департамент)
 		merge [dbo].[Equipment]  as trg 
		using
		(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
			from  #tmp_mat2) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- insert property SAP_CODE for Equipment-Area (Аглодоменный департамент)
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


	-- insert property CONSIGNER for Equipment-Area (Аглодоменный департамент)
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

		-- insert property CONSIGNEE for Equipment-Area (Аглодоменный департамент)
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

		--insert Equipment-ProcessCell (Аглодоменный департамент)
		merge [dbo].[Equipment]  as trg 
		using
		(select  #tmp_mat2.[Description] , N'Process Cell' [EquipmentLevel] , @ecid2 [EquipmentClassID], eq.[id] [Equipment] from  #tmp_mat2 
			join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
			on #tmp_mat2.[Description] = eq.[Description]
			where  #tmp_mat2.[Description] <> N'Аглодоменный департамент (АДД)') as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


		-- insert property SAP_CODE for Equipment-ProcessCell (Аглодоменный департамент)
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select 	#tmp_mat2.[Description] , N'Process Cell' [EquipmentLevel] , @ecid2 [EquipmentClassID] , eq.[id] [Equipment]
						from  #tmp_mat2 
						join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
						on #tmp_mat2.[Description] = eq.[Description]
						where eq.EquipmentClassID = @ecid2 and #tmp_mat2.[Description] <> N'Аглодоменный департамент (АДД)') as T
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