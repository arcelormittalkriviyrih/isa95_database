create table OpPackagingCapability
(
	ID int not null,
	Description nvarchar(50) null,
	PackagingClassID int null,
	PackagingDefinitionID int null,
	PackagingUnitsID int null,
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
	CONSTRAINT PK_OpPackagingCapability PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpPackagingCapabilityProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpPackagingCapabilityID int null
	CONSTRAINT PK_OpPackagingCapabilityProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationCapability
(
	ID int not null,
	Description nvarchar(50) null,
	LocationClassID int null,
	LocationDefinitionID int null,
	LocationID int null,
	OperationsCapabilityID int null,
	ProcessSegmentCapabilityID int null,
	WorkCapabilityID int null,
	WorkMasterCapabilityID int null,
	CapabilityType nvarchar(50) null,
	Reason nvarchar(50) null,
	ConfidenceFactor nvarchar(50) null,
	StartTime datetime,
	EndTime datetime,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
		CONSTRAINT PK_OpLocationCapability PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationCapabilityProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpLocationCapabilityID int null
	CONSTRAINT PK_OpLocationCapabilityProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go 

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go 

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_PackagingUnits FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_OperationCapability FOREIGN KEY(OperationsCapabilityID)
REFERENCES OperationsCapability (ID)
go 

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_ProcessSegmentCapability FOREIGN KEY(ProcessSegmentCapabilityID)
REFERENCES ProcessSegmentCapability (ID)
go

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_WorkCapability FOREIGN KEY(WorkCapabilityID)
REFERENCES WorkCapability (ID)
go  

Alter table OpPackagingCapability
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapability_WorkMasterCapability FOREIGN KEY(WorkMasterCapabilityID)
REFERENCES WorkMasterCapability (ID)
go  

Alter table OpPackagingCapabilityProperty
WITH CHECK ADD CONSTRAINT FK_OpPackagingCapabilityProperty_OpPackagingCapability FOREIGN KEY(OpPackagingCapabilityID)
REFERENCES OpPackagingCapability (ID)
go  

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go 

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_Location FOREIGN KEY(LocationID)
REFERENCES Location (ID)
go  

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_OperationCapability FOREIGN KEY(OperationsCapabilityID)
REFERENCES OperationsCapability (ID)
go

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_ProcessSegmentCapability FOREIGN KEY(ProcessSegmentCapabilityID)
REFERENCES ProcessSegmentCapability (ID)
go

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_WorkCapability FOREIGN KEY(WorkCapabilityID)
REFERENCES WorkCapability (ID)
go  

Alter table OpLocationCapability
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_WorkMasterCapability FOREIGN KEY(WorkMasterCapabilityID)
REFERENCES WorkMasterCapability (ID)
go 

Alter table OpLocationCapabilityProperty
WITH CHECK ADD CONSTRAINT FK_OpLocationCapability_OpLocationCapability FOREIGN KEY(OpLocationCapabilityID)
REFERENCES OpLocationCapability (ID)
go  