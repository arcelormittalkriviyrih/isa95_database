SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE	@PersonClass_ID int,
	@WORK_WITH_ID int,
	@AD_LOGIN_ID int;

begin

SET @PersonClass_ID=NEXT VALUE FOR [dbo].gen_PersonnelClass


INSERT [dbo].PersonnelClass([ID], [ParentID], [Description]) VALUES (@PersonClass_ID, NULL, N'Маркировщик')

SET @WORK_WITH_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;

INSERT [dbo].[PersonnelClassProperty] ([id], [Description], [Value], [PersonnelClassID]) VALUES (@WORK_WITH_ID, N'Работает с', N'WORK_WITH', @PersonClass_ID)

SET @AD_LOGIN_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
INSERT [dbo].[PersonnelClassProperty] ([id], [Description], [Value], [PersonnelClassID]) VALUES (@AD_LOGIN_ID, N'Active directory login', N'AD_LOGIN', @PersonClass_ID)
END
GO

IF OBJECT_ID(N'dbo.getCurrentPerson', N'FN') IS NOT NULL
    DROP FUNCTION dbo.getCurrentPerson;
GO
CREATE FUNCTION dbo.getCurrentPerson
(
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
     BEGIN
         DECLARE @PersonID INT;
         SELECT @PersonID = p.ID
         FROM dbo.Person p,
              dbo.PersonProperty pp,
              dbo.PersonnelClassProperty pcp
         WHERE pp.PersonID = p.ID
               AND pcp.Value = 'AD_LOGIN'
               AND pcp.ID = pp.ClassPropertyID
               AND pp.Value = SYSTEM_USER;
         RETURN(@PersonID);
     END;
GO

IF OBJECT_ID('dbo.v_AvailableScales', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableScales];
GO

CREATE VIEW [dbo].[v_AvailableScales]
AS
     SELECT e.ID,
            e.Description
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment e
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.getCurrentPerson()
           AND e.ID = pp.Value;
GO


IF OBJECT_ID('dbo.v_ScalesShortInfo', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_ScalesShortInfo];
GO

CREATE VIEW [dbo].[v_ScalesShortInfo]
AS
SELECT ww.EquipmentID as ID,	  
       ww.WEIGHT_CURRENT_VALUE,
	  null as RodsQuanity
FROM (
SELECT eq.ID EquipmentID,
       ROW_NUMBER() OVER(PARTITION BY kl.WEIGHT__FIX_NUMERICID ORDER BY kl.WEIGHT__FIX_TIMESTAMP DESC) RowNumber,
       kl.* 
FROM dbo.Equipment eq
     INNER JOIN dbo.EquipmentProperty eqp ON (eqp.EquipmentID=eq.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'NK')
     INNER JOIN dbo.KEP_logger kl ON (ISNUMERIC(eqp.value)=1 AND kl.WEIGHT__FIX_NUMERICID=CAST(eqp.value AS INT) AND kl.WEIGHT__FIX_TIMESTAMP>=DATEADD(hour,-24,GETDATE()))
) ww
WHERE ww.RowNumber=1
GO