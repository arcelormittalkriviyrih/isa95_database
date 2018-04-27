SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO
/*
   View: v_ScalesDetailInfo
    Возвращает данные из контроллера а также расчитывает количество прудков для весов.
	Используется на экране маркиорвщицы.
*/
CREATE VIEW [dbo].[v_ScalesDetailInfo]
AS
     WITH BarWeight
          AS (SELECT CAST(par.[Value] AS FLOAT) PropertyValue,
                     pr.[Value] PropertyType,
                     ep.EquipmentId
              FROM [PropertyTypes] pr,
                   [dbo].[Parameter] par,
                   dbo.[EquipmentProperty] ep
              WHERE pr.[Value] IN(N'BAR_WEIGHT', N'MIN_WEIGHT', N'MAX_WEIGHT', N'BAR_QUANTITY')
              AND pr.ID = par.PropertyType
              AND ep.[ClassPropertyID] = dbo.get_EquipmentClassPropertyByValue(N'JOB_ORDER_ID')
          AND cast(ep.[Value] as nvarchar) = par.JobOrder),
          Kep_Data
          AS (SELECT *
              FROM
              (
                  SELECT ROW_NUMBER() OVER(PARTITION BY kl.[NUMBER_POCKET] ORDER BY kl.[TIMESTAMP] DESC) RowNumber,
                         kl.[WEIGHT_CURRENT],
                         kl.[WEIGHT_STAB],
                         kl.[WEIGHT_ZERO],
                         kl.[COUNT_BAR],
                         kl.[REM_BAR],
                         kl.[AUTO_MANU],
                         kl.[POCKET_LOC],
                         kl.[PACK_SANDWICH],
                         kl.[NUMBER_POCKET],
                         kl.[ALARM],
                         kl.[KEY_MANU],
						 kl.[EN_BUTTON_TARA],
						 kl.[WEIGHT_OK],
						 kl.[PEREBOR]
                  FROM dbo.KEP_logger kl
              ) ww
              WHERE ww.RowNumber = 1)
          SELECT eq.ID AS ID,
		  kd.[NUMBER_POCKET],
                 eq.[Description] AS ScalesName,
                 dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) WEIGHT_CURRENT,
                 kd.WEIGHT_STAB,
                 kd.WEIGHT_ZERO,
                 kd.AUTO_MANU,
                 kd.POCKET_LOC,
                 kd.PACK_SANDWICH,
                 kd.ALARM,
                 kd.KEY_MANU,
				 kd.EN_BUTTON_TARA,
                (select ps.Value
                 from [dbo].[ParameterSpecification] ps
                 where ps.WorkDefinitionID=dbo.get_EquipmentPropertyValue(eq.ID,N'WORK_DEFINITION_ID')
                   and ps.PropertyType=dbo.[get_PropertyTypeIdByValue](N'BUNT_NO')) BUNT_NO,
                 CAST(FLOOR(dbo.get_RoundedWeightByEquipment(kd.WEIGHT_CURRENT, eq.ID) / bw.PropertyValue) AS   INT) RodsQuantity,
                 kd.REM_BAR RodsLeft,
                 ISNULL(CAST(bminW.PropertyValue AS INT), 0) MinWeight,
                 ISNULL(CAST(bmaxW.PropertyValue AS INT), 0) MaxWeight,
                 ISNULL(dbo.get_RoundedWeight(bmaxW.PropertyValue * 1.2, 'UP', 100), dbo.get_EquipmentPropertyValue(eq.ID, N'MAX_WEIGHT')) MaxPossibleWeight,
                 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'SCALES_TYPE'), N'POCKET') SCALES_TYPE,
                 dbo.get_EquipmentPropertyValue(eq.ID, N'PACK_RULE') PACK_RULE,
                 CAST(bQty.PropertyValue AS INT)		BAR_QUANTITY,
                 ISNULL(dbo.get_EquipmentPropertyValue(eq.ID, N'TAKE_WEIGHT_LOCKED'), '0') TAKE_WEIGHT_LOCKED,
				 kd.[WEIGHT_OK],
				 kd.[PEREBOR],
				 (SELECT 1 WHERE EXISTS (SELECT NULL FROM dbo.JobOrder jo,
				 dbo.EquipmentProperty epv,
				 dbo.EquipmentClassProperty epr
				  WHERE epv.EquipmentID=eq.ID 
				  AND ecp.ID = eqp.ClassPropertyID
				  AND ecp.value = N'SCALES_NO'
				  AND jo.WorkType = N'KEPCommands'
																		   AND jo.DispatchStatus=N'ToSend'   
																		   AND CAST(epv.Value as nvarchar)=  left(Command, len(Command)- charindex('.', reverse(Command)))
																		   and DATEDIFF(second, jo.StartTime, CURRENT_TIMESTAMP) > 15 )
						  OR EXISTS (SELECT * from dbo.kep_controller_diag diag,
						  dbo.Equipment side,
						  dbo.EquipmentProperty epv2,
						  dbo.EquipmentClassProperty epr2
						   where side.ID = eq.Equipment 
						   AND epv2.EquipmentID=side.ID
						   AND epv2.ClassPropertyID=epr2.ID and CAST(epr2.Value as nvarchar) = N'CONTROLLER_ID'
						   AND DATEDIFF(second, diag.Controller_Last_Connect,CURRENT_TIMESTAMP)>15 
																			AND (cast(diag.Controller_ID as nvarchar) = CAST(epv2.[Value] as nvarchar)))) Send_OPC_Error
          FROM dbo.Equipment eq
               INNER JOIN dbo.EquipmentProperty eqp ON(eqp.EquipmentID = eq.ID)
               INNER JOIN dbo.EquipmentClassProperty ecp ON(ecp.ID = eqp.ClassPropertyID
                                                            AND ecp.value = N'SCALES_NO')
			  -- INNER JOIN dbo.EquipmentProperty epv ON (epv.EquipmentID=eq.ID)
			   --INNER JOIN dbo.EquipmentClassProperty epr ON (epv.ClassPropertyID=epr.ID and CAST(epr.Value as nvarchar) = N'OPC_DEVICE_NAME')
			   --INNER JOIN dbo.Equipment side ON (side.ID = eq.Equipment)
			   --INNER JOIN dbo.EquipmentProperty epv2 ON (epv2.EquipmentID=side.ID)
			   --INNER JOIN dbo.EquipmentClassProperty epr2 ON (epv2.ClassPropertyID=epr2.ID and CAST(epr2.Value as nvarchar) = N'CONTROLLER_ID')
               LEFT OUTER JOIN Kep_Data kd ON(ISNUMERIC(eqp.value) = 1 AND kd.[NUMBER_POCKET] = CAST(eqp.value AS INT))
               LEFT OUTER JOIN BarWeight bw ON bw.EquipmentId = eq.ID AND bw.PropertyType = N'BAR_WEIGHT'
               LEFT OUTER JOIN BarWeight bminW ON bminW.EquipmentId = eq.ID AND bminW.PropertyType = N'MIN_WEIGHT'
               LEFT OUTER JOIN BarWeight bmaxW ON bmaxW.EquipmentId = eq.ID AND bmaxW.PropertyType = N'MAX_WEIGHT'
               LEFT OUTER JOIN BarWeight bQty ON bQty.EquipmentId = eq.ID AND bQty.PropertyType = N'BAR_QUANTITY';
