SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
      --     AND p.ID = dbo.getCurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment;
GO