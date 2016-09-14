SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLotReport', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLotReport;
GO
/*
   View: v_MaterialLotReport
    Возвращает список бирок с информацией для отчетов.
*/
CREATE VIEW [dbo].[v_MaterialLotReport]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.Quantity,
       eq.Equipment SideID,
       TRY_CONVERT(DATETIMEOFFSET(3),prod_date.[Value],104) PROD_DATE,
       change_no.[Value] CHANGE_NO,
       brigade_no.[Value] BRIGADE_NO,
       melt_no.[Value] MELT_NO,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       auto_manu_value.[Value] AUTO_MANU_VALUE,
       create_mode.[Value] CREATE_MODE,
       TRY_CONVERT(DATETIMEOFFSET(3),measure_time.[Value],104) MEASURE_TIME,
       material_no.[Value] MATERIAL_NO
FROM (SELECT ml.[ID],
             ml.[FactoryNumber],
             ml.[Status],
             ml.[Quantity],
             ml.CreateTime
      FROM (SELECT ml.[ID],
                   ml.[FactoryNumber],
                   ml.[Status],
                   ml.[Quantity],
                   ml.CreateTime,
                   ROW_NUMBER() OVER (PARTITION BY ml.[FactoryNumber] ORDER BY ml.[CreateTime] DESC, ml.[ID] DESC) RowNumber
            FROM [dbo].[MaterialLot] ml) ml
            WHERE ml.RowNumber=1) ml
      INNER JOIN [dbo].[Equipment] eq ON (eq.ID=[dbo].[get_EquipmentIdByPropertyValue](SUBSTRING(ml.FactoryNumber,7,2),'SCALES_NO'))
      INNER JOIN [dbo].[MaterialLotProperty] prod_date ON (prod_date.[MaterialLotID]=ml.[ID] AND prod_date.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_DATE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] change_no ON (change_no.[MaterialLotID]=ml.[ID] AND change_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CHANGE_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] brigade_no ON (brigade_no.[MaterialLotID]=ml.[ID] AND brigade_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BRIGADE_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] melt_no ON (melt_no.[MaterialLotID]=ml.[ID] AND melt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MELT_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] auto_manu_value ON (auto_manu_value.[MaterialLotID]=ml.[ID] AND auto_manu_value.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('AUTO_MANU_VALUE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] create_mode ON (create_mode.[MaterialLotID]=ml.[ID] AND create_mode.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CREATE_MODE'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] measure_time ON (measure_time.[MaterialLotID]=ml.[ID] AND measure_time.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MEASURE_TIME'))
      LEFT OUTER JOIN [dbo].[MaterialLotProperty] material_no ON (material_no.[MaterialLotID]=ml.[ID] AND material_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MATERIAL_NO'))
GO
