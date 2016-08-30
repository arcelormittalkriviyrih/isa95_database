SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
BEGIN TRANSACTION;

insert into [dbo].[WorkflowSpecification] ([Description], Version)
values (N'Test',N'Test');

insert into [dbo].[WorkflowSpecificationNodeType] ([Description])
values (N'Round');
insert into [dbo].[WorkflowSpecificationNodeType] ([Description])
values (N'Square');
insert into [dbo].[WorkflowSpecificationNodeType] ([Description])
values (N'Triangle');

insert into [dbo].[WorkflowSpecificationNode](NodeType, [Description], WorkflowSpecification)
select nt.ID, ROW_NUMBER() OVER (ORDER BY ID), (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationNodeType] nt;

insert into [dbo].[WorkflowSpecificationConnectionType] ([Description])
values (N'Straight');

insert into [dbo].[WorkflowSpecificationConnection]([Description], ConnectionType, FromNodeID, ToNodeID, WorkflowSpecification)
select [Description], ID, 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'1'), 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'2'), 
       (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationConnectionType];

insert into [dbo].[WorkflowSpecificationConnection]([Description], ConnectionType, FromNodeID, ToNodeID, WorkflowSpecification)
select N'Opposite', ID, 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'2'), 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'1'), 
       (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationConnectionType];

insert into [dbo].[WorkflowSpecificationConnection]([Description], ConnectionType, FromNodeID, ToNodeID, WorkflowSpecification)
select N'Self', ID, 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'2'), 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'2'), 
       (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationConnectionType];

insert into [dbo].[WorkflowSpecificationConnection]([Description], ConnectionType, FromNodeID, ToNodeID, WorkflowSpecification)
select N'Single', ID, 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'2'), 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'3'), 
       (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationConnectionType];

insert into [dbo].[WorkflowSpecificationConnection]([Description], ConnectionType, FromNodeID, ToNodeID, WorkflowSpecification)
select N'Back', ID, 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'3'), 
       (SELECT ID FROM [dbo].[WorkflowSpecificationNode] WHERE [Description]=N'1'), 
       (SELECT ws.ID FROM [dbo].[WorkflowSpecification] ws WHERE ws.[Description]=N'Test')
from [dbo].[WorkflowSpecificationConnectionType];

COMMIT;
GO
