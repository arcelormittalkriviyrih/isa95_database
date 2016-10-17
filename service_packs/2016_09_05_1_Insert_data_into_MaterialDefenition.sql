--------------------------------------------------------------
/*
Заполнение таблиц MaterialClass, MaterialDefinition данными 
по проектам Копр4, График выплавки 
*/

INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Марка стали', N'3', N'STEEL GRADE')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Жидкая сталь', N'4', N'LIQUID STEEL')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Заготовка BL', N'5', N'INGOT')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Заготовка МНЛЗ', N'6', N'BILLET')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Длина пореза', N'7', N'L')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Коэф.важности заказа', N'8', N'Order Importance')
INSERT INTO MaterialClass
([Description],[ID],[Code])
values( N'Вид лома', N'9', N'Scrap type')

---======================================

INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  101
, N'1',null,null,8,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  102
, N'1.2',null,null,8,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  103
, N'0.5',null,null,8,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  104
, N'0',null,null,8,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  151
, N'смешанный лом  ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  152
, N'чугунный лом   ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  153
, N'оборотный лом  ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  154
, N'скрап          ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  155
, N'брикеты скрап  ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  156
, N'пакеты УЗ      ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  157
, N'пакеты копр.   ',null, 1, 9,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  187
, N'чушковый чугун',null, 2, 9, 152)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  284
, N'скрап.стальной 120-850 с переработки',null, 2, 9, 154)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  380
, N'пакеты УЗ',null, 2, 9, 156)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  381
, N'скрап стальной фракции 20-120',null, 2, 9, 154)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  382
, N'брикеты стального скрапа',null, 2, 9, 155)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  384
, N'лом стальной габаритный с отгрузки',null, 2, 9, 151)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  385
, N'лом легковес подш.3/303 отгр',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  386
, N'скрап ст фракции 120-850 с отгрузки',null, 2, 9, 154)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  387
, N'лом легированный 4/322 с отгрузки',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  389
, N'лом чугунный габаритный с отгрузки',null, 2, 9, 152)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  392
, N'брак стальных слитков с переработки',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  393
, N'недоливы габаритные с переработки',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  394
, N'брак стальной габаритный с переработки',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  395
, N'брак заготовок габаритныы с переработки',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  397
, N'бой чугуна с переработки',null, 2, 9, 152)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  398
, N'скрап стальной габаритный с переработки',null, 2, 9, 154)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  400
, N'пакеты копрового',null, 2, 9, 157)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  401
, N'скрап чугунный габаритный ',null, 2, 9, 152)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  402
, N'обр.габ.перераб',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  403
, N'лом ст.габ.перераб',null, 2, 9, 151)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  410
, N'лом ст/габ пер подр',null, 2, 9, 153)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  412
, N'лом ст/г пер подр отгр',null, 2, 9, 151)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  415
, N'лом ст/г пер подр отгр',null, 2, 9, 151)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1000
, N'SAE1006',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1001
, N'SAE1008',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1002
, N'SAE1010',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1003
, N'СТ3ПС',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1004
, N'СТ3ТРПС',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1005
, N'СТ5ПС',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1006
, N'СТ5СП',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1007
, N'СТ3ГПС',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1010
, N'SAE1006',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1011
, N'СТ5ПС',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1012
, N'SAE1008М',null, 1, 3,null)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1100
, N'СТК 189-3-12-15:2015 от 13.11.2015',null, 2, 3, 1000)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1101
, N'СТК 189-3-12-15:2015 от 13.11.2015',null, 2, 3, 1010)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1102
, N'СТК 189-3-12-09:2015 от 22.07.2015',null, 2, 3, 1004)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1103
, N'СТК 189-3-02-01:2015 от 10.02.2015',null, 2, 3, 1011)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1104
, N'СТК 189-2-13-01:2016 от 05.01.2016',null, 2, 3, 1012)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1200
, N'(Si 0.05-0.1%)',null, 3, 3, 1000)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1201
, N'(Si < 0.05%)',null, 3, 3, 1010)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1203
, N'(Si < 0.1%)',null, 3, 3, 1001)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1204
, N'(C 0.16-0.22%)',null, 3, 3, 1007)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1300
, N'ОНРС',null, 4, 3, 1000)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1301
, N'э',null, 4, 3, 1010)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1302
, N'BS',null, 4, 3, 1004)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1303
, N'э',null, 4, 3, 1005)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1304
, N'ОНРС',null, 4, 3, 1001)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1305
, N'э',null, 4, 3, 1007)
INSERT INTO MaterialDefinition
 ([ID], [Description], [Location], [HierarchyScope], [MaterialClassID], [MaterialDefinitionID])
values(  1306
, N'ОНРС',null, 4, 3, 1012)

GO
