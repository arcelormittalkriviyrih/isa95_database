SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/*
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAMPLE_WEIGHT',N'Масса образца');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'SAMPLE_LENGTH',N'Длина образца');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PROD_ORDER',N'№ заказа (производстенного)');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PROD_DATE',N'Производственная дата');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'MELT_NO',N'Плавка');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'PART_NO',N'Партия');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BUNT_NO',N'№ бунта');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'LEAVE_NO',N'№ отпуска');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'CHANGE_NO',N'№ смены');
INSERT INTO [dbo].[PropertyTypes]([Value],[Description]) VALUES (N'BRIGADE_NO',N'№ бригады');
*/

IF OBJECT_ID ('dbo.upd_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upd_WorkDefinition] 
@COMM_ORDER		NVARCHAR(50),
@PROD_ORDER		NVARCHAR(50),
@CONTRACT_NO	NVARCHAR(50),
@DIRECTION      NVARCHAR(50),
@TEMPLATE		INT,
@LENGTH			NVARCHAR(50),
@PROFILE		INT,
@ADDRESS		NVARCHAR(50) = NULL,
@BUNT_DIA		NVARCHAR(50) = NULL,
@CLASS			NVARCHAR(50) = NULL,
@MIN_ROD		NVARCHAR(50) = NULL,
@STEEL_CLASS	NVARCHAR(50) = NULL,
@PRODUCT		NVARCHAR(50) = NULL,
@STANDARD		NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL
AS
BEGIN
   DECLARE @OpSegmentRequirementID INT,
           @err_message            NVARCHAR(255);

   IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @COMM_ORDER IS NULL
    THROW 60001, N'COMM_ORDER param required', 1;
   ELSE IF @PROFILE IS NULL
    THROW 60001, N'PROFILE param required', 1;
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'TEMPLATE param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      THROW 60010, N'Указанный профиль не существует в таблице MaterialDefinition', 1;

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   SELECT @OpSegmentRequirementID=sreq.ID
   FROM [dbo].[OpSegmentRequirement] sreq
        INNER JOIN [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
        INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'COMM_ORDER' AND sp.Value=@COMM_ORDER);

   IF @OpSegmentRequirementID IS NULL
      BEGIN
         SET @err_message = N'Order [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] not found';
         THROW 60010, @err_message, 1;
      END;

   UPDATE [dbo].[OpMaterialRequirement]
   SET [MaterialClassID] = md.[MaterialClassID],
       [MaterialDefinitionID] = md.[ID]
   FROM (SELECT [MaterialClassID],[ID]
         FROM [dbo].[MaterialDefinition]
         WHERE [ID]=@PROFILE) md
   WHERE [SegmenRequirementID]=@OpSegmentRequirementID;

   INSERT @tblParams
   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
   UNION ALL
   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
   UNION ALL
   SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
   UNION ALL
   SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
   UNION ALL
   SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
   UNION ALL
   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
   UNION ALL
   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
   UNION ALL
   SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
   UNION ALL
   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
   UNION ALL
   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
   UNION ALL
   SELECT N'ADDRESS',@ADDRESS WHERE @ADDRESS IS NOT NULL
   UNION ALL
   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

   DELETE FROM [dbo].[SegmentParameter]
   WHERE [OpSegmentRequirement]=@OpSegmentRequirementID;

   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
   SELECT t.value,@OpSegmentRequirementID,pt.ID
   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);
   
   /*
   MERGE [dbo].[SegmentParameter] sp
   USING (SELECT t.value,pt.ID
          FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID)) tt
   ON (sp.OpSegmentRequirement=@OpSegmentRequirementID AND sp.PropertyType=tt.ID)
   WHEN MATCHED THEN
      UPDATE SET sp.[Value]=tt.value
   WHEN NOT MATCHED THEN
      INSERT ([Value],[OpSegmentRequirement],[PropertyType])
      VALUES (tt.value,@OpSegmentRequirementID,tt.ID);
   */

END;
GO