GO

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
		   AND dbo.get_EquipmentPropertyValue(e.ID,N'SCALES_TYPE')!=N'MANUAL'
		   AND epr.Value in (N'USED_PRINTER',
								N'SCALES_TYPE',
								N'SCALES_NO',
								N'OPC_DEVICE_NAME')
		   AND NOT EXISTS (select * from EquipmentProperty epv 
								where epv.ClassPropertyID=epr.ID 
									and epv.EquipmentID=e.ID)
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
		   AND dbo.get_EquipmentPropertyValue(e.ID,N'SCALES_TYPE')=N'MANUAL'
		   AND epr.Value in (N'USED_PRINTER',
								N'SCALES_TYPE',
								N'SCALES_NO')
		   AND NOT EXISTS (select * from EquipmentProperty epv 
								where epv.ClassPropertyID=epr.ID 
									and epv.EquipmentID=e.ID)
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
            N'Команды не отправляются в ПЛК' AS ErrorMessage
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
		   AND jo.DispatchStatus=N'ToSend'   
		   AND epv.Value=  left(Command, len(Command)- charindex('.', reverse(Command)))
		   and DATEDIFF(second, jo.StartTime, CURRENT_TIMESTAMP) > 30 )
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
	N'Пропало питание на ПЛК для '+workshop.Description+N'\'+mill.Description+N'\'+side.[Description]
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,          
          dbo.Equipment mill,
		  dbo.Equipment workshop,
		  dbo.EquipmentProperty esp,
		  dbo.kep_controller_diag diag
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.get_CurrentPerson()
           AND ep.Value = pp.Value
           AND ecp.Value = 'SIDE_ID'
           AND ep.EquipmentID = side.ID
           AND ep.ClassPropertyID = ecp.ID
           AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment		   
		   AND esp.EquipmentID = side.ID 
		   and esp.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' )
		   AND cast(diag.Controller_ID as nvarchar) = esp.[Value]
		   AND diag.UPS_FAIL=1
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
	N'Нет связи с ПЛК для '+workshop.Description+N'\'+mill.Description+N'\'+side.[Description]
     FROM dbo.Equipment side
		  INNER JOIN dbo.EquipmentProperty ep ON (ep.EquipmentID = side.ID)
		  INNER JOIN dbo.EquipmentClassProperty ecp ON (ep.ClassPropertyID = ecp.ID AND ecp.Value = 'SIDE_ID')
		  INNER JOIN dbo.PersonProperty pp ON (ep.Value = pp.Value)			
          INNER JOIN dbo.Person p ON (pp.PersonID = p.ID)
		  INNER JOIN dbo.PersonnelClassProperty pcp ON (pcp.ID = pp.ClassPropertyID AND pcp.Value = 'WORK_WITH')
		  INNER JOIN dbo.Equipment mill ON (mill.id = side.Equipment)
		  INNER JOIN dbo.Equipment workshop ON (workshop.id=mill.Equipment)
		  INNER JOIN dbo.EquipmentProperty esp ON (esp.EquipmentID = side.ID AND esp.ClassPropertyID=dbo.get_EquipmentClassPropertyByValue( N'CONTROLLER_ID' ))
		  LEFT OUTER JOIN dbo.kep_controller_diag diag ON (cast(diag.Controller_ID as nvarchar) = esp.[Value])
     WHERE p.ID = dbo.get_CurrentPerson()           
           AND (DATEDIFF(second, diag.Controller_Last_Connect,CURRENT_TIMESTAMP)>15 OR diag.Controller_Last_Connect IS NULL)
UNION
SELECT ABS(CHECKSUM(NEWID())) AS ID,
	N'Свойство "'+epr.Description+N'" не задано для стороны стана "'+side.Description +N'" ('+workshop.Description+N'\'+mill.Description+N')'
     FROM dbo.Person p,
          dbo.PersonProperty pp,
          dbo.PersonnelClassProperty pcp,
          dbo.Equipment side,
          dbo.EquipmentClassProperty ecp,
          dbo.EquipmentProperty ep,
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
           AND mill.id = side.Equipment
		   AND workshop.id=mill.Equipment
		   AND epr.Value in (N'CONTROLLER_ID')
		   AND NOT EXISTS (select * from EquipmentProperty epv 
								where epv.ClassPropertyID=epr.ID 
									and epv.EquipmentID=side.ID);

GO