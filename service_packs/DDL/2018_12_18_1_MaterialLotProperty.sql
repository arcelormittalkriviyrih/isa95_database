SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'SideID')
   ALTER TABLE [dbo].[MaterialLot] ADD SideID INT NULL
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'ProdDate')
	ALTER TABLE [dbo].[MaterialLot] ADD ProdDate DATETIMEOFFSET NULL
GO

IF OBJECT_ID ('dbo.InsUpdMaterialLot',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsUpdMaterialLot];
GO

CREATE TRIGGER [dbo].[InsUpdMaterialLot] ON [dbo].[MaterialLot]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @ID                  INT,
           @SideID           INT,
           @FactoryNumberScales NVARCHAR(250);

   SELECT @ID=[ID],
          @FactoryNumberScales=[FactoryNumberScales]
   FROM INSERTED;

   SELECT @SideID=eq.[Equipment]
   FROM [dbo].[EquipmentProperty] eqp
        INNER JOIN [dbo].[Equipment] eq ON (eq.ID=eqp.[EquipmentID])
   WHERE eqp.[ClassPropertyID]=[dbo].[get_EquipmentClassPropertyByValue](N'SCALES_NO')
     AND eqp.[Value]=@FactoryNumberScales;

   UPDATE [dbo].[MaterialLot]
   SET SideID=@SideID
   WHERE [ID]=@ID;

END
GO

IF OBJECT_ID ('dbo.[InsUpdMaterialLotProperty]',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsUpdMaterialLotProperty];
GO

CREATE TRIGGER [dbo].[InsUpdMaterialLotProperty] ON [dbo].[MaterialLotProperty]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   UPDATE [dbo].[MaterialLot]
   SET [MaterialLot].[ProdDate] = INSERTED.[ValueDate]
   FROM INSERTED
   WHERE [MaterialLot].[ID] = INSERTED.[MaterialLotID]
    AND INSERTED.[PropertyType] = [dbo].[get_PropertyTypeIdByValue](N'PROD_DATE')

END
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i4_MaterialLot_SideID_ProdDate' AND object_id = OBJECT_ID('[dbo].[MaterialLot]'))
   DROP INDEX [i4_MaterialLot_SideID_ProdDate] ON [dbo].[MaterialLot]
GO

CREATE INDEX [i4_MaterialLot_SideID_ProdDate] ON [dbo].[MaterialLot] ([SideID],[ProdDate])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_MaterialLotProperty' AND object_id = OBJECT_ID('[dbo].[MaterialLotProperty]'))
   DROP INDEX [i1_MaterialLotProperty] ON [dbo].[MaterialLotProperty]
GO

CREATE INDEX [i1_MaterialLotProperty] ON [dbo].[MaterialLotProperty] ([Value])
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
       ml.SideID SideID,
       ml.[ProdDate] PROD_DATE,
       change_no.[Value] CHANGE_NO,
       brigade_no.[Value] BRIGADE_NO,
       melt_no.[Value] MELT_NO,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       auto_manu_value.[Value] AUTO_MANU_VALUE,
       create_mode.[Value] CREATE_MODE,
       measure_time.[ValueDate] MEASURE_TIME,
       material_no.[Value] MATERIAL_NO,
	   (SELECT mt.Description FROM [dbo].[MaterialLinkTypes] mt WHERE mt.[ID]=ml.[Status]) StatusName
FROM [dbo].[MaterialLot] ml
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] change_no ON (change_no.[MaterialLotID]=ml.[ID] AND change_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CHANGE_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] brigade_no ON (brigade_no.[MaterialLotID]=ml.[ID] AND brigade_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BRIGADE_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] melt_no ON (melt_no.[MaterialLotID]=ml.[ID] AND melt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MELT_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] auto_manu_value ON (auto_manu_value.[MaterialLotID]=ml.[ID] AND auto_manu_value.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('AUTO_MANU_VALUE'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] create_mode ON (create_mode.[MaterialLotID]=ml.[ID] AND create_mode.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CREATE_MODE'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] measure_time ON (measure_time.[MaterialLotID]=ml.[ID] AND measure_time.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MEASURE_TIME'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] material_no ON (material_no.[MaterialLotID]=ml.[ID] AND material_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MATERIAL_NO'))
WHERE ml.[Status]!=1
GO