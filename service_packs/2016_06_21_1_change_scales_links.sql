SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
           AND p.ID = dbo.getCurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND side.ID = e.Equipment
           AND ec.Code = N'SCALES'
           AND ec.ID = e.EquipmentClassID;



GO

IF OBJECT_ID('dbo.v_AvailableSides', N'V') IS NOT NULL
    DROP VIEW [dbo].[v_AvailableSides];
GO

CREATE VIEW [dbo].[v_AvailableSides]
AS
     SELECT DISTINCT
            side.ID,
            mill.Description+'\'+side.[Description] [Description]
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment side,
          dbo.Equipment mill,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.getCurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND mill.id = side.Equipment;
GO