--- Project gasCollection, Agbor
--- Insert data to table
SET NOCOUNT ON

INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики', NULL, NULL, NULL, 10000);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики давления', NULL, NULL, 10000, 10001);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики избыточного давления', NULL, NULL, 10001, 10002);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик PMC51', N'Endress+Hauser', NULL, 10002, 10003);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA1EGCGMJA+HB', N'Endress+Hauser', NULL, 10003, 10004);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики абсолютного давления', NULL, NULL, 10001, 10005);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик PMC51', N'Endress+Hauser', NULL, 10005, 10006);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA2SGCGMJA', N'Endress+Hauser', NULL, 10006, 10007);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA2PGCGMJA', N'Endress+Hauser', NULL, 10006, 10008);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA2KGCGMJA+HB', N'Endress+Hauser', NULL, 10006, 10009);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA2SGCRKJA+HB', N'Endress+Hauser', NULL, 10006, 10010);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMC51-AA22IA2SGCGMJA+HB', N'Endress+Hauser', NULL, 10006, 10011);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики температуры', NULL, NULL, 10000, 10012);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик температуры TR10', N'Endress+Hauser', NULL, 10012, 10013);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'TR10-ABA3CASFC3000', N'Endress+Hauser', NULL, 10013, 10014);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'TR10-ABA3CASD43000', N'Endress+Hauser', NULL, 10013, 10015);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'TR10-ABA3CASH43000', N'Endress+Hauser', NULL, 10013, 10016);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'TR10-ABA3CASJ43000', N'Endress+Hauser', NULL, 10013, 10017);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики расхода', NULL, NULL, 10000, 10018);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик расхода по перепаду давления', NULL, NULL, 10018, 10019);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик перепада давления PMD55', N'Endress+Hauser', NULL, 10019, 10020);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMD55-AA22AA67DGCHBJA2A+AI', N'Endress+Hauser', NULL, 10020, 10021);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMD55-AA22AA67FGCHBJA2C+AIHB', N'Endress+Hauser', NULL, 10020, 10022);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMD55-AA22AA27CGCHBJA2A+AIHB', N'Endress+Hauser', NULL, 10020, 10023);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMD55-AA22AA67DGCHBJA2A+AIHB', N'Endress+Hauser', NULL, 10020, 10024);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'PMD55-AA22AA67FGCHBJA2A+AIHB', N'Endress+Hauser', NULL, 10020, 10025);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Ультразвуковой датчик расхода', NULL, NULL, 10018, 10026);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Термомассовый датчик расхода', NULL, NULL, 10018, 10027);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Термомассовый расходомер T-mass 65I', N'Endress+Hauser', NULL, 10027, 10028);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'65I-50AB1BD1AAABCA', N'Endress+Hauser', NULL, 10028, 10029);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'65I-40AB1AD1AAABCA', N'Endress+Hauser', NULL, 10028, 10030);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчики концентрации', NULL, NULL, 10000, 10031);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'Датчик концентрации АГ0011', NULL, NULL, 10031, 10032);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'АГ0011 (кислород,0-1%)', N'Выруский завод газоанализаторов', NULL, 10032, 10033);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'АГ0011 (кислород,0-5%)', N'Выруский завод газоанализаторов', NULL, 10032, 10034);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'АГ0011 (кислород,50-100%)', N'Выруский завод газоанализаторов', NULL, 10032, 10035);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'АГ0011 (кислород, 0-50%)', N'Выруский завод газоанализаторов', NULL, 10032, 10036);
INSERT INTO [dbo].[PhysicalAssetClass](Description, Manufacturer, HierarchyScope, ParentID, ID) VALUES (N'АГ0011 (кислород,95-100%)', N'Выруский завод газоанализаторов', NULL, 10032, 10037);

GO
