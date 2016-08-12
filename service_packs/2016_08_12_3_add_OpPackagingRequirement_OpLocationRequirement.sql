create table OpDocumentationsRequirement
(
	ID int not null,
	Description nvarchar(50) null,
	DocumentationsClassID int null,
	DocumentationsDefinitionID int null,
	DocumentationsID int null,
	SegmentRequirementID int null,
	JobOrderID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
	CONSTRAINT PK_OpDocumentationsRequirement PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpDocumentationsRequirementProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpDocumentationsRequirementID int null
	CONSTRAINT PK_OpDocumentationsRequirementProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go



Alter table OpDocumentationsRequirement
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirement_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go 

Alter table OpDocumentationsRequirement
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirement_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go 

Alter table OpDocumentationsRequirement
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirement_Documentations FOREIGN KEY(DocumentationsID)
REFERENCES Documentations (ID)
go

Alter table OpDocumentationsRequirement
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirement_SegmentRequirement FOREIGN KEY(SegmentRequirementID)
REFERENCES SegmentRequirement (ID)
go

Alter table OpDocumentationsRequirement
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirement_JobOrder FOREIGN KEY(JobOrderID)
REFERENCES JobOrder (ID)
go

Alter table OpDocumentationsRequirementProperty
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsRequirementProperty_OpDocumentationsRequirement FOREIGN KEY(OpDocumentationsRequirementID)
REFERENCES OpDocumentationsRequirement (ID)
go

