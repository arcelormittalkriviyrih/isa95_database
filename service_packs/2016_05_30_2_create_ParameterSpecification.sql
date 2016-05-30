SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
IF OBJECT_ID('dbo.gen_ParameterSpecification', N'SO') IS NULL CREATE SEQUENCE dbo.gen_ParameterSpecification
                                                                   AS INT
                                                                   START WITH 1
                                                                   INCREMENT BY 1
                                                                   NO CACHE;
GO
CREATE TABLE dbo.ParameterSpecification
(ID               INT PRIMARY KEY,
 ParentID         INT NULL,
 Description      NVARCHAR(255) NULL,
 Value            NVARCHAR(50) NOT NULL,
 UnitID           INT NULL,
 WorkDefinitionID INT NULL,
 PropertyType     INT NULL
);
GO
ALTER TABLE dbo.ParameterSpecification
ADD DEFAULT(NEXT VALUE FOR dbo.gen_ParameterSpecification) FOR ID;
GO
ALTER TABLE dbo.ParameterSpecification
WITH CHECK
ADD CONSTRAINT [FK_ParameterSpecification_ParentID] FOREIGN KEY(ParentID) REFERENCES dbo.ParameterSpecification(ID);
GO
ALTER TABLE dbo.ParameterSpecification CHECK CONSTRAINT [FK_ParameterSpecification_ParentID];
GO
ALTER TABLE dbo.ParameterSpecification
WITH CHECK
ADD CONSTRAINT [FK_ParameterSpecification_UnitID] FOREIGN KEY(UnitID) REFERENCES dbo.Unit(ID);
GO
ALTER TABLE dbo.ParameterSpecification CHECK CONSTRAINT [FK_ParameterSpecification_UnitID];
GO
ALTER TABLE dbo.ParameterSpecification
WITH CHECK
ADD CONSTRAINT [FK_ParameterSpecification_PropertyTypes] FOREIGN KEY(PropertyType) REFERENCES dbo.PropertyTypes(ID);
GO
ALTER TABLE dbo.ParameterSpecification CHECK CONSTRAINT [FK_ParameterSpecification_PropertyTypes];
GO
ALTER TABLE dbo.ParameterSpecification
WITH CHECK
ADD CONSTRAINT [FK_ParameterSpecification_WorkDefinitionID] FOREIGN KEY(WorkDefinitionID) REFERENCES dbo.WorkDefinition(ID);
GO
ALTER TABLE dbo.ParameterSpecification CHECK CONSTRAINT [FK_ParameterSpecification_WorkDefinitionID];
GO