SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO


CREATE VIEW [dbo].[v_MaterialLot]
AS
WITH PrintStatus
     AS (SELECT MAX(jo.DispatchStatus) DispatchStatus,
                p.[Value] MaterialLotID
         FROM Parameter p,
              PropertyTypes pt,
              JobOrder jo
         WHERE pt.ID = p.PropertyType
               AND pt.[Value] = N'MaterialLotID'
               AND jo.ID = p.JobOrder
         GROUP BY p.[Value])
     SELECT *,
            CASE [Status]
                WHEN '0'
                THEN N'Печать'
                WHEN '1'
                THEN N'Перемаркировка'
                WHEN '2'
                THEN N'Сортировка'
                WHEN '3'
                THEN N'Отбраковка'
                WHEN '4'
                THEN N'Разделение пачки'
            END StatusName,
            (CASE ps.DispatchStatus
                 WHEN N'Done'
                 THEN CAST(1 AS BIT)
                 WHEN N'ToPrint'
                 THEN CAST(0 AS BIT)
                 ELSE NULL
             END) isPrinted
     FROM [dbo].[MaterialLot] mlp
          LEFT OUTER JOIN PrintStatus ps ON ps.MaterialLotID = mlp.ID;
GO