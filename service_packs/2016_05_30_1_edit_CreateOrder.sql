--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_CreateOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------
-- Процедура ins_CreateOrder
IF OBJECT_ID ('dbo.ins_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_CreateOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_CreateOrder] 
@ORDER    NVARCHAR(50),
@CONTR    NVARCHAR(50),
@DIR      NVARCHAR(50),
@TEMPLATE INT,
@ADR      NVARCHAR(50),
@DIAM     NVARCHAR(50) = NULL,
@LEN      NVARCHAR(50),
@CLASS    NVARCHAR(50),
@QMIN     NVARCHAR(50) = NULL,
@STCLASS  NVARCHAR(50),
@PROD     NVARCHAR(50),
@PROFILE  INT,
@STD      NVARCHAR(50),
@CHEM     NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID int,
           @OpSegmentRequirementID int,
           @OpMaterialRequirementID int;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   IF @STD IS NULL
	  RAISERROR ('STD param required',16,1);
   ELSE IF @LEN IS NULL
	  RAISERROR ('LEN param required',16,1);
   ELSE IF @CONTR IS NULL
	  RAISERROR ('CONTR param required',16,1);
   ELSE IF @DIR IS NULL
	  RAISERROR ('DIR param required',16,1);
   ELSE IF @PROD IS NULL
	  RAISERROR ('PROD param required',16,1);
   ELSE IF @CLASS IS NULL
	  RAISERROR ('CLASS param required',16,1);
   ELSE IF @STCLASS IS NULL
	  RAISERROR ('STCLASS param required',16,1);
   ELSE IF @CHEM IS NULL
	  RAISERROR ('CHEM param required',16,1);
   ELSE IF @ADR IS NULL
	  RAISERROR ('ADR param required',16,1);
   ELSE IF @ORDER IS NULL
	  RAISERROR ('ORDER param required',16,1);
   ELSE IF @PROFILE IS NULL
	  RAISERROR ('PROFILE param required',16,1);
   ELSE IF @TEMPLATE IS NULL
	  RAISERROR ('TEMPLATE param required',16,1);
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      RAISERROR ('Указанный Excel шаблон не существует в таблице Files',16,1);
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      RAISERROR ('Указанный профиль не существует в таблице MaterialDefinition',16,1);
   ELSE 
	BEGIN

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
	   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

	   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
	   SELECT t.value,@OpSegmentRequirementID,pt.ID
	   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   END;

END;
GO

--------------------------------------------------------------
-- Процедура upd_CreateOrder
IF OBJECT_ID ('dbo.upd_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_CreateOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_CreateOrder] 
@ORDER    NVARCHAR(50),
@CONTR    NVARCHAR(50),
@DIR      NVARCHAR(50),
@TEMPLATE INT,
@ADR      NVARCHAR(50),
@DIAM     NVARCHAR(50) = NULL,
@LEN      NVARCHAR(50),
@CLASS    NVARCHAR(50),
@QMIN     NVARCHAR(50) = NULL,
@STCLASS  NVARCHAR(50),
@PROD     NVARCHAR(50),
@PROFILE  INT,
@STD      NVARCHAR(50),
@CHEM     NVARCHAR(50)
AS
BEGIN
   DECLARE @OpSegmentRequirementID int;

   IF @STD IS NULL
      RAISERROR ('STD param required',16,1);
   ELSE IF @LEN IS NULL
      RAISERROR ('LEN param required',16,1);
   ELSE IF @CONTR IS NULL
      RAISERROR ('CONTR param required',16,1);
   ELSE IF @DIR IS NULL
      RAISERROR ('DIR param required',16,1);
   ELSE IF @PROD IS NULL
      RAISERROR ('PROD param required',16,1);
   ELSE IF @CLASS IS NULL
      RAISERROR ('CLASS param required',16,1);
   ELSE IF @STCLASS IS NULL
      RAISERROR ('STCLASS param required',16,1);
   ELSE IF @CHEM IS NULL
      RAISERROR ('CHEM param required',16,1);
   ELSE IF @ADR IS NULL
      RAISERROR ('ADR param required',16,1);
   ELSE IF @ORDER IS NULL
      RAISERROR ('ORDER param required',16,1);
   ELSE IF @PROFILE IS NULL
      RAISERROR ('PROFILE param required',16,1);
   ELSE IF @TEMPLATE IS NULL
      RAISERROR ('TEMPLATE param required',16,1);
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      RAISERROR ('Указанный Excel шаблон не существует в таблице Files',16,1);
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      RAISERROR ('Указанный профиль не существует в таблице MaterialDefinition',16,1);
   ELSE
      BEGIN
         DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                                  Value NVARCHAR(50));

         SELECT @OpSegmentRequirementID=sreq.ID
         FROM [dbo].[OpSegmentRequirement] sreq
              INNER JOIN [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
              INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'ORDER' AND sp.Value=@ORDER);

         IF @OpSegmentRequirementID IS NULL
            RAISERROR ('Order [%s] not found',16,1,@ORDER);

         UPDATE [dbo].[OpMaterialRequirement]
         SET [MaterialClassID] = md.[MaterialClassID],
             [MaterialDefinitionID] = md.[ID]
         FROM (SELECT [MaterialClassID],[ID]
               FROM [dbo].[MaterialDefinition]
               WHERE [ID]=@PROFILE) md
         WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

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

         MERGE [dbo].[SegmentParameter] sp
         USING (SELECT t.value,pt.ID
                FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
         ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
         WHEN MATCHED THEN
            UPDATE SET sp.[Value]=tt.value
         WHEN NOT MATCHED THEN
            INSERT ([Value],[OpSegmentRequirement],[PropertyType])
            VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
      END;
END;
GO

--------------------------------------------------------------
-- Процедура del_CreateOrder
IF OBJECT_ID ('dbo.del_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.del_CreateOrder;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_CreateOrder]
@ORDER    NVARCHAR(50)
AS
BEGIN
   DECLARE @OperationsRequestID    int,
           @OpSegmentRequirementID int;

   IF @ORDER IS NULL
      RAISERROR ('ORDER param required',16,1);

   SELECT @OpSegmentRequirementID=sreq.ID,
          @OperationsRequestID=sreq.OperationsRequest
   FROM [dbo].[OpSegmentRequirement] sreq
        INNER JOIN  [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'ORDER' AND sp.Value=@ORDER);

   IF @OpSegmentRequirementID IS NULL
      RAISERROR ('Order [%s] not found',16,1,@ORDER);

   DELETE FROM [dbo].[SegmentParameter]
   WHERE OpSegmentRequirement=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OpMaterialRequirement]
   WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

   DELETE [dbo].[OpSegmentRequirement]
   WHERE ID=@OpSegmentRequirementID;

   DELETE FROM [dbo].[OperationsRequest]
   WHERE ID=@OperationsRequestID;

END;
GO
