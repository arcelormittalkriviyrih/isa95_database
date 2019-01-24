SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i1_PersonProperty' AND object_id = OBJECT_ID('[dbo].[PersonProperty]'))
   DROP INDEX [i1_PersonProperty] ON [dbo].[PersonProperty]
GO

CREATE INDEX [i1_PersonProperty] ON [dbo].PersonProperty (Value)
GO

IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='i2_EquipmentProperty' AND object_id = OBJECT_ID('[dbo].[EquipmentProperty]'))
   DROP INDEX [i2_EquipmentProperty] ON [dbo].[EquipmentProperty]
GO

CREATE INDEX [i2_EquipmentProperty] ON [dbo].EquipmentProperty (Value)
GO



IF OBJECT_ID ('dbo.MaterialLotLast',N'U') IS NULL
	CREATE TABLE [dbo].[MaterialLotLast](
		[FactoryNumber] [nvarchar](250) NOT NULL,
		[MaterialLotID] [int] NOT NULL,
 	CONSTRAINT [PK_MaterialLotLast] PRIMARY KEY CLUSTERED 
	(
		[FactoryNumber] ASC 
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
GO


IF EXISTS (SELECT NULL FROM sys.indexes WHERE name='u2_MaterialLotLast' AND object_id = OBJECT_ID('[dbo].[MaterialLotLast]'))
   DROP INDEX [u2_MaterialLotLast] ON [dbo].[MaterialLotLast]
GO

CREATE UNIQUE NONCLUSTERED INDEX [u2_MaterialLotLast] ON [dbo].[MaterialLotLast]
(
	[MaterialLotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];


IF OBJECT_ID ('dbo.InsUpdMaterialLot',N'TR') IS NOT NULL
   DROP TRIGGER [dbo].[InsUpdMaterialLot];
GO

CREATE TRIGGER [dbo].[InsUpdMaterialLot] ON [dbo].[MaterialLot]
AFTER INSERT, UPDATE
AS
BEGIN

   SET NOCOUNT ON;

   DECLARE @ID                  INT,
           @SideID              INT,
           @FactoryNumber       NVARCHAR(250),
           @FactoryNumberScales NVARCHAR(250);

   SELECT @ID=[ID],
          @FactoryNumber=[FactoryNumber],
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

   IF EXISTS (SELECT NULL FROM [dbo].[MaterialLotLast] WHERE [FactoryNumber]=@FactoryNumber)
      UPDATE [dbo].[MaterialLotLast]
      SET [MaterialLotID] = @ID
      WHERE [FactoryNumber]=@FactoryNumber;
   ELSE
      INSERT INTO [dbo].[MaterialLotLast] ([FactoryNumber],[MaterialLotID])
      SELECT [FactoryNumber],[ID] FROM INSERTED;
END
GO


IF OBJECT_ID('dbo.v_MaterialLotChange', N'V') IS NOT NULL
    DROP VIEW dbo.[v_MaterialLotChange];
GO

CREATE VIEW [dbo].[v_MaterialLotChange]
AS
SELECT ml.ID,
       ml.FactoryNumber,
       ml.CreateTime,
       ml.Quantity,
       ml.SideID,
       prod_order.[Value] PROD_ORDER,
       part_no.[Value] PART_NO,
       bunt_no.[Value] BUNT_NO,
       CAST(0 AS BIT) selected
FROM [dbo].[MaterialLot] ml
     INNER JOIN [dbo].[MaterialLotLast] mll ON (mll.[MaterialLotID]=ml.[ID])
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] prod_order ON (prod_order.[MaterialLotID]=ml.[ID] AND prod_order.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PROD_ORDER'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] part_no ON (part_no.[MaterialLotID]=ml.[ID] AND part_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('PART_NO'))
     LEFT OUTER JOIN [dbo].[MaterialLotProperty] bunt_no ON (bunt_no.[MaterialLotID]=ml.[ID] AND bunt_no.[PropertyType]=[dbo].[get_PropertyTypeIdByValue]('BUNT_NO'))
WHERE ml.Quantity>0;
GO

