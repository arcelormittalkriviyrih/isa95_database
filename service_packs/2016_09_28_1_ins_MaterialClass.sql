--------------------------------------------------------------
/*
Заполнение таблиц MaterialClass 
данными по проекту Система упрвления операциями СЦиО
*/
SET NOCOUNT ON


INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [Code]) VALUES(N'СИТ',100000, N'Measuring instruments')
INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Показывающие измерительные приборы',100001,100000, N'Measuring device')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Весы',100002,100001, N'Scales')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Весы лабораторные',100003,100002, N'Laboratory scales')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Манометры',100004,100001, N'Manometer')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вакуумметр',100005,100004, N'Vacuum gauge')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Барометр',100006,100004, N'Barometer')	
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Электроконтактный манометр',100007,100004, N'Electric contact manometer')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Линейно-угловые',100008,100001, N'Linear-angular')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Глубиномер',100009,100008, N'Depth gauge')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Штангенглубиномер',100015,100009, N'Depth gauge')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Метрошток',100010,100008, N'Measuring staff')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Микрометр',100011,100008, N'Micrometer')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Набор щупов',100012,100008, N'Set of feeler gauges')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Рулетка измерительная',100013,100008, N'Roulette')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Штангенциркуль',100014,100008, N'Calipers')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Угломер',100016,100008, N'Protractor')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Электроизмерительные',100017,100001, N'Еlectric')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Амперметр',100018,100017, N'ammeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ампервольтметр',100019,100018, N'amperevoltmeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Микроамперметр',100020,100018, N'microammeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Миллиамперметр',100021,100018, N'milliammeter')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вольтметр',100022,100017, N'voltmeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вольтамперметр',100023,100022, N'voltamperemeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вольтметр цифровой',100024,100022, N'voltmeter digital')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вольтамперфазометр',100025,100022, N'Voltphasemeter')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Осциллограф',100026,100017, N'oscillograph')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Измеритель сопротивления',100027,100017, N'resistance')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Мегаомметр',100028,100027, N'megohmmeter')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Омметр',100029,100027, N'ohmmeter')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометры',100030,100001, N'Аreometer')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометр для нефти',100031,100030, N'Аreometer-oil')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометр для молока',100032,100030, N'Аreometer-milk')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометр для спирта',100033,100030, N'Аreometer-ethanol')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометр для электролита',100034,100030, N'Аreometer-electrolyte')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Ареометр-сахаромер',100035,100030, N'Аreometer-sugar')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Газоанализаторы',100036,100001, N'Gas analyzers')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Газоанализаторы выхлопных газов',100037,100036, N'Gas analyzers exhausts')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Газоанализаторы предельного содержания О2',100038,100036, N'Gas analyzers O2')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Гигрометр',100039,100036, N'hygrometer')
			INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Гигрометр психрометрический',100040,100039, N'psychrometric hygrometer')	
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Газоанализаторы электронные',100041,100036, N'Gas analyzers electronik')
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Вискозиметры',100042,100001, N'viscometer')

INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Регистрирующие измерительные приборы',100043,100000, N'Registered device')
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Счетчики',100044,100043, N'meter')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Счетчики воды',100045,100044, N'Water meter')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Счетчики эл.энергии',100046,100044, N'electricity meter')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Счетчик-жидкости',100047,100044, N'meter liquid')
		INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Счетчик-ватметр эталонный трехфазный ',100048,100044, N'wattmeter counter')			
	
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Самопишущие',100049,100043, N'Recording')
	INSERT INTO [dbo].[MaterialClass] ([Description],[ID], [ParentID], [Code]) VALUES(N'Печатающие',100050,100043, N'printing')
