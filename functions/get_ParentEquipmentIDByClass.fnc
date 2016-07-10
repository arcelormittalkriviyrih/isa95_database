--------------------------------------------------------------
-- Процедура возвращает ID родителя из таблицы Equipment соответствующего EquipmentClass.Code
IF OBJECT_ID ('dbo.get_ParentEquipmentIDByClass', N'FN') IS NOT NULL
   DROP FUNCTION [dbo].[get_ParentEquipmentIDByClass];
GO

CREATE FUNCTION [dbo].[get_ParentEquipmentIDByClass](@EquipmentID   INT,
                                                     @Code          NVARCHAR(50))
RETURNS INT
AS
BEGIN

DECLARE @ParentEquipmentID INT,
        @ReturnEquipmentID INT,
        @EquipmentClassID  INT;

SELECT @EquipmentClassID=EquipmentClassID,
       @ParentEquipmentID=[Equipment]
FROM [dbo].[Equipment]
WHERE [ID]=@EquipmentID;

WHILE (@EquipmentClassID IS NOT NULL) AND (SELECT [ID] FROM [dbo].[EquipmentClass] eqc WHERE eqc.[Code]=@Code) <> @EquipmentClassID
BEGIN
   SELECT @EquipmentClassID=EquipmentClassID,
          @ReturnEquipmentID=[ID],
          @ParentEquipmentID=[Equipment]
   FROM [dbo].[Equipment]
   WHERE [ID]=@ParentEquipmentID;
END;

RETURN @ReturnEquipmentID;

END;
GO
