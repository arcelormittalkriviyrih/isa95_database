--------------------------------------------------------------
-- Процедура upd_CreateOrder
IF OBJECT_ID ('dbo.upd_CreateOrder',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_CreateOrder;
GO

CREATE PROCEDURE [dbo].[upd_CreateOrder] 
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
              INNER JOIN  [dbo].[SegmentParameter] sp ON (sp.OpSegmentRequirement=sreq.ID)
              INNER JOIN [dbo].[PropertyTypes] pt ON (pt.ID=sp.PropertyType AND pt.Value=N'ORDER' AND sp.Value=@ORDER);

         IF @OpSegmentRequirementID IS NULL
            RAISERROR ('Order [%s] not found',16,1,@ORDER);

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
