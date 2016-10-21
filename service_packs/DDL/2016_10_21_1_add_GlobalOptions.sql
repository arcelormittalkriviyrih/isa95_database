SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID ('dbo.GlobalOptions',N'U') IS NULL
   CREATE TABLE [dbo].[GlobalOptions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OptionCode] [nvarchar](50) NOT NULL,
	[OptionName] [nvarchar](255) NOT NULL,
	[OptionValue] [nvarchar](255) NULL,
	[OptionDescription] [nvarchar](255) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	 CONSTRAINT [UK1_OptionCode] UNIQUE NONCLUSTERED 
	(
		[OptionCode] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	 CONSTRAINT [UK2_OptionName] UNIQUE NONCLUSTERED 
	(
		[OptionName] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
GO

IF OBJECT_ID ('dbo.v_GlobalOptions', N'V') IS NOT NULL
   DROP VIEW dbo.v_GlobalOptions;
GO
/*
   View: v_GlobalOptions
    Возвращает список глобальных опций и их значений.
*/
CREATE VIEW dbo.v_GlobalOptions
AS
SELECT [ID]
	  ,[OptionCode]
      ,[OptionName]
      ,[OptionValue]
      ,[OptionDescription]
  FROM [dbo].[GlobalOptions]
GO

--------------------------------------------------------------
-- Процедура upd_GlobalOption
IF OBJECT_ID ('dbo.upd_GlobalOption',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_GlobalOption;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_GlobalOption
	Процедура изменения значение глобальных опций.

	Parameters:
		OptionCode    - Код опции,
		OptionValue   - Значение опции
		
*/
CREATE PROCEDURE [dbo].[upd_GlobalOption]
@OptionCode      NVARCHAR(50),
@OptionValue     NVARCHAR(255)
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @OptionCode IS NULL
      THROW 60001, N'OptionCode param required', 1;

   SELECT @ID=o.[ID]
   FROM [dbo].[GlobalOptions] o
   WHERE o.[OptionCode]=@OptionCode;

    IF @ID IS NULL
      BEGIN
         SET @err_message = N'Global option with code=['+@OptionCode+N'] not found';
         THROW 60010, @err_message, 1;
      END;

   UPDATE [dbo].[GlobalOptions]
   SET [OptionValue]=@OptionValue
   WHERE [ID]=@ID;
  
END;
GO

--------------------------------------------------------------
-- Процедура upd_EnablePrintSystem
IF OBJECT_ID ('dbo.upd_EnablePrintSystem',N'P') IS NOT NULL
   DROP PROCEDURE dbo.upd_EnablePrintSystem;
GO

SET QUOTED_IDENTIFIER ON
GO
/*
	Procedure: upd_EnablePrintSystem
	Процедура включения/выключения системы печети бирок.

	Parameters:
		Enabled    - Система включена
		
*/
CREATE PROCEDURE [dbo].[upd_EnablePrintSystem]
@Enabled      bit
AS
BEGIN
   DECLARE @ID            INT,
           @err_message   NVARCHAR(255);

   IF @Enabled IS NULL
      THROW 60001, N'Enabled param required', 1;

   IF @Enabled=1
         EXEC dbo.upd_GlobalOption
              @OptionCode = N'PRINT_SYSTEM_ENABLED',
              @OptionValue = N'true';
  ELSE 
      EXEC dbo.upd_GlobalOption
              @OptionCode = N'PRINT_SYSTEM_ENABLED',
              @OptionValue = N'false';

  
END;
GO

----------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.get_GlobalOption', N'FN') IS NOT NULL
    DROP FUNCTION dbo.get_GlobalOption;
GO
/*
   Function: get_GlobalOption

   Функция возвращает значение глобальной опции
      
   Parameters:

       OptionCode- код опции.
     
   Returns:
	  
	  значение опции.

*/
CREATE FUNCTION dbo.get_GlobalOption(@OptionCode [nvarchar](50))
RETURNS nvarchar(255)
AS
BEGIN

DECLARE @OptionValue nvarchar(255);

SELECT @OptionValue=o.OptionValue
FROM dbo.GlobalOptions o
WHERE o.OptionCode=@OptionCode;

RETURN @OptionValue;

END;
GO
