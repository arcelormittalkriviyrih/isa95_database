SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
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

delete from EquipmentProperty where ClassPropertyID in (1,2,3);
delete from [EquipmentClassProperty] where id in (1,2,3);

INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Тип весов',N'SCALES_TYPE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Идентификатор весов',N'SCALES_NO',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Точность округления',N'ROUND_PRECISION',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Правило округления',N'ROUND_RULE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Правило расчета увязки',N'PACK_RULE',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Вес увязки',N'PACK_WEIGHT',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Номер контроллера',N'CONTROLLER_NO',@EquipmentClassID);


SELECT @EquipmentClassID=[ID] FROM [dbo].[EquipmentClass] WHERE [Code]=N'PRINTER';
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'IP адрес принтера',N'PRINTER_IP',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Имя принтера',N'PRINTER_NAME',@EquipmentClassID);
INSERT INTO [dbo].[EquipmentClassProperty] ([Description],[Value],[EquipmentClassID]) VALUES (N'Идентификатор принтера',N'PRINTER_NO',@EquipmentClassID);


COMMIT;
GO

