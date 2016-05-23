--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_CreateOrder;
GO

CREATE PROCEDURE dbo.ins_CreateOrder 
@STD      NVARCHAR(50),
@LEN      NVARCHAR(50),
@QMIN     NVARCHAR(50) = NULL,
@CONTR    NVARCHAR(50),
@DIR      NVARCHAR(50),
@PROD     NVARCHAR(50),
@CLASS    NVARCHAR(50),
@STCLASS  NVARCHAR(50),
@CHEM     NVARCHAR(50),
@DIAM     NVARCHAR(50) = NULL,
@ADR      NVARCHAR(50),
@ORDER    NVARCHAR(50),
@PROFILE  INT,
@TEMPLATE INT
AS
BEGIN
   DECLARE @OperationsRequestID int,
           @OpSegmentRequirementID int,
           @OpMaterialRequirementID int;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [MIMEType]=N'application/vnd.ms-excel' AND [ID]=@TEMPLATE)
      RAISERROR ('Указанный Excel TEMPLATE не существует в таблице Files',16,1);

   SET @OperationsRequestID=NEXT VALUE FOR [dbo].[gen_OperationsRequest];
   INSERT INTO [dbo].[OperationsRequest] ([ID]) VALUES (@OperationsRequestID);

   SET @OpSegmentRequirementID=NEXT VALUE FOR [dbo].[gen_OpSegmentRequirement];
   INSERT INTO [dbo].[OpSegmentRequirement] ([ID],[OperationsRequest]) VALUES (@OpSegmentRequirementID,@OperationsRequestID);

   --SET @OpMaterialRequirementID=NEXT VALUE FOR [dbo].[gen_MaterialRequirement];
   INSERT INTO [dbo].[OpMaterialRequirement] ([MaterialClassID],[MaterialDefinitionID],[SegmenRequirementID])
   SELECT md.[MaterialClassID],md.[ID],@OpSegmentRequirementID
   FROM [dbo].[MaterialDefinition] md 
   WHERE md.[ID]=@PROFILE;

   INSERT @tblParams
   SELECT N'STD',@STD WHERE @STD IS NOT NULL
   UNION ALL
   SELECT N'LEN',@LEN WHERE @LEN IS NOT NULL
   UNION ALL
   SELECT N'QMIN',@QMIN WHERE @QMIN IS NOT NULL
   UNION ALL
   SELECT N'CONTR',@CONTR WHERE @CONTR IS NOT NULL
   UNION ALL
   SELECT N'DIR',@DIR WHERE @DIR IS NOT NULL
   UNION ALL
   SELECT N'PROD',@PROD WHERE @PROD IS NOT NULL
   UNION ALL
   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N'STCLASS',@STCLASS WHERE @STCLASS IS NOT NULL
   UNION ALL
   SELECT N'CHEM',@CHEM WHERE @CHEM IS NOT NULL
   UNION ALL
   SELECT N'DIAM',@DIAM WHERE @DIAM IS NOT NULL
   UNION ALL
   SELECT N'ADR',@ADR WHERE @ADR IS NOT NULL
   UNION ALL
   SELECT N'ORDER',@ORDER WHERE @ORDER IS NOT NULL
   UNION ALL
   SELECT N'TMPL',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

END;
GO
