create table OpDocumentationsCapability
(
	ID int not null,
	Description nvarchar(50) null,
	DocumentationsClassID int null,
	DocumentationsDefinitionID int null,
	DocumentationsID int null,
	OperationsCapabilityID int null,
	ProcessSegmentCapabilityID int null,
	WorkCapabilityID int null,
	WorkMasterCapabilityID int null,
	CapabilityType nvarchar(50) null,
	Reason nvarchar(50) null,
	ConfidenceFactor nvarchar(50) null,
	StartTime datetime,
	EndTime datetime,
	Quantity int not null,
	QuantityUnitOfMeasure nvarchar(50) null
	CONSTRAINT PK_OpDocumentationsCapability PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpDocumentationsCapabilityProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpDocumentationsCapabilityID int null
	CONSTRAINT PK_OpDocumentationsCapabilityProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go



Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go 

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go 

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_Documentations FOREIGN KEY(DocumentationsID)
REFERENCES Documentations (ID)
go

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_OperationsCapability FOREIGN KEY(OperationsCapabilityID)
REFERENCES OperationsCapability (ID)
go 

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_ProcessSegmentCapability FOREIGN KEY(ProcessSegmentCapabilityID)
REFERENCES ProcessSegmentCapability (ID)
go

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_WorkCapability FOREIGN KEY(WorkCapabilityID)
REFERENCES WorkCapability (ID)
go  

Alter table OpDocumentationsCapability
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapability_WorkMasterCapability FOREIGN KEY(WorkMasterCapabilityID)
REFERENCES WorkMasterCapability (ID)
go  

Alter table OpDocumentationsCapabilityProperty
WITH CHECK ADD CONSTRAINT FK_OpDocumentationsCapabilityProperty_OpDocumentationsCapability FOREIGN KEY(OpDocumentationsCapabilityID)
REFERENCES OpDocumentationsCapability (ID)
go  

