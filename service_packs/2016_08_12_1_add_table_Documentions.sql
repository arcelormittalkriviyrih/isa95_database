create table DocumentationsClass
(
	ID int not null,
	Description nvarchar(50) null,
	ParentID int not null,
	CONSTRAINT PK_DocumentationsClass PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table DocumentationsDefinition
(
	ID int not null,
	Description nvarchar(50) null,
	HierarchyScope nvarchar(50) null,
	DocumentationsClassID int not null,
	CONSTRAINT PK_DocumentationsDefinition PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table Documentations
(
	ID int not null,
	Description nvarchar(50) null,
	Status nvarchar(50) null,
	DocumentationsDefinitionID int not null,
	CONSTRAINT PK_Documentations PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table DocumentationsClassProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	DocumentationsClassProperty int not null,
	DocumentationsClassID int not null,
	CONSTRAINT PK_DocumentationsClassProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table DocumentationsDefinitionProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	DocumentationsClassPropertyID int not null,
	DocumentationsDefinitionProperty int not null,
	DocumentationsDefinitionID int not null,
	CONSTRAINT PK_DocumentationsDefinitionProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go

create table DocumentationsProperty
(
	ID int not null,
	Description nvarchar(50) null,
	Value nvarchar(50) null,
	ValueUnitofMeasure nvarchar(50) null,
	PropertyType nvarchar(50) null,
	DocumentationsDefinitionPropertyID int not null,
	DocumentationsProperty int not null,
	DocumentationsID int not null,
	CONSTRAINT PK_DocumentationsProperty PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
go



alter table DocumentationsClass
WITH CHECK ADD CONSTRAINT FK_DocumentationsClass_DocumentationsClass FOREIGN KEY(ParentID)
REFERENCES DocumentationsClass (ID)
go

alter table DocumentationsDefinition
WITH CHECK ADD CONSTRAINT FK_DocumentationsDefinition_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go

alter table Documentations
WITH CHECK ADD CONSTRAINT FK_Documentations_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go


alter table DocumentationsClassProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsClassProperty_DocumentationsClass FOREIGN KEY(DocumentationsClassID)
REFERENCES DocumentationsClass (ID)
go

alter table DocumentationsClassProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsClassProperty_DocumentationsClassProperty FOREIGN KEY(DocumentationsClassProperty)
REFERENCES DocumentationsClassProperty (ID)
go

alter table DocumentationsDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsDefinitionProperty_DocumentationsClassProperty FOREIGN KEY(DocumentationsClassPropertyID)
REFERENCES DocumentationsClassProperty (ID)
go

alter table DocumentationsDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsDefinitionProperty_DocumentationsDefinitionProperty FOREIGN KEY(DocumentationsDefinitionProperty)
REFERENCES DocumentationsDefinitionProperty (ID)
go

alter table DocumentationsDefinitionProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsDefinitionProperty_DocumentationsDefinition FOREIGN KEY(DocumentationsDefinitionID)
REFERENCES DocumentationsDefinition (ID)
go

alter table DocumentationsProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsProperty_Documentations FOREIGN KEY(DocumentationsID)
REFERENCES Documentations (ID)
go

alter table DocumentationsProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsProperty_DocumentationsDefinitionProperty FOREIGN KEY(DocumentationsDefinitionPropertyID)
REFERENCES DocumentationsDefinitionProperty (ID)
go

alter table DocumentationsProperty
WITH CHECK ADD CONSTRAINT FK_DocumentationsProperty_DocumentationsProperty FOREIGN KEY(DocumentationsProperty)
REFERENCES DocumentationsProperty (ID)
go

