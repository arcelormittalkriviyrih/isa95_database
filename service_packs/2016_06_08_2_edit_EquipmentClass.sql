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

--call sequence one time to increase number, because current DB already has 3 records records, but gen_EquipmentClass = 1
select next value for dbo.gen_EquipmentClass;
select next value for dbo.gen_EquipmentClass;
select next value for dbo.gen_EquipmentClass;

INSERT INTO [dbo].[EquipmentClass]([Description],[Code]) VALUES (N'Цеха',N'WORKSHOP');
INSERT INTO [dbo].[EquipmentClass]([Description],[Code]) VALUES (N'Стороны станов',N'SIDE');
UPDATE [dbo].[EquipmentClass] SET [Code]=N'MILL',[Description]=N'Станы' WHERE [Description]=N'Стан';
UPDATE [dbo].[EquipmentClass] SET [Code]=N'SCALES' WHERE [Description]=N'Весы';
UPDATE [dbo].[EquipmentClass] SET [Code]=N'PRINTER',[Description]=N'Принтеры' WHERE [Description]=N'Принтер';

update [dbo].[EquipmentClass] SET [ParentID]=null;

DECLARE @EquipmentClassID INT;

SELECT @EquipmentClassID=[ID] FROM [dbo].[EquipmentClass] WHERE [Code]=N'SCALES';

INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Тип весов',N'SCALES_TYPE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Идентификатор весов',N'SCALES_NO',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Точность округления',N'ROUND_PRECISION',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Правило округления',N'ROUND_RULE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Правило расчета увязки',N'PACK_RULE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Вес увязки',N'PACK_WEIGHT',@EquipmentClassID);

COMMIT;
GO

