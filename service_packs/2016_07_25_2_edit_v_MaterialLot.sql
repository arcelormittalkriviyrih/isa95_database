SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.v_MaterialLot', N'V') IS NOT NULL
   DROP VIEW dbo.v_MaterialLot;
GO

CREATE VIEW [dbo].[v_MaterialLot]
AS
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
     LEFT OUTER JOIN (SELECT ww.MaterialLotID,
                             ww.DispatchStatus
                      FROM (SELECT ROW_NUMBER() OVER (PARTITION BY p.[Value] ORDER BY jo.ID DESC) rnum,
                                   jo.ID,
                                   jo.DispatchStatus,
                                   CAST(p.[Value] AS INT) MaterialLotID
                            FROM Parameter p,PropertyTypes pt,JobOrder jo
                            WHERE pt.ID = p.PropertyType
                              AND pt.[Value] = N'MaterialLotID'
                              AND jo.ID = p.JobOrder
                              AND jo.WorkType=N'Print') ww
                       WHERE ww.rnum=1) ps ON ps.MaterialLotID=mlp.ID;
GO