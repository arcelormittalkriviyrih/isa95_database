USE [KRR-PA-ISA95_PRODUCTION]
GO

--> 
declare @ID int
declare @Description nvarchar(50)
declare @EquipmentLevel nvarchar(50)
declare @ParentID int
declare @EquipmentClassID int

declare @idProduction int
declare @idDepartments int
declare @idService int
declare @idShop int

declare @idamkr int
declare @idmp int
declare @idkhp int
declare @idhp int

declare @idadd int
declare @idrd int
declare @idsd int

declare @idsp1 int
declare @idsp2 int
declare @idsp3 int
declare @idbfs1 int
declare @idbfs2 int
declare @idspmp int

declare @idkc int
declare @idmc int
declare @idoic int
declare @idkopr int

declare @idspc1 int
declare @idspc2 int
declare @idpc3 int
declare @idbluming int
declare @idcpmp int
declare @idvc int

/**********************************************************************************************************
Добавим [EquipmentClass] Производства\Департаменты\Цеха\Службы
***********************************************************************************************************/
--> Забиваем id c 20 ... 25
--if (not exists(SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([ID] >= 20) and ([ID] <= 25)))  
	begin
		-----------------------------------------------------------------------------------------------------
		set @ID = 20;
		set @Description = N'Производства';
		set @EquipmentLevel = N'Site';
		set @ParentID = null;

		--> проверим наличие EquipmentClass
		if (not exists(SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[EquipmentClass]
				([Description]
				,[EquipmentLevel]
				,[ParentID]
				,[ID])
				VALUES
				(@Description
				,@EquipmentLevel
				,@ParentID
				,@ID)
			END ELSE BEGIN
				UPDATE [dbo].[EquipmentClass]
				SET [EquipmentLevel] = @EquipmentLevel
				,[ParentID] = @ParentID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
			END
		set @idProduction = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Департаменты';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idProduction;

		--> проверим наличие EquipmentClass
		if (not exists(SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[EquipmentClass]
				([Description]
				,[EquipmentLevel]
				,[ParentID]
				,[ID])
				VALUES
				(@Description
				,@EquipmentLevel
				,@ParentID
				,@ID)
			END ELSE BEGIN
				UPDATE [dbo].[EquipmentClass]
				SET [EquipmentLevel] = @EquipmentLevel
				,[ParentID] = @ParentID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
			END
			set @idDepartments = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Цеха';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idDepartments;

		--> проверим наличие EquipmentClass
		if (not exists(SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[EquipmentClass]
				([Description]
				,[EquipmentLevel]
				,[ParentID]
				,[ID])
				VALUES
				(@Description
				,@EquipmentLevel
				,@ParentID
				,@ID)
			END ELSE BEGIN
				UPDATE [dbo].[EquipmentClass]
				SET [EquipmentLevel] = @EquipmentLevel
				,[ParentID] = @ParentID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
			END
			set @idShop = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Службы';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idDepartments;

		--> проверим наличие EquipmentClass
		if (not exists(SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[EquipmentClass]
				([Description]
				,[EquipmentLevel]
				,[ParentID]
				,[ID])
				VALUES
				(@Description
				,@EquipmentLevel
				,@ParentID
				,@ID)
			END ELSE BEGIN
				UPDATE [dbo].[EquipmentClass]
				SET [EquipmentLevel] = @EquipmentLevel
				,[ParentID] = @ParentID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))
			END
			set @idService = (SELECT [ID] FROM [dbo].[EquipmentClass] WHERE ([Description] = @Description))

	end --{Забиваем id c 20 ...}

/**********************************************************************************************************
Добавим [Equipment] Производства\Департаменты\Цеха\Службы
***********************************************************************************************************/
--> Забиваем id c 100 ... 
--if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([ID] >= 100) and ([ID] <= 200)))  
	begin
			-----------------------------------------------------------------------------------------------------
		set @ID = 100;
		set @Description = N'АрселорМиттал Кривой Рог';
		set @EquipmentLevel = N'Enterprise';
		set @ParentID = null;
		set @EquipmentClassID = null;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idamkr = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))

			-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Металлургическое производство';
		set @EquipmentLevel = N'Site';
		set @ParentID = @idamkr;
		set @EquipmentClassID = @idProduction;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idmp = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))

			-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Коксохимическое производство';
		set @EquipmentLevel = N'Site';
		set @ParentID = @idamkr;
		set @EquipmentClassID = @idProduction;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idkhp = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Вспомогательное производство';
		set @EquipmentLevel = N'Site';
		set @ParentID = @idamkr;
		set @EquipmentClassID = @idProduction;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idhp = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Металлургическое производство	
		*******************************************************************************************************/
		/******************************************************************************************************
				 Аглодоменный департамент
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Аглодоменный департамент';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idmp;
		set @EquipmentClassID = @idDepartments;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idadd = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 АЦ-1
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Аглоцех-1';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idsp1 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 АЦ-2
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Аглоцех-2';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idsp2 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 АЦ-3
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Аглоцех-3';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idsp3 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 ДЦ-1
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Доменный цех-1';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idbfs1 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 ДЦ-2
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Доменный цех-2';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idbfs2 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Аглоцех металлургического производства
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Аглоцех МП';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idadd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idspmp = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))

		/******************************************************************************************************
				 Металлургическое производство	
		*******************************************************************************************************/
		/******************************************************************************************************
				 Сталеплавильный департамент
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Сталеплавильный департамент';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idmp;
		set @EquipmentClassID = @idDepartments;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idsd = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Конверторный цех
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Конверторный цех';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idsd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idkc = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Мартеновский цех
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Мартеновский цех';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idsd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idmc = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Огнеупорно-известковый цех
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Огнеупорно-известковый цех';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idsd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idoic = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Копровой цех
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Копровой цех';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idsd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idkopr = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))

		/******************************************************************************************************
				 Металлургическое производство	
		*******************************************************************************************************/
		/******************************************************************************************************
				 Прокатный департамент
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Прокатный департамент';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idmp;
		set @EquipmentClassID = @idDepartments;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idrd = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 СПЦ-1
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'СПЦ-1';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idspc1 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 СПЦ-2
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'СПЦ-2';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idspc2 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Прокатный цех-3
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Прокатный цех-3';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idpc3 = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Блюминг
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Блюминг';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idbluming = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Цех переработки металлопродукции
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Цех переработки металлопродукции';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idcpmp = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
		/******************************************************************************************************
				 Вальцетокарный цех
		*******************************************************************************************************/
		-----------------------------------------------------------------------------------------------------
		set @ID = @ID+1;
		set @Description = N'Вальцетокарный цех';
		set @EquipmentLevel = N'Area';
		set @ParentID = @idrd;
		set @EquipmentClassID = @idshop;
		--> проверим наличие Equipment
		if (not exists(SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description)))  
			BEGIN
				--> Нет, создадим
				INSERT INTO [dbo].[Equipment]
				([ID]
				,[Description]
				,[EquipmentLevel]
				,[Equipment]
				,[EquipmentClassID])
			VALUES
				(@ID
				,@Description
				,@EquipmentLevel
				,@ParentID
				,@EquipmentClassID)
			END ELSE BEGIN
				UPDATE [dbo].[Equipment]
				SET [EquipmentLevel] = @EquipmentLevel
				,[Equipment] = @ParentID
				,[EquipmentClassID] = @EquipmentClassID
				WHERE [ID] = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))
			END
		set @idvc = (SELECT [ID] FROM [dbo].[Equipment] WHERE ([Description] = @Description))

	end
GO


