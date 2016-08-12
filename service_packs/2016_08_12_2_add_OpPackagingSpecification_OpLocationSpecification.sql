create table OpDocumentationsSpecification
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	DocumentationsClassID int null,
	DocumentationsDefinitionID int null,
	DocumentationsID int null,
	OperationsSegmentID int null,
	WorkDefinitionID int null
	CONSTRAINT PK_OpDocumentationsSpecification PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpDocumentationsSpecificationProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpDocumentationsSpecificationID int null
	CONSTRAINT PK_OpDocumentationsSpecificationProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go



Alter table OpDocumentationsSpecification
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecification_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go 

Alter table OpDocumentationsSpecification
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecification_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go

Alter table OpDocumentationsSpecification
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecification_Documentations FOREIGN KEY(DocumentationsID)
REFERENCES Documentations (ID)
go     

Alter table OpDocumentationsSpecification
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecification_OperationSegment FOREIGN KEY(OperationsSegmentID)
REFERENCES OperationsSegment (ID)
go  

Alter table OpDocumentationsSpecification
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecification_WorkDefinition FOREIGN KEY(WorkDefinitionID)
REFERENCES WorkDefinition (ID)
go

Alter table OpDocumentationsSpecificationProperty
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsSpecificationProperty_OpPDocumentationsSpecification FOREIGN KEY(OpDocumentationsSpecificationID)
REFERENCES OpDocumentationsSpecification (ID)
go        

