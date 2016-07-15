create table OpPackagingSpecification
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	PackagingClassID int null,
	PackagingDefinitionID int null,
	PackagingUnitsID int null,
	OperationsSegmentID int null,
	WorkDefinitionID int null
	CONSTRAINT PK_OpPackagingSpecification PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpPackagingSpecificationProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpPackagingSpecificationID int null
	CONSTRAINT PK_OpPackagingSpecificationProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationSpecification
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	LocationClassID int null,
	LocationDefinitionID int null,
	LocationID int null,
	OperationsSegmentID int null,
	WorkDefinitionID int null
	CONSTRAINT PK_OpLocationSpecification PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationSpecificationProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpLocationSpecificationID int null
	CONSTRAINT PK_OpLocationSpecificationProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

Alter table OpPackagingSpecification
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecification_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go 

Alter table OpPackagingSpecification
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecification_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go

Alter table OpPackagingSpecification
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecification_PackagingUnits FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go     

Alter table OpPackagingSpecification
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecification_OperationSegment FOREIGN KEY(OperationsSegmentID)
REFERENCES OperationsSegment (ID)
go  

Alter table OpPackagingSpecification
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecification_WorkDefinition FOREIGN KEY(WorkDefinitionID)
REFERENCES WorkDefinition (ID)
go

Alter table OpPackagingSpecificationProperty
WITH CHECK ADD CONSTRAINT FK_OpPackagingSpecificationProperty_OpPackagingSpecification FOREIGN KEY(OpPackagingSpecificationID)
REFERENCES OpPackagingSpecification (ID)
go        

Alter table OpLocationSpecification
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecification_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go 

Alter table OpLocationSpecification
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecification_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go

Alter table OpLocationSpecification
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecification_Location FOREIGN KEY(LocationID)
REFERENCES Location (ID)
go  

Alter table OpLocationSpecification
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecification_OperationSegment FOREIGN KEY(OperationsSegmentID)
REFERENCES OperationsSegment (ID)
go 

Alter table OpLocationSpecification
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecification_WorkDefinition FOREIGN KEY(WorkDefinitionID)
REFERENCES WorkDefinition (ID)
go 

Alter table OpLocationSpecificationProperty
WITH CHECK ADD CONSTRAINT FK_OpLocationSpecificationProperty_OpLocationSpecification FOREIGN KEY(OpLocationSpecificationID)
REFERENCES OpLocationSpecification (ID)
go 