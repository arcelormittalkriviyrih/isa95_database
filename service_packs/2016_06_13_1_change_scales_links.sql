SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
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
          dbo.Equipment e,
		  dbo.EquipmentClassProperty ecp,
		  dbo.EquipmentProperty ep
     WHERE pp.PersonID = p.ID
           AND pcp.Value = 'WORK_WITH'
           AND pcp.ID = pp.ClassPropertyID
           AND p.ID = dbo.getCurrentPerson()
           AND ep.Value = pp.Value
		   AND ecp.Value='SCALES_NO'
		   AND ep.EquipmentID=e.ID
		   AND ep.ClassPropertyID=ecp.ID;
GO

drop view  [dbo].[v_ScalesShortInfo];
go

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
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'CONTROLLER_NO')
     INNER JOIN dbo.KEP_logger kl ON (ISNUMERIC(eqp.value)=1 AND kl.WEIGHT__FIX_NUMERICID=CAST(eqp.value AS INT) AND kl.WEIGHT__FIX_TIMESTAMP>=DATEADD(hour,-1,GETDATE()))
) ww
WHERE ww.RowNumber=1;

GO
