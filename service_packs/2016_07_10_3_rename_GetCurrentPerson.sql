SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.getCurrentPerson', N'FN') IS NOT NULL
    DROP FUNCTION dbo.getCurrentPerson;
GO

IF OBJECT_ID(N'dbo.get_CurrentPerson', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_CurrentPerson;
GO

CREATE FUNCTION dbo.get_CurrentPerson
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


IF OBJECT_ID('dbo.v_AvailableSides', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableSides];
GO

CREATE VIEW [dbo].[v_AvailableSides]
AS
     SELECT DISTINCT
            side.ID,
            workshop.Description+' \ '+mill.Description+' \ '+side.[Description] [Description]
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment side,
          dbo.Equipment mill,
		  dbo.Equipment workshop,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.get_CurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment;
GO


IF OBJECT_ID('dbo.v_AvailableScales', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableScales];
GO

CREATE VIEW [dbo].[v_AvailableScales]
AS
     SELECT DISTINCT
            e.ID,
            e.Description,
            side.ID sideID
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment e,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,
          dbo.EquipmentClass ec
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.get_CurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND side.ID = e.Equipment
           AND ec.Code = N'SCALES'
           AND ec.ID = e.EquipmentClassID;
GO