SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO
SET NOCOUNT ON
GO

IF Object_ID('tempdb..#tmp_mat1') is not null
drop table #tmp_mat1

IF Object_ID('tempdb..#tmp_mat2') is not null
drop table #tmp_mat2

declare @ecid int;
declare @ecid2 int;
declare @equ int;
declare @equ_special int;

declare @ecid_site int;
declare @equ_site int;

set @ecid_site = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'АрселорМиттал Кривой Рог' and [EquipmentLevel] = N'Enterprise'); 
set @equ_site = (SELECT top 1 [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass] where [Description] = N'Департаменты');

IF @ecid_site is NULL or @equ_site is NULL
RETURN;

select
	 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
into #tmp_mat1
from (values (N'ПАО АМКР','Site',@ecid_site ,@equ_site)) as T([Description] ,[EquipmentLevel],[Equipment]  ,[EquipmentClassID])

-- drop table #tmp_mat1
-- insert Equipment-Site (ПАО АМКР)
 		merge [dbo].[Equipment]  as trg_dep
		using
		(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
			from  #tmp_mat1) as t2
		on (trg_dep.[Description]=t2.[Description] and trg_dep.[EquipmentLevel]=t2.[EquipmentLevel] and trg_dep.[EquipmentClassID]=t2.[EquipmentClassID] and trg_dep.[Equipment]=t2.[Equipment])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);

set @ecid = (SELECT  top 1  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'ПАО АМКР' and [EquipmentLevel] = N'Site'); 
set @equ = (SELECT top 1 [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass] where [Description] = N'Цеха');
set @ecid2 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
		where [EquipmentLevel] = N'Process Cell' and [Description] = N'Производственный участок');

IF @ecid is NULL or @equ is NULL or @ecid2 is NULL
RETURN;

select
	 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
into #tmp_mat2
from (values
		 (N'ДАТП','Area',@ecid ,@equ)
		 ,(N'Полигон (ШПЦ)','Area',@ecid ,@equ)
		 ,(N'УКП','Area',@ecid ,@equ)
		 ,(N'МНЛЗ','Area',@ecid ,@equ)
		 ,(N'Цех подготовки производства (ЦПП)','Area',@ecid ,@equ)
		 ,(N'СХЧ','Area',@ecid ,@equ)
		 ,(N'УПС','Area',@ecid ,@equ)
		 ,(N'ДТАП','Area',@ecid ,@equ)
		 ,(N'Шахтоуправление (ШУ)','Area',@ecid ,@equ)
		 ,(N'УПЦ ТЭЦ','Area',@ecid ,@equ)
		 ,(N'ЦДСР','Area',@ecid ,@equ)
		 ,(N'Ремонтное производство (РП ЦДСР)','Area',@ecid ,@equ)
		 ,(N'ЩПУ','Area',@ecid ,@equ)
		 ,(N'НКГОК','Area',@ecid ,@equ)
		 ,(N'Аглофабрика (АФ)','Area',@ecid ,@equ)
		 ,(N'ОНРС 2','Area',@ecid ,@equ)
		 ,(N'ОНРС 3','Area',@ecid ,@equ)
		 ,(N'ТЭЦ','Area',@ecid ,@equ)
) as T([Description] ,[EquipmentLevel],[Equipment]  ,[EquipmentClassID])

-- drop table #tmp_mat2
-- insert Equipment-Area (ПАО АМКР)
 		merge [dbo].[Equipment]  as trg 
		using
		(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
			from  #tmp_mat2) as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- insert property SAP_CODE for Equipment-Area (ПАО АМКР)
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


	-- insert property CONSIGNER for Equipment-Area (ПАО АМКР)
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

		-- insert property CONSIGNEE for Equipment-Area (ПАО АМКР)
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


		--insert Equipment-ProcessCell (ПАО АМКР)
		merge [dbo].[Equipment]  as trg 
		using
		(select  #tmp_mat2.[Description] , N'Process Cell' [EquipmentLevel] , @ecid2 [EquipmentClassID], eq.[id] [Equipment] from  #tmp_mat2 
			join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
			on #tmp_mat2.[Description] = eq.[Description]
			where  #tmp_mat2.[Description] <> N'Горный департамент (ГД)') as t2
		on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
				VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


		-- insert property SAP_CODE for Equipment-ProcessCell (ПАО АМКР)
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
						where eq.EquipmentClassID = @ecid2 and #tmp_mat2.[Description] <> N'Горный департамент (ГД)') as T
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