CREATE SEQUENCE [dbo].[gen_PackagingUnits] 
 AS [int]
START WITH 20673
INCREMENT BY 1
MINVALUE -2147483648
MAXVALUE 2147483647
NO CACHE 
GO

ALTER TABLE [dbo].[PackagingUnits] 
ADD CONSTRAINT DefPackagingUnitsID  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingUnits]) FOR [ID] ; 

------

CREATE SEQUENCE [dbo].[gen_PackagingUnitsProperty] 
 AS [int]
START WITH 62017
INCREMENT BY 1
MINVALUE -2147483648
MAXVALUE 2147483647
NO CACHE 
GO

ALTER TABLE [dbo].[PackagingUnitsProperty] 
ADD CONSTRAINT DefPackagingUnitsPropertyID  DEFAULT (NEXT VALUE FOR [dbo].[gen_PackagingUnitsProperty]) FOR [ID] ; 

------

CREATE SEQUENCE [dbo].[gen_OpPackagingActual] 
 AS [int]
START WITH 1
INCREMENT BY 1
MINVALUE -2147483648
MAXVALUE 2147483647
NO CACHE 
GO

ALTER TABLE [dbo].[OpPackagingActual] 
ADD CONSTRAINT DefOpPackagingActualID  DEFAULT (NEXT VALUE FOR [dbo].[gen_OpPackagingActual]) FOR [ID] ; 

------

CREATE SEQUENCE [dbo].[gen_OpPackagingActualProperty] 
 AS [int]
START WITH 1
INCREMENT BY 1
MINVALUE -2147483648
MAXVALUE 2147483647
NO CACHE 
GO


ALTER TABLE [dbo].[OpPackagingActualProperty] 
ADD CONSTRAINT defOpPackagingActualPropertyID  DEFAULT (NEXT VALUE FOR [dbo].[gen_OpPackagingActualProperty]) FOR [ID] ; 

GO

