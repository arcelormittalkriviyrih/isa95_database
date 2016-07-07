SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS
(
    SELECT NULL
    FROM EquipmentClass
    WHERE id = 10
)
    BEGIN
        UPDATE Equipment
          SET
              EquipmentClassID = 10
        WHERE EquipmentClassID = 5;
        DELETE FROM EquipmentClass
        WHERE id = 5;
    END;
GO

IF EXISTS
(
    SELECT NULL
    FROM EquipmentClass
    WHERE id = 9
)
    BEGIN
        UPDATE Equipment
          SET
              EquipmentClassID = 9
        WHERE EquipmentClassID = 4;
        DELETE FROM EquipmentClass
        WHERE id = 4;
    END;
GO