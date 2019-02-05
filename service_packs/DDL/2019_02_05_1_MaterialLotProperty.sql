SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'PROD_ORDER')
   ALTER TABLE [dbo].[MaterialLot] ADD PROD_ORDER [nvarchar](250) NULL
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'BUNT_NO')
   ALTER TABLE [dbo].[MaterialLot] ADD BUNT_NO [nvarchar](250) NULL
GO

IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'MaterialLot'
                AND column_name = 'PART_NO')
   ALTER TABLE [dbo].[MaterialLot] ADD PART_NO [nvarchar](250) NULL
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
    AND INSERTED.[PropertyType] = [dbo].[get_PropertyTypeIdByValue](N'PROD_DATE');
	
   UPDATE [dbo].[MaterialLot]
   SET [MaterialLot].[PART_NO] = INSERTED.[Value]
   FROM INSERTED
   WHERE [MaterialLot].[ID] = INSERTED.[MaterialLotID]
    AND INSERTED.[PropertyType] = [dbo].[get_PropertyTypeIdByValue](N'PART_NO');
	
   UPDATE [dbo].[MaterialLot]
   SET [MaterialLot].[BUNT_NO] = INSERTED.[Value]
   FROM INSERTED
   WHERE [MaterialLot].[ID] = INSERTED.[MaterialLotID]
    AND INSERTED.[PropertyType] = [dbo].[get_PropertyTypeIdByValue](N'BUNT_NO');
	
   UPDATE [dbo].[MaterialLot]
   SET [MaterialLot].[PROD_ORDER] = INSERTED.[Value]
   FROM INSERTED
   WHERE [MaterialLot].[ID] = INSERTED.[MaterialLotID]
    AND INSERTED.[PropertyType] = [dbo].[get_PropertyTypeIdByValue](N'PROD_ORDER');

END
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i5_MaterialLot_PART_NO' AND object_id = OBJECT_ID('[dbo].[MaterialLot]'))
   DROP INDEX [i5_MaterialLot_PART_NO] ON [dbo].[MaterialLot]
GO

CREATE INDEX [i5_MaterialLot_PART_NO] ON [dbo].[MaterialLot] ([PART_NO])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i6_MaterialLot_BUNT_NO' AND object_id = OBJECT_ID('[dbo].[MaterialLot]'))
   DROP INDEX [i6_MaterialLot_BUNT_NO] ON [dbo].[MaterialLot]
GO

CREATE INDEX [i6_MaterialLot_BUNT_NO] ON [dbo].[MaterialLot] ([BUNT_NO])
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i7_MaterialLot_PROD_ORDER' AND object_id = OBJECT_ID('[dbo].[MaterialLot]'))
   DROP INDEX [i7_MaterialLot_PROD_ORDER] ON [dbo].[MaterialLot]
GO

CREATE INDEX [i7_MaterialLot_PROD_ORDER] ON [dbo].[MaterialLot] ([PROD_ORDER])
GO


IF OBJECT_ID('dbo.v_MaterialLotChange', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotChange];
GO
/*
   View: v_MaterialLotChange
    Возвращает список бирок для режима изменения заказа.
*/
CREATE VIEW [dbo].[v_MaterialLotChange]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.CreateTime,
       ml.Quantity,
       ml.SideID,
       ml.PROD_ORDER,
       ml.PART_NO,
       ml.BUNT_NO,
       CAST(0 AS BIT) selected
FROM [dbo].[MaterialLot] ml
     INNER JOIN [dbo].[MaterialLotLast] mll ON (mll.[MaterialLotID]=ml.[ID])     
WHERE ml.Quantity>0;
GO

IF OBJECT_ID('dbo.v_MaterialLotProperty', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotProperty];
GO
/*
   View: v_MaterialLotProperty
    Возвращает список свойств бирки.
	Используется в спец режимах.
*/
CREATE VIEW [dbo].[v_MaterialLotProperty]
AS
SELECT mlp.[ID],
       ml.[ID] MaterialLotID,
       ml.[FactoryNumber],
       ml.[Status],
       ml.[Quantity],
       mlp.[PropertyType] PropertyID,
       pt.[Value] Property,
       mlp.[Value]
FROM [dbo].[MaterialLot] ml
	 INNER JOIN [dbo].[MaterialLotLast] mll ON (mll.[MaterialLotID]=ml.[ID])   
     INNER JOIN [dbo].[MaterialLotProperty] mlp ON (mlp.[MaterialLotID]=ml.[ID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=mlp.[PropertyType])
WHERE ml.[Quantity]	> 0
  AND ml.[Status]!=1;
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
       ml.PROD_ORDER,
       ml.PART_NO,
       auto_manu_value.[Value] AUTO_MANU_VALUE,
       create_mode.[Value] CREATE_MODE,
       measure_time.[ValueDate] MEASURE_TIME,
       material_no.[Value] MATERIAL_NO,
	   (SELECT mt.Description FROM [dbo].[MaterialLinkTypes] mt WHERE mt.[ID]=ml.[Status]) StatusName
FROM [dbo].[MaterialLot] ml
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] change_no ON (change_no.[MaterialLotID]=ml.[ID] AND change_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CHANGE_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] brigade_no ON (brigade_no.[MaterialLotID]=ml.[ID] AND brigade_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BRIGADE_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] melt_no ON (melt_no.[MaterialLotID]=ml.[ID] AND melt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MELT_NO'))          
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] auto_manu_value ON (auto_manu_value.[MaterialLotID]=ml.[ID] AND auto_manu_value.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('AUTO_MANU_VALUE'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] create_mode ON (create_mode.[MaterialLotID]=ml.[ID] AND create_mode.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('CREATE_MODE'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] measure_time ON (measure_time.[MaterialLotID]=ml.[ID] AND measure_time.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MEASURE_TIME'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] material_no ON (material_no.[MaterialLotID]=ml.[ID] AND material_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('MATERIAL_NO'))
WHERE ml.[Status]!=1
GO