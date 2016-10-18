
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'OrgStructure')
	EXEC sp_executesql N'CREATE SCHEMA OrgStructure;';
go

IF OBJECT_ID (N'OrgStructure.OrganizationClass', N'U') IS NULL  
begin 
	create table OrgStructure.OrganizationClass (
		ID int not null,
		Description nvarchar (50) null,
		ParentID int null
		CONSTRAINT PK_OrganizationClass PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.Organization', N'U') IS NULL  
begin 
	create table OrgStructure.Organization (
		ID int not null,
		Description nvarchar (50) null,
		OrganizationClassID int null,
		OrganizationID int null
		CONSTRAINT PK_Organization PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrganizationClassProperty', N'U') IS NULL  
begin 
	create table OrgStructure.OrganizationClassProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrganizationClassPropertyID int null,
		OrganizationClassID int null
		CONSTRAINT PK_OrganizationClassProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrganizationProperty', N'U') IS NULL  
begin 
	create table OrgStructure.OrganizationProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrganizationPropertyID int null,
		OrganizationClassPropertyID int null,
		OrganizationID int null
		CONSTRAINT PK_OrganizationProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrgUnitClass', N'U') IS NULL  
begin
	create table OrgStructure.OrgUnitClass (
		ID int not null,
		Description nvarchar (50) null,
		ParentID int null
		CONSTRAINT PK_OrgUnitClass PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrgUnit', N'U') IS NULL  
begin
	create table OrgStructure.OrgUnit (
		ID int not null,
		Description nvarchar (50) null,
		OrgUnitClassID int null,
		OrgUnitID int null
		CONSTRAINT PK_OrgUnit PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.OrgUnitClassProperty', N'U') IS NULL  
begin
	create table OrgStructure.OrgUnitClassProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrgUnitClassPropertyID int null,
		OrgUnitClassID int null
		CONSTRAINT PK_OrgUnitClassProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrgUnitProperty', N'U') IS NULL  
begin
	create table OrgStructure.OrgUnitProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrgUnitPropertyID int null,
		OrgUnitClassPropertyID int null,
		OrgUnitID int null
		CONSTRAINT PK_OrgUnitProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.ProfessionClass', N'U') IS NULL  
begin
	create table OrgStructure.ProfessionClass (
		ID int not null,
		Description nvarchar (50) null,
		ParentID int null
		CONSTRAINT PK_ProfessionClass PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.Profession', N'U') IS NULL  
begin
	create table OrgStructure.Profession (
		ID int not null,
		Description nvarchar (50) null,
		ProfessionID int null,
		ProfessionClassID int null
		CONSTRAINT PK_Profession PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.EmployeeClass', N'U') IS NULL  
begin
	create table OrgStructure.EmployeeClass (
		ID int not null,
		Description nvarchar (50) null,
		ParentID int null
		CONSTRAINT PK_EmployeeClass PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.Employee', N'U') IS NULL  
begin
	create table OrgStructure.Employee (
		ID int not null,
		Description nvarchar (50) null,
		Location nvarchar (50) null,
		EmployeeClassID int null,
		PersonelName nvarchar (50) null
		CONSTRAINT PK_Employee PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.ProfessionClassProperty', N'U') IS NULL  
begin
	create table OrgStructure.ProfessionClassProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		ProfessionClassPropertyID int null,
		ProfessionClassID int null
		CONSTRAINT PK_ProfessionClassProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.ProfessionProperty', N'U') IS NULL  
begin
	create table OrgStructure.ProfessionProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		ProfessionPropertyID int null,
		ProfessionClassPropertyID int null,
		ProfessionID int null
		CONSTRAINT PK_ProfessionProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.EmployeeClassProperty', N'U') IS NULL  
begin
	create table OrgStructure.EmployeeClassProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		EmployeeClassPropertyID int null,
		EmployeeClassID int null
		CONSTRAINT PK_EmployeeClassProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.EmployeeProperty', N'U') IS NULL  
begin
	create table OrgStructure.EmployeeProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		EmployeePropertyID int null,
		EmployeeClassPropertyID int null,
		EmployeeID int null
		CONSTRAINT PK_EmployeeProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrgItemRelationshipClass', N'U') IS NULL  
begin
	create table OrgStructure.OrgItemRelationshipClass (
		ID int not null,
		Description nvarchar (50) null,
		LLinkEntity nvarchar (50) null,
		RLinkEntity nvarchar (50) null,
		ParentID int null,
		Bdate datetime null,
		Edate datetime null
		CONSTRAINT PK_OrgItemRelationshipClass PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.OrgItemRelationship', N'U') IS NULL  
begin
	create table OrgStructure.OrgItemRelationship (
		ID int not null,
		Description nvarchar (50) null,
		OrgItemRelationshipClassID int null,
		LLink nvarchar (50) null,
		RLink nvarchar (50) null,
		Bdate datetime null,
		Edate datetime null
		CONSTRAINT PK_OrgItemRelationship PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]	
end
go

IF OBJECT_ID (N'OrgStructure.OrgItemRelationshipClassProperty', N'U') IS NULL  
begin
	create table OrgStructure.OrgItemRelationshipClassProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrgItemRelationshipClassPropertyID int null,
		OrgItemRelationshipClassID int null
		CONSTRAINT PK_OrgItemRelationshipClassProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go

IF OBJECT_ID (N'OrgStructure.OrgItemRelationshipProperty', N'U') IS NULL  
begin
	create table OrgStructure.OrgItemRelationshipProperty (
		ID int not null, 
		Description nvarchar (50) null,
		Value nvarchar (50) null,
		OrgItemRelationshipPropertyID int null,
		OrgItemRelationshipClassPropertyID int null,
		OrgItemRelationshipID int null
		CONSTRAINT PK_OrgItemRelationshipProperty PRIMARY KEY CLUSTERED (ID) 
			WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE = OFF,IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
	ON [PRIMARY]
	) 
	ON [PRIMARY]
end
go



IF OBJECT_ID (N'OrgStructure.FK_OrganizationClass_OrganizationClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationClass 
		WITH CHECK ADD CONSTRAINT FK_OrganizationClass_OrganizationClass FOREIGN KEY(ParentID)  
		REFERENCES OrgStructure.OrganizationClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_Organization_OrganizationClass', N'F') IS NULL 
begin
	alter table OrgStructure.Organization 
		WITH CHECK ADD CONSTRAINT FK_Organization_OrganizationClass FOREIGN KEY(OrganizationClassID)  
		REFERENCES OrgStructure.OrganizationClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_Organization_Organization', N'F') IS NULL 
begin
	alter table OrgStructure.Organization 
		WITH CHECK ADD CONSTRAINT FK_Organization_Organization FOREIGN KEY(OrganizationID)  
		REFERENCES OrgStructure.Organization (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrganizationClassProperty_OrganizationClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationClassProperty 
		WITH CHECK ADD CONSTRAINT FK_OrganizationClassProperty_OrganizationClass FOREIGN KEY(OrganizationClassID)  
		REFERENCES OrgStructure.OrganizationClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrganizationClassProperty_OrganizationClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationClassProperty 
		WITH CHECK ADD CONSTRAINT FK_OrganizationClassProperty_OrganizationClassProperty FOREIGN KEY(OrganizationClassPropertyID)  
		REFERENCES OrgStructure.OrganizationClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrganizationProperty_Organization', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationProperty 
		WITH CHECK ADD CONSTRAINT FK_OrganizationProperty_Organization FOREIGN KEY(OrganizationID)  
		REFERENCES OrgStructure.Organization (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrganizationProperty_OrganizationProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationProperty 
		WITH CHECK ADD CONSTRAINT FK_OrganizationProperty_OrganizationProperty FOREIGN KEY(OrganizationPropertyID)  
		REFERENCES OrgStructure.OrganizationProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrganizationProperty_OrganizationClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrganizationProperty 
		WITH CHECK ADD CONSTRAINT FK_OrganizationProperty_OrganizationClassProperty FOREIGN KEY(OrganizationClassPropertyID)  
		REFERENCES OrgStructure.OrganizationClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitClass_OrgUnitClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitClass
		WITH CHECK ADD CONSTRAINT FK_OrgUnitClass_OrgUnitClass FOREIGN KEY(ParentID)  
		REFERENCES OrgStructure.OrgUnitClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnit_OrgUnitClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnit
		WITH CHECK ADD CONSTRAINT FK_OrgUnit_OrgUnitClass FOREIGN KEY(OrgUnitClassID)  
		REFERENCES OrgStructure.OrgUnitClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnit_OrgUnit', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnit
		WITH CHECK ADD CONSTRAINT FK_OrgUnit_OrgUnit FOREIGN KEY(OrgUnitID)  
		REFERENCES OrgStructure.OrgUnit (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitClassProperty_OrgUnitClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitClassProperty
		WITH CHECK ADD CONSTRAINT FK_OrgUnitClassProperty_OrgUnitClassProperty FOREIGN KEY(OrgUnitClassPropertyID)  
		REFERENCES OrgStructure.OrgUnitClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitClassProperty_OrgUnitClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitClassProperty
		WITH CHECK ADD CONSTRAINT FK_OrgUnitClassProperty_OrgUnitClass FOREIGN KEY(OrgUnitClassID)  
		REFERENCES OrgStructure.OrgUnitClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitProperty_OrgUnitProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitProperty
		WITH CHECK ADD CONSTRAINT FK_OrgUnitProperty_OrgUnitProperty FOREIGN KEY(OrgUnitPropertyID)  
		REFERENCES OrgStructure.OrgUnitProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitProperty_OrgUnitClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitProperty
		WITH CHECK ADD CONSTRAINT FK_OrgUnitProperty_OrgUnitClassProperty FOREIGN KEY(OrgUnitClassPropertyID)  
		REFERENCES OrgStructure.OrgUnitClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgUnitProperty_OrgUnit', N'F') IS NULL 
begin
	alter table OrgStructure.OrgUnitProperty
		WITH CHECK ADD CONSTRAINT FK_OrgUnitProperty_OrgUnit FOREIGN KEY(OrgUnitID)  
		REFERENCES OrgStructure.OrgUnit (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionClass_ProfessionClass', N'F') IS NULL 
begin
	alter table OrgStructure.ProfessionClass
		WITH CHECK ADD CONSTRAINT FK_ProfessionClass_ProfessionClass FOREIGN KEY(ParentID)  
		REFERENCES OrgStructure.ProfessionClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_Profession_Profession', N'F') IS NULL 
begin
	alter table OrgStructure.Profession
		WITH CHECK ADD CONSTRAINT FK_Profession_Profession FOREIGN KEY(ProfessionID)  
		REFERENCES OrgStructure.Profession (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_Profession_ProfessionClass', N'F') IS NULL 
begin
	alter table OrgStructure.Profession
		WITH CHECK ADD CONSTRAINT FK_Profession_ProfessionClass FOREIGN KEY(ProfessionClassID)  
		REFERENCES OrgStructure.ProfessionClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeClass_EmpoloyeeClass', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeClass
		WITH CHECK ADD CONSTRAINT FK_EmployeeClass_EmployeeClass FOREIGN KEY(ParentID)  
		REFERENCES OrgStructure.EmployeeClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_Employee_EmpolyeeClass', N'F') IS NULL 
begin
	alter table OrgStructure.Employee
		WITH CHECK ADD CONSTRAINT FK_Employee_EmployeeClass FOREIGN KEY(EmployeeClassID)  
		REFERENCES OrgStructure.EmployeeClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionClasProperty_ProfessionClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.ProfessionClassProperty
		WITH CHECK ADD CONSTRAINT FK_ProfessionClassProperty_ProfessionClassProperty FOREIGN KEY(ProfessionClassPropertyID)  
		REFERENCES OrgStructure.ProfessionClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionClasProperty_ProfessionClass', N'F') IS NULL 
begin
	alter table OrgStructure.ProfessionClassProperty
		WITH CHECK ADD CONSTRAINT FK_ProfessionClassProperty_ProfessionClass FOREIGN KEY(ProfessionClassID)  
		REFERENCES OrgStructure.ProfessionClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionProperty_ProfessionProperty', N'F') IS NULL 
begin
	alter table OrgStructure.ProfessionProperty
		WITH CHECK ADD CONSTRAINT FK_ProfessionProperty_ProfessionProperty FOREIGN KEY(ProfessionPropertyID)  
		REFERENCES OrgStructure.ProfessionProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionProperty_ProfessionClassProperty', N'F') IS NULL
begin
	alter table OrgStructure.ProfessionProperty
		WITH CHECK ADD CONSTRAINT FK_ProfessionProperty_ProfessionClassProperty FOREIGN KEY(ProfessionClassPropertyID)  
		REFERENCES OrgStructure.ProfessionClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_ProfessionProperty_Profession', N'F') IS NULL 
begin
	alter table OrgStructure.ProfessionProperty
		WITH CHECK ADD CONSTRAINT FK_ProfessionProperty_Profession FOREIGN KEY(ProfessionID)  
		REFERENCES OrgStructure.Profession (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeClassProperty_EmployeeClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeClassProperty
		WITH CHECK ADD CONSTRAINT FK_EmployeeClassProperty_EmployeeClassProperty FOREIGN KEY(EmployeeClassPropertyID)  
		REFERENCES OrgStructure.EmployeeClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeClassProperty_EmployeeClass', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeClassProperty
		WITH CHECK ADD CONSTRAINT FK_EmployeeClassProperty_EmployeeClass FOREIGN KEY(EmployeeClassID)  
		REFERENCES OrgStructure.EmployeeClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeProperty_EmployeeProperty', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeProperty
		WITH CHECK ADD CONSTRAINT FK_EmployeeProperty_EmployeeProperty FOREIGN KEY(EmployeePropertyID)  
		REFERENCES OrgStructure.EmployeeProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeProperty_EmployeeClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeProperty
		WITH CHECK ADD CONSTRAINT FK_EmployeeProperty_EmployeeClassProperty FOREIGN KEY(EmployeeClassPropertyID)  
		REFERENCES OrgStructure.EmployeeClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_EmployeeProperty_Employee', N'F') IS NULL 
begin
	alter table OrgStructure.EmployeeProperty
		WITH CHECK ADD CONSTRAINT FK_EmployeeProperty_Employee FOREIGN KEY(EmployeeID)  
		REFERENCES OrgStructure.Employee (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipClass_OrgItemRelationshipClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipClass
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipClass_OrgItemRelationshipClass FOREIGN KEY(ParentID)  
		REFERENCES OrgStructure.OrgItemRelationshipClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationship_OrgItemRelationshipClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationship
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationship_OrgItemRelationshipClass FOREIGN KEY(OrgItemRelationshipClassID)  
		REFERENCES OrgStructure.OrgItemRelationshipClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipClassProperty_OrgItemRelationshipClass', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipClassProperty
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipClassProperty_OrgItemRelationshipClass FOREIGN KEY(OrgItemRelationshipClassID)  
		REFERENCES OrgStructure.OrgItemRelationshipClass (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipClassProperty_OrgItemRelationshipClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipClassProperty
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipClassProperty_OrgItemRelationshipClassProperty FOREIGN KEY(OrgItemRelationshipClassPropertyID)  
		REFERENCES OrgStructure.OrgItemRelationshipClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipProperty_OrgItemRelationshipProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipProperty
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipProperty_OrgItemRelationshipProperty FOREIGN KEY(OrgItemRelationshipPropertyID)  
		REFERENCES OrgStructure.OrgItemRelationshipProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipProperty_OrgItemRelationshipClassProperty', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipProperty
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipProperty_OrgItemRelationshipClassProperty FOREIGN KEY(OrgItemRelationshipClassPropertyID)  
		REFERENCES OrgStructure.OrgItemRelationshipClassProperty (ID)
end
go

IF OBJECT_ID (N'OrgStructure.FK_OrgItemRelationshipProperty_OrgItemRelationship', N'F') IS NULL 
begin
	alter table OrgStructure.OrgItemRelationshipProperty
		WITH CHECK ADD CONSTRAINT FK_OrgItemRelationshipProperty_OrgItemRelationship FOREIGN KEY(OrgItemRelationshipID)  
		REFERENCES OrgStructure.OrgItemRelationship (ID)
end
go