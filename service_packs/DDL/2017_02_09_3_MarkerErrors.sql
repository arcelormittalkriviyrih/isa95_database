SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MarkerErrors', N'V') IS NOT NULL
   DROP VIEW dbo.v_MarkerErrors;
GO
/*
   View: v_MarkerErrors
    Возвращает список ошибок в системе для маркировщицы.
*/
CREATE VIEW [dbo].[v_MarkerErrors]
AS
     SELECT ABS(CHECKSUM(NEWID())) AS ID,
            N'Нет связи с САП' AS ErrorMessage
     WHERE EXISTS
     (
         SELECT NULL
         FROM [dbo].[MaterialLot] AS ml
         WHERE DATEDIFF(second, ml.CreateTime, CURRENT_TIMESTAMP) > 30
               AND ml.[Quantity] != 0
               AND EXISTS
         (
             SELECT NULL
             FROM JobOrder AS o,
                  [dbo].[Parameter] AS p,
                  [dbo].[PropertyTypes] AS pt
             WHERE o.ID = p.JobOrder
                   AND p.PropertyType = pt.ID
                   AND pt.[Value] = N'MaterialLotID'
                   AND o.WorkType = N'SAPExport'
                   AND o.DispatchStatus = N'TODO'
                   AND p.[Value] = ml.[ID]
         )
               AND EXISTS
         (
             SELECT NULL
             FROM dbo.Person p,
                  dbo.PersonProperty pp,
                  dbo.PersonnelClassProperty pcp,
                  dbo.Equipment side,
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
                   AND side.id = dbo.get_SideIdByMaterialLotID(ml.[ID])
         )
     );

GO