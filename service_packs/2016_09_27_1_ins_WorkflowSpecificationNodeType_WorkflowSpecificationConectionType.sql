--------------------------------------------------------------
/*
Заполнение таблиц WorkflowSpecificationNodeType, WorkflowSpecificationConnectionType
данными 
по проекту Система упрвления операциями СЦиО
*/
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100000, N'Event')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100001, N'Input')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100002, N'Output')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100003, N'Data store')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100004, N'Pool (swimlane)')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100005, N'Lane (swimlane)')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100006, N'Task')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100007, N'Transaction')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100008, N'Event sub-process')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100009, N'Call activity')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100010, N'Exclusive gateway')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100011, N'Event-based gateway')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100012, N'Parallel gateway')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100013, N'Inclusive gateway')
INSERT INTO [dbo].[WorkflowSpecificationNodeType] ([ID], [Description]) VALUES( 100014, N'Complex gateway')

INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100000, N'Sequence flow')
INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100001, N'Default flow')
INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100002, N'Conditional flow')
INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100003, N'Message flow')
INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100004, N'Conversation link')
INSERT INTO [dbo].[WorkflowSpecificationConnectionType] ([ID], [Description]) VALUES( 100005, N'Forked conversation link')