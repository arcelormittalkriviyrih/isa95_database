-- 
IF OBJECT_ID ('dbo.get_WorkDefinitionPropertiesAll', N'TF') IS NOT NULL
   DROP FUNCTION dbo.get_WorkDefinitionPropertiesAll;
GO

CREATE FUNCTION dbo.get_WorkDefinitionPropertiesAll(@COMM_ORDER NVARCHAR(50))
RETURNS @retWorkDefinitionPropertiesAll TABLE (ID               INT,
                                               Description      NVARCHAR(50),
                                               Value            NVARCHAR(50),
                                               WorkDefinitionID INT,
                                               Property         NVARCHAR(50))
AS
BEGIN

   DECLARE @WorkDefinitionID     INT,
           @OpSegmentRequirement INT;

   SELECT @WorkDefinitionID=ps.[WorkDefinitionID]
   FROM [dbo].[ParameterSpecification] ps
        INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=ps.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
   WHERE ps.[Value]=@COMM_ORDER;

  IF NOT @WorkDefinitionID IS NULL
     BEGIN 
        INSERT @retWorkDefinitionPropertiesAll
           SELECT ps.[ID],
                  pt.[Description],
                  ps.[Value],
                  ps.[WorkDefinitionID],
                  pt.[Value]
           FROM [dbo].[ParameterSpecification] ps
                INNER JOIN [dbo].[PropertyTypes] pt ON (pt.[ID]=ps.[PropertyType])
           WHERE ps.[WorkDefinitionID]=@WorkDefinitionID
     END
  ELSE
     BEGIN
        SELECT @OpSegmentRequirement=sp.[OpSegmentRequirement]
        FROM [dbo].[SegmentParameter] sp
             INNER JOIN [dbo].[PropertyTypes] ptco ON (ptco.[ID]=sp.[PropertyType] AND ptco.[Value]=N'COMM_ORDER')
        WHERE sp.[Value]=@COMM_ORDER;

        INSERT @retWorkDefinitionPropertiesAll
          SELECT sp.ID,
                 pt.Description,
                 sp.[Value],
                 NULL,
                 pt.[Value] Property
          FROM dbo.OpSegmentRequirement sr
               INNER JOIN dbo.SegmentParameter sp ON (sp.OpSegmentRequirement=sr.id)
               INNER JOIN dbo.PropertyTypes pt ON (pt.ID=sp.PropertyType)
          WHERE sr.[ID]=@OpSegmentRequirement;
     END

  RETURN;

END;
GO
