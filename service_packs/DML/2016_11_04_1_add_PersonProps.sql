SET ANSI_NULLS ON;
GO
SET NOCOUNT ON
GO
SET QUOTED_IDENTIFIER ON;
GO

DECLARE	@PersonClass_ID int,
	@WORK_WITH_ID int,
	@AD_LOGIN_ID int;

begin

SET @PersonClass_ID=NEXT VALUE FOR [dbo].gen_PersonnelClass


INSERT [dbo].PersonnelClass([ID], [ParentID], [Description]) VALUES (@PersonClass_ID, NULL, N'Весовщик')

SET @WORK_WITH_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;

INSERT [dbo].[PersonnelClassProperty] ([id], [Description], [Value], [PersonnelClassID]) VALUES (@WORK_WITH_ID, N'Работает с', N'WORK_WITH', @PersonClass_ID)

SET @AD_LOGIN_ID=NEXT VALUE FOR [dbo].gen_PersonnelClassProperty;
INSERT [dbo].[PersonnelClassProperty] ([id], [Description], [Value], [PersonnelClassID]) VALUES (@AD_LOGIN_ID, N'Active directory login', N'AD_LOGIN', @PersonClass_ID)
END
GO