IF OBJECT_ID ('dbo.ins_WorkDefinition',N'P') IS NOT NULL
   DROP PROCEDURE dbo.ins_WorkDefinition;
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ins_WorkDefinition] 
@COMM_ORDER		NVARCHAR(50),
@CONTRACT_NO	NVARCHAR(50),
@DIRECTION      NVARCHAR(50),
@TEMPLATE		INT,
@LENGTH			NVARCHAR(50),
@PROFILE		INT,
@ADDRESS		NVARCHAR(50) = NULL,
@BUNT_DIA		NVARCHAR(50) = NULL,
@CLASS			NVARCHAR(50) = NULL,
@MIN_ROD		NVARCHAR(50) = NULL,
@STEEL_CLASS	NVARCHAR(50) = NULL,
@PRODUCT		NVARCHAR(50) = NULL,
@STANDARD		NVARCHAR(50) = NULL,
@CHEM_ANALYSIS  NVARCHAR(50) = NULL
AS
BEGIN
   DECLARE @OperationsRequestID     INT,
           @OpSegmentRequirementID  INT,
           @OpMaterialRequirementID INT,
           @err_message             NVARCHAR(255);

   DECLARE @tblParams TABLE(ID    NVARCHAR(50),
                            Value NVARCHAR(50));

   IF @LENGTH IS NULL
    THROW 60001, N'LENGTH param required', 1;
   ELSE IF @CONTRACT_NO IS NULL
    THROW 60001, N'CONTRACT_NO param required', 1;
   ELSE IF @DIRECTION IS NULL
    THROW 60001, N'DIRECTION param required', 1;
   ELSE IF @COMM_ORDER IS NULL
    THROW 60001, N'COMM_ORDER param required', 1;
   ELSE IF EXISTS (SELECT NULL FROM [dbo].[v_SegmentParameter_Order] WHERE [Value]=@COMM_ORDER)
      BEGIN
         SET @err_message = N'Заказ [' + CAST(@COMM_ORDER AS NVARCHAR) + N'] уже существует';
         THROW 60010, @err_message, 1;
      END;
   ELSE IF @PROFILE IS NULL
    THROW 60001, N'PROFILE param required', 1;
   ELSE IF @TEMPLATE IS NULL
    THROW 60001, N'TEMPLATE param required', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[Files] WHERE [FileType]=N'Excel label' AND [ID]=@TEMPLATE)
      THROW 60010, N'Указанный Excel шаблон не существует в таблице Files', 1;
   ELSE IF NOT EXISTS (SELECT NULL FROM [dbo].[MaterialDefinition] WHERE [ID]=@PROFILE)
      THROW 60010, N'Указанный профиль не существует в таблице MaterialDefinition', 1;
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
	   SELECT N'STANDARD',@STANDARD WHERE @STANDARD IS NOT NULL
	   UNION ALL
	   SELECT N'LENGTH',@LENGTH WHERE @LENGTH IS NOT NULL
	   UNION ALL
	   SELECT N'MIN_ROD',@MIN_ROD WHERE @MIN_ROD IS NOT NULL
	   UNION ALL
	   SELECT N'CONTRACT_NO',@CONTRACT_NO WHERE @CONTRACT_NO IS NOT NULL
	   UNION ALL
	   SELECT N'DIRECTION',@DIRECTION WHERE @DIRECTION IS NOT NULL
	   UNION ALL
	   SELECT N'PRODUCT',@PRODUCT WHERE @PRODUCT IS NOT NULL
	   UNION ALL
	   SELECT N'CLASS',@CLASS WHERE @CLASS IS NOT NULL
	   UNION ALL
	   SELECT N'STEEL_CLASS',@STEEL_CLASS WHERE @STEEL_CLASS IS NOT NULL
	   UNION ALL
	   SELECT N'CHEM_ANALYSIS',@CHEM_ANALYSIS WHERE @CHEM_ANALYSIS IS NOT NULL
	   UNION ALL
	   SELECT N'BUNT_DIA',@BUNT_DIA WHERE @BUNT_DIA IS NOT NULL
	   UNION ALL
	   SELECT N'ADDRESS',@ADDRESS WHERE @ADDRESS IS NOT NULL
	   UNION ALL
	   SELECT N'COMM_ORDER',@COMM_ORDER WHERE @COMM_ORDER IS NOT NULL
	   UNION ALL
	   SELECT N'TEMPLATE',CAST(@TEMPLATE AS NVARCHAR(50)) WHERE @TEMPLATE IS NOT NULL;

	   INSERT INTO [dbo].[SegmentParameter] ([Value],[OpSegmentRequirement],[PropertyType])
	   SELECT t.value,@OpSegmentRequirementID,pt.ID
	   FROM @tblParams t INNER JOIN [dbo].[PropertyTypes] pt ON (pt.value=t.ID);

   END;

END;
GO