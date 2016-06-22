IF OBJECT_ID ('dbo.v_LatestWorkRequests', N'V') IS NOT NULL
   DROP VIEW dbo.v_LatestWorkRequests;
GO

CREATE VIEW [dbo].[v_LatestWorkRequests]
AS
WITH WorkRequest AS (SELECT wr.[WorkRequestID],wr.[JobOrderID],wr.[EquipmentID],wr.[ProfileID],comm_order
                     FROM (SELECT ROW_NUMBER() OVER (PARTITION BY er.[EquipmentID] ORDER BY wr.[StartTime] DESC) RowNumber,
                                  wr.[ID] WorkRequestID,
                                  jo.[ID] JobOrderID,
                                  er.[EquipmentID],
                                  mr.[MaterialDefinitionID] ProfileID,
                                  po.[Value] COMM_ORDER
                           FROM [dbo].[WorkRequest] wr
                                INNER JOIN [dbo].[JobOrder] jo ON (jo.[WorkRequest]=wr.[ID])
                                LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID])
                                INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=jo.[ID])
                                INNER JOIN [dbo].[v_Parameter_Order] po ON (po.[JobOrder]=jo.[ID])) wr
                           WHERE wr.RowNumber=1) 
SELECT newID() ID,
       wr.[WorkRequestID],
       wr.[JobOrderID],
       wr.[EquipmentID],
       wr.[ProfileID],
       pt.[Value] PropertyType,
       par.[Value]
FROM [dbo].[Parameter] par
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=par.[PropertyType])
     INNER JOIN WorkRequest wr ON (wr.[JobOrderID]=par.[JobOrder])
UNION ALL
SELECT newID() ID,
       wr.[WorkRequestID],
       wr.[JobOrderID],
       wr.[EquipmentID],
       wr.[ProfileID],
       pt.[Value] PropertyType,
       ps.[Value]
FROM [dbo].[v_ParameterSpecification_Order] pso
     INNER JOIN WorkRequest wr ON (wr.COMM_ORDER=pso.[Value])
     INNER JOIN [dbo].[ParameterSpecification] ps ON (ps.[WorkDefinitionID]=pso.[WorkDefinitionID])
     INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N'BRIGADE_NO',N'PROD_DATE'))
GO