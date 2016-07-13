create table PackagingClass
(
	ID int not null,
	Description nvarchar(50) null,
	ParentID int not null,
	CONSTRAINT PK_PackagingClass PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table PackagingDefinition
(
	ID int not null,
	Description nvarchar(50) null,
	HierarchyScope nvarchar(50) null,
	PackagingClassID int not null,
	CONSTRAINT PK_PackagingDefinition PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table PackagingUnits
(
	ID int not null,
	Description nvarchar(50) null,
	Status nvarchar(50) null,
	PackagingDefinitionID int not null,
	Location int not null,
	CONSTRAINT PK_PackagingUnits PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table PackagingClassProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	PackagingClassProperty int not null,
	PackagingClassID int not null,
	CONSTRAINT PK_PackagingClassProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table PackagingDefinitionProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	PackagingClassPropertyID int not null,
	PackagingDefinitionProperty int not null,
	PackagingDefinitionID int not null,
	CONSTRAINT PK_PackagingDefinitionProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table PackagingUnitsProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	PackagingDefinitionPropertyID int not null,
	PackagingUnitsProperty int not null,
	PackagingUnitsID int not null,
	CONSTRAINT PK_PackagingProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table LocationClass
(
	ID int not null,
	Description nvarchar(50) null,
	ParentID int not null,
	CONSTRAINT PK_LocationClass PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table LocationDefinition
(
	ID int not null,
	Description nvarchar(50) null,
	HierarchyScope  nvarchar(50) null,
	LocationClassID int not null,
	CONSTRAINT PK_LocationDefinition PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table Location
(
	ID int not null,
	Description nvarchar(50) null,
	Status nvarchar(50) null,
	LocationDefinitionID int not null,
	CONSTRAINT PK_Location PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table LocationClassProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	LocationClassProperty int not null,
	LocationClassID int not null,
	CONSTRAINT PK_LocationClassProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table LocationDefinitionProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	LocationClassPropertyID int not null,
	LocationDefinitionProperty int not null,
	LocationDefinitionID int not null,
	CONSTRAINT PK_LocationDefinitionPropertyn PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table LocationProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	LocationDefinitionPropertyID int not null,
	LocationProperty int not null,
	LocationID int not null,
	CONSTRAINT PK_LocationProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

alter table PackagingClass
WITH CHECK ADD CONSTRAINT FK_PackagingClass_PackagingClass FOREIGN KEY(ParentID)
REFERENCES PackagingClass (ID)
go

alter table PackagingDefinition
WITH CHECK ADD CONSTRAINT FK_PackagingDefinition_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go

alter table PackagingUnits
WITH CHECK ADD CONSTRAINT FK_PackagingUnits_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go

alter table PackagingUnits
WITH CHECK ADD CONSTRAINT FK_PackagingUnits_Location FOREIGN KEY(Location)
REFERENCES Location (ID)
go

alter table PackagingClassProperty
WITH CHECK ADD CONSTRAINT FK_PackagingClassProperty_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go

alter table PackagingClassProperty
WITH CHECK ADD CONSTRAINT FK_PackagingClassProperty_PackagingClassProperty FOREIGN KEY(PackagingClassProperty)
REFERENCES PackagingClassProperty (ID)
go

alter table PackagingDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_PackagingDefinitionProperty_PackagingClassProperty FOREIGN KEY(PackagingClassPropertyID)
REFERENCES PackagingClassProperty (ID)
go

alter table PackagingDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_PackagingDefinitionProperty_PackagingDefinitionProperty FOREIGN KEY(PackagingDefinitionProperty)
REFERENCES PackagingDefinitionProperty (ID)
go

alter table PackagingDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_PackagingDefinitionProperty_PackagingDefinition FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go

alter table PackagingUnitsProperty
WITH CHECK ADD CONSTRAINT FK_PackagingUnitsProperty_PackagingUnits FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go

alter table PackagingUnitsProperty
WITH CHECK ADD CONSTRAINT FK_PackagingUnitsProperty_PackagingDefinitionProperty FOREIGN KEY(PackagingDefinitionPropertyID)
REFERENCES PackagingDefinitionProperty (ID)
go

alter table PackagingUnitsProperty
WITH CHECK ADD CONSTRAINT FK_PackagingUnitsProperty_PackagingUnitsProperty FOREIGN KEY(PackagingUnitsProperty)
REFERENCES PackagingUnitsProperty (ID)
go

alter table LocationClass
WITH CHECK ADD CONSTRAINT FK_LocationClass_LocationClass FOREIGN KEY(ParentID)
REFERENCES LocationClass (ID)
go

alter table LocationDefinition
WITH CHECK ADD CONSTRAINT FK_LocationDefinition_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go

alter table Location
WITH CHECK ADD CONSTRAINT FK_Location_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go

alter table LocationProperty
WITH CHECK ADD CONSTRAINT FK_LocationProperty_Location FOREIGN KEY(LocationID)
REFERENCES Location (ID)
go

alter table LocationProperty
WITH CHECK ADD CONSTRAINT FK_LocationProperty_LocationDefinitionProperty FOREIGN KEY(LocationDefinitionPropertyID)
REFERENCES LocationDefinitionProperty (ID)
go

alter table LocationProperty
WITH CHECK ADD CONSTRAINT FK_LocationProperty_LocationProperty FOREIGN KEY(LocationProperty)
REFERENCES LocationProperty (ID)
go

alter table LocationDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_LocationDefinitionProperty_LocationClassProperty FOREIGN KEY(LocationClassPropertyID)
REFERENCES LocationClassProperty (ID)
go

alter table LocationDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_LocationDefinitionProperty_LocationDefinition FOREIGN KEY(LocationDefinitionID)
REFERENCES LocationDefinition (ID)
go

alter table LocationDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_LocationDefinitionProperty_LocationDefinitionProperty FOREIGN KEY(LocationDefinitionProperty)
REFERENCES LocationDefinitionProperty (ID)
go

alter table LocationClassProperty
WITH CHECK ADD CONSTRAINT FK_LocationClassProperty_LocationClass FOREIGN KEY(LocationClassID)
REFERENCES LocationClass (ID)
go

alter table LocationClassProperty
WITH CHECK ADD CONSTRAINT FK_LocationClassProperty_LocationClassProperty FOREIGN KEY(LocationClassProperty)
REFERENCES LocationClassProperty (ID)
go