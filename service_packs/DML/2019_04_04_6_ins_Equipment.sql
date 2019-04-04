


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

IF Object_ID('tempdb..#tmp_mat3') is not null
drop table #tmp_mat1

IF Object_ID('tempdb..#tmp_mat4') is not null
drop table #tmp_mat2

IF Object_ID('tempdb..#tmp_mat5') is not null
drop table #tmp_mat1

IF Object_ID('tempdb..#tmp_mat6') is not null
drop table #tmp_mat2

IF Object_ID('tempdb..#tmp_mat7') is not null
drop table #tmp_mat1

IF Object_ID('tempdb..#tmp_mat8') is not null
drop table #tmp_mat2

IF Object_ID('tempdb..#tmp_mat9') is not null
drop table #tmp_mat1


declare @ecid1 int,@ecid2 int,@ecid3 int,@ecid4 int,@ecid5 int,@ecid6 int,@ecid7 int;


set @ecid1 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]	where [EquipmentLevel] = N'Area' and [Description] = N'Цеха');
set @ecid2 = (SELECT  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Прокатный департамент'
					and [EquipmentLevel] = N'Site'); 
set @ecid3 = (SELECT [ID] FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[EquipmentClass]
				where [EquipmentLevel] = N'Process Cell' and [Description] = N'Производственный участок');
set @ecid4 = (SELECT  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Прокатный департамент (ПД)'
					and [EquipmentLevel] = N'Area');
set @ecid5 = (SELECT  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'Блуминг'
					and [EquipmentLevel] = N'Area'); 
set @ecid6 = (SELECT  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'ЦПМ'
					and [EquipmentLevel] = N'Area');
set @ecid7 = (SELECT  [ID]  FROM [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] where [Description] = N'ПЦ-3' and [EquipmentLevel] = N'Area');  


IF @ecid1 is NULL or @ecid2 is NULL or @ecid3 is NULL or @ecid4 is NULL or @ecid5 is NULL or @ecid6 is NULL or @ecid7 is NULL
RETURN;

