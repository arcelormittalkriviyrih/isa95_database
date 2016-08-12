create table OpDocumentationsActual
(
	ID int not null,
	Description nvarchar(50) null,
	DocumentationsClassID int null,
	DocumentationsDefinitionID int null,
	DocumentationsID int null,
	SegmentResponseID int null,
	JobResponseID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
	CONSTRAINT PK_OpDocumentationsActual PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpDocumentationsActualProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpDocumentationsActualID int null
	CONSTRAINT PK_OpDocumentationsActualProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go



Alter table OpDocumentationsActual
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActual_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go 

Alter table OpDocumentationsActual
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActual_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go 

Alter table OpDocumentationsActual
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActual_Documentations FOREIGN KEY(DocumentationsID)
REFERENCES Documentations (ID)
go

Alter table OpDocumentationsActual
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActual_SegmentResponse FOREIGN KEY(SegmentResponseID)
REFERENCES SegmentResponse (ID)
go

Alter table OpDocumentationsActual
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActual_JobResponce FOREIGN KEY(JobResponseID)
REFERENCES JobResponse (ID)
go

Alter table OpDocumentationsActualProperty
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsActualProperty_OpDocumentationsActual FOREIGN KEY(OpDocumentationsActualID)
REFERENCES OpDocumentationsActual (ID)
go

