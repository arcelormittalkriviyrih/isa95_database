IF OBJECT_ID ('dbo.get_LatestWorkRequests', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_LatestWorkRequests;
GO

CREATE FUNCTION dbo.get_LatestWorkRequests(@EquipmentID INT)
RETURNS @get_LatestWorkRequests TABLE (WorkRequestID INT,
                                       JobOrderID    INT,
                                       EquipmentID   INT,
                                       ProfileID     INT,
                                       WorkType      NVARCHAR(50),
                                       PropertyType  NVARCHAR(50),
                                       Value         NVARCHAR(50))
AS
BEGIN

   DECLARE @JobOrderID       INT,
           @WorkRequestID    INT,
           @WorkDefinitionID INT,
           @ProfileID        INT,
           @WorkType         NVARCHAR(50),
           @PacksLeft        NVARCHAR(50);

   SET @JobOrderID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'JOB_ORDER_ID');
   SET @WorkDefinitionID=dbo.get_EquipmentPropertyValue(@EquipmentID,N'WORK_DEFINITION_ID');

   SELECT @WorkRequestID=jo.[WorkRequest],
          @WorkType=wr.[WorkType],
          @ProfileID=mr.[MaterialDefinitionID]
   FROM [dbo].[JobOrder] jo
        INNER JOIN [dbo].[WorkRequest] wr ON (jo.[WorkRequest]=wr.[ID])
        LEFT OUTER JOIN [dbo].[OpMaterialRequirement] mr ON (mr.[JobOrderID]=jo.[ID] AND mr.[MaterialClassID]=dbo.get_MaterialClassIDByCode(N'PROFILE'))
   WHERE jo.[ID]=@JobOrderID;

   INSERT @get_LatestWorkRequests
   SELECT @WorkRequestID WorkRequestID,
          par.[JobOrder] JobOrderID,
          er.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N'Standard') WorkType,
          pt.[Value] PropertyType,
          par.[Value]
   FROM [dbo].[Parameter] par
        INNER JOIN [dbo].[OpEquipmentRequirement] er ON (er.[JobOrderID]=par.[JobOrder])
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=par.[PropertyType] AND pt.[Value] NOT IN (N'COMM_ORDER'))
   WHERE par.[JobOrder]=@JobOrderID
   UNION ALL
   SELECT @WorkRequestID,
          @JobOrderID,
          oes.[EquipmentID],
          @ProfileID ProfileID,
          isnull(@WorkType,N'Standard') WorkType,
          pt.[Value] PropertyType,
          ps.[Value]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[OpEquipmentSpecification] oes ON (oes.[WorkDefinition]=ps.WorkDefinitionID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=ps.[PropertyType] AND pt.[Value] IN (N'COMM_ORDER',N'BRIGADE_NO',N'PROD_DATE'))
   WHERE ps.[WorkDefinitionID]=@WorkDefinitionID;

RETURN;

END;
GO
