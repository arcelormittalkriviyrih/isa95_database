create table OpPackagingRequirement
(
	ID int not null,
	Description nvarchar(50) null,
	PackagingClassID int null,
	PackagingDefinitionID int null,
	PackagingUnitsID int null,
	SegmentRequirementID int null,
	JobOrderID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
	CONSTRAINT PK_OpPackagingRequirement PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpPackagingRequirementProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpPackagingRequirementID int null
	CONSTRAINT PK_OpPackagingRequirementProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationRequirement
(
	ID int not null,
	Description nvarchar(50) null,
	LocationClassID int null,
	LocationDefinitionID int null,
	LocationID int null,
	SegmentRequirementID int null,
	JobOrderID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
		CONSTRAINT PK_OpLocationRequirement PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationRequirementProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpLocationRequirementID int null
	CONSTRAINT PK_OpLocationRequirementProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

Alter table OpPackagingRequirement
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirement_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go 

Alter table OpPackagingRequirement
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirement_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go 

Alter table OpPackagingRequirement
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirement_PackagingUnits FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go

Alter table OpPackagingRequirement
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirement_SegmentRequirement FOREIGN KEY(SegmentRequirementID)
REFERENCES SegmentRequirement (ID)
go

Alter table OpPackagingRequirement
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirement_JobOrder FOREIGN KEY(JobOrderID)
REFERENCES JobOrder (ID)
go

Alter table OpPackagingRequirementProperty
WITH CHECK ADD CONSTRAINT FK_OpPackagingRequirementProperty_OpPackagingRequirement FOREIGN KEY(OpPackagingRequirementID)
REFERENCES OpPackagingRequirement (ID)
go

Alter table OpLocationRequirement
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirement_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go 

Alter table OpLocationRequirement
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirement_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go 

Alter table OpLocationRequirement
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirement_Location FOREIGN KEY(LocationID)
REFERENCES Location (ID)
go

Alter table OpLocationRequirement
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirement_SegmentRequirement FOREIGN KEY(SegmentRequirementID)
REFERENCES SegmentRequirement (ID)
go

Alter table OpLocationRequirement
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirement_JobOrder FOREIGN KEY(JobOrderID)
REFERENCES JobOrder (ID)
go

Alter table OpLocationRequirementProperty
WITH CHECK ADD CONSTRAINT FK_OpLocationRequirementProperty_OpLocationRequirement FOREIGN KEY(OpLocationRequirementID)
REFERENCES OpLocationRequirement (ID)
go
