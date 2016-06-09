-- Обновление структур таблиц
IF NOT EXISTS(SELECT NULL
              FROM information_schema.columns
              WHERE table_name = 'EquipmentClass'
                AND column_name = 'Code')
BEGIN
   ALTER TABLE [dbo].[EquipmentClass] ADD [Code] [NVARCHAR](50) NULL;
END
GO

BEGIN TRANSACTION;

INSERT INTO [dbo].[EquipmentClass]([ParentID],[Description],[Code]) VALUES (1,N'Цеха',N'WORKSHOP');
INSERT INTO [dbo].[EquipmentClass]([ParentID],[Description],[Code]) VALUES (1,N'Стороны станов',N'SIDE');
UPDATE [dbo].[EquipmentClass] SET [Code]=N'MILL',[Description]=N'Станы' WHERE [Description]=N'Стан';
UPDATE [dbo].[EquipmentClass] SET [Code]=N'SCALES' WHERE [Description]=N'Весы';
UPDATE [dbo].[EquipmentClass] SET [Code]=N'PRINTER',[Description]=N'Принтеры' WHERE [Description]=N'Принтер';

DECLARE @EquipmentClassID INT;

SELECT @EquipmentClassID=[ID] FROM [dbo].[EquipmentClass] WHERE [Code]=N'SCALES';

INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Тип весов',N'SCALES_TYPE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Идентификатор весов',N'SCALES_NO',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Точность округления',N'ROUND_PRECISION',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Правило округления',N'ROUND_RULE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Вес увязки',N'PACK_WEIGHT',@EquipmentClassID);

COMMIT;
GO

