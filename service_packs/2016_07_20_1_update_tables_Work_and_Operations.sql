alter table WorkClass
alter column OperationsClassID int null
go

alter table WorkClass
alter column Description nvarchar(50) null
go

alter table WorkClassification
alter column WorkClassID int null
go

alter table WorkClassification
alter column WorkDefinitionID int null
go

alter table WorkDefinition 
alter column WorkClassID int null
go

alter table OperationsClass
alter column Description nvarchar(50) null
go

alter table OperationsClassification
alter column OperationsClassID int null
go

alter table OperationsClassification
alter column OperationsDefinitionID int null
go

alter table OperationsDefinition
WITH CHECK ADD CONSTRAINT FK_OperationsDefinition_OperationsClass FOREIGN KEY(OperationsClassID)
REFERENCES OperationsClass (ID)
go

alter table WorkDefinition
WITH CHECK ADD CONSTRAINT FK_WorkDefinition_WorkClass FOREIGN KEY(WorkClassID)
REFERENCES WorkClass (ID)
go