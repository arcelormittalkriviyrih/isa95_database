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
     )
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
	N'Свойство "'+epr.Description+N'" не задано для весов "'+e.Description +N'" ('+workshop.Description+N'\'+mill.Description+N'\'+side.[Description]+N')'
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment e,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,
          dbo.EquipmentClass ec,
		  dbo.EquipmentClassProperty epr,
          dbo.Equipment mill,
		  dbo.Equipment workshop
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
           AND ec.ID = e.EquipmentClassID
		   AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment
		   AND epr.Value in (N'USED_PRINTER',
								N'SCALES_TYPE',
								N'SCALES_NO',
								N'OPC_DEVICE_NAME')
		   AND NOT EXISTS (select * from EquipmentProperty epv 
								where epv.ClassPropertyID=epr.ID 
									and epv.EquipmentID=e.ID)
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
            N'Нет связи с ПЛК' AS ErrorMessage
     WHERE EXISTS
     (
SELECT NULL
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment e,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,
          dbo.EquipmentClass ec,
		  dbo.EquipmentClassProperty epr,
		  dbo.EquipmentProperty epv,
		  dbo.JobOrder jo
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
           AND ec.ID = e.EquipmentClassID		
		   AND epr.Value = N'OPC_DEVICE_NAME'
		   AND epv.ClassPropertyID=epr.ID 
		   and epv.EquipmentID=e.ID
		   AND jo.WorkType = N'KEPCommands'
		   AND jo.DispatchStatus=N'TODO'   
		   AND epv.Value=  left(Command, len(Command)- charindex('.', reverse(Command)))
		   and DATEDIFF(second, jo.StartTime, CURRENT_TIMESTAMP) > 30 );

GO