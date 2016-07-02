alter table OperationsDefinition
drop constraint FK_OperationsClass_OperationsDefinition;
go

create table OperationsClassification
(
	ID int not null,
	Description nvarchar(50) null,
	OperationsClassID int not null,
	OperationsDefinitionID int not null
	CONSTRAINT PK_OperationsClassification PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

alter table OperationsClassification
WITH CHECK ADD CONSTRAINT FK_OperationsClassification_OperationsClass FOREIGN KEY(OperationsClassID)
REFERENCES OperationsClass (ID)
go

Alter table OperationsClassification
WITH CHECK ADD CONSTRAINT FK_OperationsClassification_OperationsDefinition FOREIGN KEY(OperationsDefinitionID)
REFERENCES OperationsDefinition (ID)
go   