create table OpPackagingActual
(
	ID int not null,
	Description nvarchar(50) null,
	PackagingClassID int null,
	PackagingDefinitionID int null,
	PackagingUnitsID int null,
	SegmentResponseID int null,
	JobResponseID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
	CONSTRAINT PK_OpPackagingActual PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpPackagingActualProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpPackagingActualID int null
	CONSTRAINT PK_OpPackagingActualProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationActual
(
	ID int not null,
	Description nvarchar(50) null,
	LocationClassID int null,
	LocationDefinitionID int null,
	LocationID int null,
	SegmentResponseID int null,
	JobResponseID int null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null
		CONSTRAINT PK_OpLocationActual PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table OpLocationActualProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Quantity int null,
	QuantityUnitOfMeasure nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitOfMeasure nvarchar(50) null,
	OpLocationActualID int null
	CONSTRAINT PK_OpLocationActualProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

Alter table OpPackagingActual
WITH CHECK ADD CONSTRAINT FK_OpPackagingActual_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go 

Alter table OpPackagingActual
WITH CHECK ADD CONSTRAINT FK_OpPackagingActual_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go 

Alter table OpPackagingActual
WITH CHECK ADD CONSTRAINT FK_OpPackagingActual_PackagingUnits FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go

Alter table OpPackagingActual
WITH CHECK ADD CONSTRAINT FK_OpPackagingActual_SegmentResponse FOREIGN KEY(SegmentResponseID)
REFERENCES SegmentResponse (ID)
go

Alter table OpPackagingActual
WITH CHECK ADD CONSTRAINT FK_OpPackagingActual_JobResponce FOREIGN KEY(JobResponseID)
REFERENCES JobResponse (ID)
go

Alter table OpPackagingActualProperty
WITH CHECK ADD CONSTRAINT FK_OpPackagingActualProperty_OpPackagingActual FOREIGN KEY(OpPackagingActualID)
REFERENCES OpPackagingActual (ID)
go

Alter table OpLocationActual
WITH CHECK ADD CONSTRAINT FK_OpLocationActual_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go 

Alter table OpLocationActual
WITH CHECK ADD CONSTRAINT FK_OpLocationActual_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go 

Alter table OpLocationActual
WITH CHECK ADD CONSTRAINT FK_OpLocationActual_Location FOREIGN KEY(LocationID)
REFERENCES Location (ID)
go

Alter table OpLocationActual
WITH CHECK ADD CONSTRAINT FK_OpLocationActual_SegmentResponse FOREIGN KEY(SegmentResponseID)
REFERENCES SegmentResponse (ID)
go

Alter table OpLocationActual
WITH CHECK ADD CONSTRAINT FK_OpLocationActual_JobResponse FOREIGN KEY(JobResponseID)
REFERENCES JobResponse (ID)
go

Alter table OpLocationActualProperty
WITH CHECK ADD CONSTRAINT FK_OpLocationActualProperty_OpLocationActual FOREIGN KEY(OpLocationActualID)
REFERENCES OpLocationActual (ID)
go