--select @ecid1
--select @ecid2
--select @ecid3 , @ecid2

	-- insert Equipment-Site (Прокатный департамент (ПД))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
	into #tmp_mat1
	from (values
				 (N'Прокатный департамент (ПД)',  N'Area',  @ecid1,  @ecid2)
				,(N'Блуминг',  N'Area',  @ecid1,  @ecid2)
				,(N'Отделение холодного волочения',  N'Area',  @ecid1,  @ecid2)
				,(N'Участок реализации металлопроката',  N'Area',  @ecid1,  @ecid2)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment])

	/* drop table #tmp_mat1 
	 drop table #tmp_mat2
	 drop table #tmp_mat3
	 drop table #tmp_mat4
	 drop table #tmp_mat5
	 drop table #tmp_mat6
	 drop table #tmp_mat7
	 drop table #tmp_mat8
	 drop table #tmp_mat9 */

	-- insert Equipment-Area (Прокатный департамент (ПД))
 			merge [dbo].[Equipment]  as trg 
			using
			(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
				from  #tmp_mat1) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- insert Equipment-ProcessCell (Прокатный департамент (ПД)-Прокатный департамент (ПД))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
	into #tmp_mat2
	from (values
				 (N'Прокатный департамент (ПД)', N'Process Cell', @ecid3, @ecid4)
				,(N'Сортопрокатный цех-1 (ПД)', N'Process Cell', @ecid3, @ecid4)
				,(N'Сортопрокатный цех-2 (ПД)', N'Process Cell', @ecid3, @ecid4)
				,(N'Прокатный цех №3 (ПД)', N'Process Cell', @ecid3, @ecid4)
				,(N'Блуминг', N'Process Cell', @ecid3, @ecid4)
				,(N'Цех подготовки металлопродукции (ЦПМ (ЦПМп))', N'Process Cell', @ecid3, @ecid4)
				,(N'Отделение холодного волочения', N'Process Cell', @ecid3, @ecid4)
				,(N'Участок реализации металлопроката', N'Process Cell', @ecid3, @ecid4)
				,(N'Вальцетокарный цех', N'Process Cell', @ecid3, @ecid4)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]);

	 		merge [dbo].[Equipment]  as trg 
			using
			(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
				from  #tmp_mat2) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- insert Equipment-ProcessCell (Прокатный департамент (ПД)-Блуминг)
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
	into #tmp_mat3
	from (values
				 (N'Блуминг', N'Process Cell', @ecid3, @ecid5)
				,(N'Стан1250', N'Process Cell', @ecid3, @ecid5)
				,(N'Мет.ст1300на1250', N'Process Cell', @ecid3, @ecid5)
				,(N'Мет.ст1250на1300', N'Process Cell', @ecid3, @ecid5)
				,(N'УПЗ ПЦ№3 заг1300', N'Process Cell', @ecid3, @ecid5)
				,(N'УПЗ ПЦ№3 заг1250', N'Process Cell', @ecid3, @ecid5)
				,(N'Стан 1300', N'Process Cell', @ecid3, @ecid5)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]);

	 		merge [dbo].[Equipment]  as trg 
			using
			(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
				from  #tmp_mat3) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);

	-- insert Equipment-ProcessCell (Прокатный департамент (ПД)-Цех подготовки металлопродукции (ЦПМ (ЦПМп)))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
	into #tmp_mat4
	from (values
				 (N'Цех подготовки металлопродукции (ЦПМ (ЦПМп))', N'Process Cell', @ecid3, @ecid6)
				,(N'5 тупик', N'Process Cell', @ecid3, @ecid6)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]);

	 		merge [dbo].[Equipment]  as trg 
			using
			(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
				from  #tmp_mat4) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);

	-- insert Equipment-ProcessCell (Прокатный департамент (ПД)-Прокатный цех №3 (ПЦ-3))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
	into #tmp_mat5
	from (values
				 (N'Прокатный цех №3 (ПЦ-3)', N'Process Cell', @ecid3, @ecid7)
				,(N'МС-6 (ПЦ-3 (МС-6))', N'Process Cell', @ecid3, @ecid7)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID],[Equipment]);

	 		merge [dbo].[Equipment]  as trg 
			using
			(select  [Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]
				from  #tmp_mat5) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- insert Equipment-ProcessCell (Прокатный департамент (ПД)) ЦЕХ = Местовыгрузки
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID]
	into #tmp_mat6
	from (values
				 (N'СПЦ-1', N'Process Cell', @ecid3)
				,(N'СПЦ-2', N'Process Cell', @ecid3)
				,(N'Отделение холодного волочения', N'Process Cell', @ecid3)
				,(N'Участок реализации металлопроката', N'Process Cell', @ecid3)
				,(N'Вальцетокарный цех', N'Process Cell', @ecid3)
	) as T([Description] ,[EquipmentLevel],[EquipmentClassID]);

	 		merge [dbo].[Equipment]  as trg 
			using
			(select  #tmp_mat6.[Description] ,#tmp_mat6.[EquipmentLevel] ,#tmp_mat6.[EquipmentClassID], eq.[id] [Equipment] from  #tmp_mat6
				join [KRR-PA-ISA95_PRODUCTION].[dbo].[Equipment] eq
				on #tmp_mat6.[Description] = eq.[Description]
				where  eq.[EquipmentClassID] = @ecid1
			) as t2
			on (trg.[Description]=t2.[Description] and trg.[EquipmentLevel]=t2.[EquipmentLevel] and trg.[EquipmentClassID]=t2.[EquipmentClassID] and trg.[Equipment]=t2.[Equipment])
			WHEN NOT MATCHED THEN
			INSERT   ([Description] ,[EquipmentLevel] ,[EquipmentClassID],[Equipment]) 
					VALUES (t2.[Description], t2.[EquipmentLevel], t2.[EquipmentClassID], t2.[Equipment]);


	-- property SAP_CODE for Equipment-Area (Прокатный департамент (ПД))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID]
	into #tmp_mat7
	from (values
				 (N'Прокатный департамент (ПД)', N'Area', @ecid1) 
				,(N'СПЦ-1', N'Area', @ecid1)
				,(N'СПЦ-2', N'Area', @ecid1)
				,(N'ПЦ-3', N'Area', @ecid1)
				,(N'Блуминг', N'Area', @ecid1)
				,(N'ЦПМ', N'Area', @ecid1)
				,(N'Отделение холодного волочения', N'Area', @ecid1)
				,(N'Участок реализации металлопроката', N'Area', @ecid1)
				,(N'Вальцетокарный цех', N'Area', @ecid1)
		) as T([Description] ,[EquipmentLevel],[EquipmentClassID]);


		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select  [Description] ,[EquipmentLevel] ,[EquipmentClassID] from  #tmp_mat7) as T
						on MD.[Description] = T.[Description] 
						join [dbo].[EquipmentClassProperty] MCP
						on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
						where MCP.[Value] = N'SAP_CODE' and MD.EquipmentClassID = @ecid1) as t2
				on (trg.[Description]=t2.[Description]  and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]); 

		-- property CONSIGNER for Equipment-Area (Прокатный департамент (ПД))
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N'true'						as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select  [Description] ,[EquipmentLevel] ,[EquipmentClassID] from  #tmp_mat7) as T
						on MD.[Description] = T.[Description] 
						join [dbo].[EquipmentClassProperty] MCP
						on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
						where MCP.[Value] = N'CONSIGNER' and MD.EquipmentClassID = @ecid1) as t2
				on (trg.[Description]=t2.[Description]  and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);

		-- property CONSIGNEE for Equipment-Area (Прокатный департамент (ПД))
		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N'true'						as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select  [Description] ,[EquipmentLevel] ,[EquipmentClassID] from  #tmp_mat7) as T
						on MD.[Description] = T.[Description] 
						join [dbo].[EquipmentClassProperty] MCP
						on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
						where MCP.[Value] = N'CONSIGNEE' and MD.EquipmentClassID = @ecid1) as t2
				on (trg.[Description]=t2.[Description]  and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]);


	-- property SAP_CODE for Equipment-ProcessCell (Прокатный департамент (ПД))
	select
		 [Description] ,[EquipmentLevel] ,[EquipmentClassID]
	into #tmp_mat8
	from (values				
				 (N'Прокатный департамент (ПД)',  N'Process Cell' , @ecid3)
				,(N'Сортопрокатный цех-1 (ПД)',   N'Process Cell' , @ecid3)
				,(N'Сортопрокатный цех-2 (ПД)',   N'Process Cell' , @ecid3)
				,(N'Прокатный цех №3 (ПД)',   N'Process Cell' , @ecid3)
				,(N'Блуминг',   N'Process Cell' , @ecid3)
				,(N'Цех подготовки металлопродукции (ЦПМ (ЦПМп))',   N'Process Cell' , @ecid3)
				,(N'Отделение холодного волочения',   N'Process Cell' , @ecid3)
				,(N'Участок реализации металлопроката',   N'Process Cell' , @ecid3)
				,(N'Вальцетокарный цех',   N'Process Cell' , @ecid3)
				,(N'СПЦ-1',   N'Process Cell' , @ecid3)
				,(N'СПЦ-2',   N'Process Cell' , @ecid3)
				,(N'Прокатный цех №3 (ПЦ-3)',   N'Process Cell' , @ecid3)
				,(N'МС-6 (ПЦ-3 (МС-6))',   N'Process Cell' , @ecid3)
				,(N'Блуминг',   N'Process Cell' , @ecid3)
				,(N'Стан1250',   N'Process Cell' , @ecid3)
				,(N'Мет.ст1300на1250',   N'Process Cell' , @ecid3)
				,(N'Мет.ст1250на1300',   N'Process Cell' , @ecid3)
				,(N'УПЗ ПЦ№3 заг1300',   N'Process Cell' , @ecid3)
				,(N'УПЗ ПЦ№3 заг1250',   N'Process Cell' , @ecid3)
				,(N'Стан 1300',   N'Process Cell' , @ecid3)
				,(N'ЦПМ)',   N'Process Cell' , @ecid3)
				,(N'5 тупик',   N'Process Cell' , @ecid3)
				,(N'Отделение холодного волочения',   N'Process Cell' , @ecid3)
				,(N'Участок реализации металлопроката',   N'Process Cell' , @ecid3)
				,(N'Вальцетокарный цех',   N'Process Cell' , @ecid3)
		) as T([Description] ,[EquipmentLevel],[EquipmentClassID]);


		merge [dbo].[EquipmentProperty]  as trg 
		using
		(select distinct
				 MCP.[Description]				as [Description]
				,N''							as [Value]
				,MD.[ID]						as [EquipmentID]
				,MCP.[ID]						as [ClassPropertyID]
			from [dbo].[Equipment] MD
			join (select  [Description] ,[EquipmentLevel] ,[EquipmentClassID] from  #tmp_mat8) as T
						on MD.[Description] = T.[Description] -- and 
						join [dbo].[EquipmentClassProperty] MCP
						on MCP.[EquipmentClassID] = MD.[EquipmentClassID]
						where MCP.[Value] = N'SAP_CODE' and MD.EquipmentClassID = @ecid3) as t2
				on (trg.[Description]=t2.[Description]  and  trg.[EquipmentID]=t2.[EquipmentID]
				and trg.[ClassPropertyID]=t2.[ClassPropertyID])
		WHEN NOT MATCHED THEN
		INSERT   ([Description] , [Value] ,[EquipmentID] ,[ClassPropertyID]) 
			VALUES (t2.[Description], t2.[Value], t2.[EquipmentID] ,t2.[ClassPropertyID]); 
		

GO