SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


IF OBJECT_ID ('dbo.v_ScalesDetailInfo',N'V') IS NOT NULL
   DROP VIEW dbo.[v_ScalesDetailInfo];
GO

CREATE VIEW [dbo].v_ScalesDetailInfo
AS
SELECT ww.EquipmentID as ID,
	   ww.[Description] as ScalesName,	   	  
       ww.WEIGHT_CURRENT_VALUE,
	   ww.WEIGHT_STAB_VALUE,
	   ww.WEIGHT_ZERO_VALUE,	  
	   CAST(0 as bit) as ALARM,
	  null as RodsQuanity,
	  null as RodsLeft 
FROM (
SELECT eq.ID EquipmentID,
	   eq.[Description],
       ROW_NUMBER() OVER(PARTITION BY kl.WEIGHT__FIX_NUMERICID ORDER BY kl.WEIGHT__FIX_TIMESTAMP DESC) RowNumber,
       kl.* 
FROM dbo.Equipment eq
     INNER JOIN dbo.EquipmentProperty eqp ON (eqp.EquipmentID=eq.ID)
     INNER JOIN dbo.EquipmentClassProperty ecp ON (ecp.ID=eqp.ClassPropertyID AND ecp.value=N'CONTROLLER_NO')
     INNER JOIN dbo.KEP_logger kl ON (ISNUMERIC(eqp.value)=1 AND kl.WEIGHT__FIX_NUMERICID=CAST(eqp.value AS INT) AND kl.WEIGHT__FIX_TIMESTAMP>=DATEADD(hour,-1,GETDATE()))
) ww
WHERE ww.RowNumber=1;


GO

