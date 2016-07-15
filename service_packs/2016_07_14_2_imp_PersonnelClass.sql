SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO


BEGIN TRANSACTION;

DECLARE @PersonClass_ID INT,
        @WORK_WITH_ID   INT,
        @AD_LOGIN_ID    INT,
        @TEST_PRINTER   INT;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PersonnelClass] WHERE [Description]=N'Специалист АСУТП')
BEGIN
   SET @PersonClass_ID=NEXT VALUE FOR [dbo].gen_PersonnelClass;
   INSERT [dbo].PersonnelClass([ID],[Description]) VALUES (@PersonClass_ID,N'Специалист АСУТП');

   SET @WORK_WITH_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@WORK_WITH_ID, N'Работает с', N'WORK_WITH', @PersonClass_ID);

   SET @AD_LOGIN_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@AD_LOGIN_ID, N'Active directory login', N'AD_LOGIN', @PersonClass_ID);

   SET @TEST_PRINTER=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@TEST_PRINTER, N'Тестовый принтер', N'TEST_PRINTER', @PersonClass_ID);
END;

IF NOT EXISTS (SELECT NULL FROM [dbo].[PersonnelClass] WHERE [Description]=N'Маркетолог')
BEGIN
   SET @PersonClass_ID=NEXT VALUE FOR [dbo].gen_PersonnelClass;
   INSERT [dbo].PersonnelClass([ID],[Description]) VALUES (@PersonClass_ID,N'Маркетолог');
   
   SET @WORK_WITH_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@WORK_WITH_ID, N'Работает с', N'WORK_WITH', @PersonClass_ID);
   
   SET @AD_LOGIN_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@AD_LOGIN_ID, N'Active directory login', N'AD_LOGIN', @PersonClass_ID);

   SET @TEST_PRINTER=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
   INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@TEST_PRINTER, N'Тестовый принтер', N'TEST_PRINTER', @PersonClass_ID);
END;

SELECT @PersonClass_ID=[ID] FROM [dbo].[PersonnelClass] WHERE [Description]=N'Маркировщик';
IF @PersonClass_ID IS NOT NULL
BEGIN
   IF NOT EXISTS (SELECT NULL FROM [dbo].[PersonnelClassProperty] WHERE [Value]=N'TEST_PRINTER' AND [PersonnelClassID]=@PersonClass_ID)
      BEGIN
         SET @TEST_PRINTER=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
         INSERT [dbo].[PersonnelClassProperty] ([ID], [Description], [Value], [PersonnelClassID]) VALUES (@TEST_PRINTER, N'Тестовый принтер', N'TEST_PRINTER', @PersonClass_ID);
      END;
END;

COMMIT;
GO
