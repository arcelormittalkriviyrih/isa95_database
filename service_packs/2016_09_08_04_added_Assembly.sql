CREATE TABLE MaterialAssembliesClass (
	ID INT identity (1,1),
	MaterialClassID INT NULL,
	AssemblyClassID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_MaterialAssembliesClass PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO 

Alter table MaterialAssembliesClass
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesClass_MaterialClass FOREIGN KEY(MaterialClassID)
REFERENCES MaterialClass (ID)
go 

Alter table MaterialAssembliesClass
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesClass_AssemblyClass FOREIGN KEY(AssemblyClassID)
REFERENCES MaterialClass (ID)
go 

CREATE TABLE MaterialAssembliesDefinition (
	ID INT identity (1,1),
	MaterialDefinitionID INT NULL,
	AssemblyDefinitionID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_MaterialAssembliesDefinition PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO

Alter table MaterialAssembliesDefinition
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesDefinition_MaterialDefinition FOREIGN KEY(MaterialDefinitionID)
REFERENCES MaterialDefinition (ID)
go 

Alter table MaterialAssembliesDefinition
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesDefinition_AssemblyDefinition FOREIGN KEY(AssemblyDefinitionID)
REFERENCES MaterialDefinition (ID)
go  

CREATE TABLE MaterialAssembliesLot (
	ID INT identity (1,1),
	MaterialLotID INT NULL,
	AssemblyLotID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_MaterialAssembliesLot PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO 

Alter table MaterialAssembliesLot
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesLot_MaterialLot FOREIGN KEY(MaterialLotID)
REFERENCES MaterialLot (ID)
go 

Alter table MaterialAssembliesLot
WITH CHECK ADD CONSTRAINT FK_MaterialAssembliesLot_AssemblyLot FOREIGN KEY(AssemblyLotID)
REFERENCES MaterialLot (ID)
go

CREATE TABLE PackagingAssembliesClass (
	ID INT identity (1,1),
	PackagingClassID INT NULL,
	AssemblyClassID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_PackagingAssembliesClass PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO

Alter table PackagingAssembliesClass
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesClass_PackagingClass FOREIGN KEY(PackagingClassID)
REFERENCES PackagingClass (ID)
go 

Alter table PackagingAssembliesClass
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesClass_AssemblyClass FOREIGN KEY(AssemblyClassID)
REFERENCES PackagingClass (ID)
go

CREATE TABLE PackagingAssembliesDefinition (
	ID INT identity (1,1) ,
	PackagingDefinitionID INT NULL,
	AssemblyDefinitionID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_PackagingAssembliesDefinition PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO 

Alter table PackagingAssembliesDefinition 
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesDefinition_PackagingDefinition  FOREIGN KEY(PackagingDefinitionID)
REFERENCES PackagingDefinition (ID)
go 

Alter table PackagingAssembliesDefinition
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesDefinition_AssemblyDefinition FOREIGN KEY(AssemblyDefinitionID)
REFERENCES PackagingDefinition (ID)
go

CREATE TABLE PackagingAssembliesUnits (
	ID INT identity (1,1),
	PackagingUnitsID INT NULL,
	AssemblyUnitsID INT NULL,
    AssemblyType NVARCHAR(50) NULL,
    AssemblyRelationship NVARCHAR(50) NULL
CONSTRAINT PK_PackagingAssembliesUnits PRIMARY KEY CLUSTERED (ID) 
	WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]
) 
ON [PRIMARY]
GO 

Alter table PackagingAssembliesUnits 
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesUnits_PackagingUnits  FOREIGN KEY(PackagingUnitsID)
REFERENCES PackagingUnits (ID)
go 

Alter table PackagingAssembliesUnits
WITH CHECK ADD CONSTRAINT FK_PackagingAssembliesUnits_AssemblyUnits FOREIGN KEY(AssemblyUnitsID)
REFERENCES PackagingUnits (ID)
go
