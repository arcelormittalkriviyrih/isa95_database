alter table WorkDefinition
drop constraint FK_WorkClass_WorkDefinition;
go

create table WorkClassification
(
	ID int not null,
	Description nvarchar(50) null,
	WorkClassID int not null,
	WorkDefinitionID int not null
	CONSTRAINT PK_WorkClassification PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

alter table WorkClassification
WITH CHECK ADD CONSTRAINT FK_WorkClassification_WorkClass FOREIGN KEY(WorkClassID)
REFERENCES WorkClass (ID)
go

Alter table WorkClassification
WITH CHECK ADD CONSTRAINT FK_WorkClassification_WorkDefinition FOREIGN KEY(WorkDefinitionID)
REFERENCES WorkDefinition (ID)
go   